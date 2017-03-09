//
//  BeaconsInRangeSelectionTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 15/12/2015.
//  Copyright (c) 2016 Wayfindr (http://www.wayfindr.net)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights 
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

import SVProgressHUD


/// Table view for selecting the a desired beacon to "pin" in the `BeaconsInRangeViewController`. Beacons are searchable.
final class BeaconsInRangeSearchTableViewController: BaseSearchTableViewController {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.

    fileprivate var interface: BeaconInterface

    
    /// List of beacons to choose from.
    fileprivate var beacons = [WAYBeacon]()
    
    
    // MARK: - Initializers
    
    /**
    Initializes a `BeaconsInRangeSearchTableViewController`.
    
    - parameter interface: Interface for interacting with beacons.
    */
    init(interface: BeaconInterface) {
        self.interface = interface
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadItems()
        
        searchController?.searchBar.placeholder = WAYStrings.BeaconsInRangeSearch.SearchPlaceholder
        searchController?.searchBar.accessibilityIdentifier = WAYAccessibilityIdentifier.BeaconsInRangeSearch.BeaconSearchBar
        
        title = WAYStrings.BeaconsInRangeSearch.BeaconSearch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear out any old beacon data
        beacons.removeAll()
        reloadItems()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interface.delegate = self
        
        SVProgressHUD.show()
        
        // Fetch new beacon data
        interface.getBeacons(completionHandler: { success, beacons, error in
            if let myBeacons = beacons, success {
                self.beacons = myBeacons.sorted { $0.minor < $1.minor }
                
                self.reloadItems()
            } else {
                self.displayError(title: "", message: WAYStrings.ErrorMessages.UnableBeacons)
                print(error ?? WAYStrings.ErrorMessages.UnableBeacons)
            }
            
            self.tableView.reloadData()
            
            SVProgressHUD.dismiss()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeaconID = itemForIndexPath(tableView, indexPath: indexPath)
        
        if let selectedBeaconIndex = beacons.index(where: { $0.identifier.description == selectedBeaconID }) {
            let selectedBeacon = beacons[selectedBeaconIndex]
            let viewController = BeaconsInRangeViewController(interface: interface, desiredBeacon: selectedBeacon.identifier)
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Convenience
    
    fileprivate func reloadItems() {
        items = beacons.map { $0.identifier.description }
    }
    
}


extension BeaconsInRangeSearchTableViewController: BeaconInterfaceDelegate {

    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        self.beacons = beacons.sorted { $0.minor < $1.minor }
        self.reloadItems()

        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
}
