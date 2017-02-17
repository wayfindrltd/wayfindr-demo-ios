//
//  DeveloperActionSelectionTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 21/12/2015.
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

import AEXML
import SwiftyJSON
import SVProgressHUD


/// Table view for selecting which action in Developer Mode to take (e.g. Graph Validation, Missing Key Routes, etc.).
final class DeveloperActionSelectionTableView: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "ActionCell"
    
    /// Actions that can be taken in Developer Mode. Each action is displayed as a cell in the table.
    fileprivate enum DeveloperActions: Int {
        case dataExport
        case developerOptions
        case graphValidation
        case keyRoutePaths
        case missingKeyRoutes
        
        static let allValues = [dataExport, developerOptions, graphValidation, keyRoutePaths, missingKeyRoutes]
    }
    
    /// Interface for gathering information about the venue
    fileprivate var venueInterface: VenueInterface?
    /// Interface for interacting with beacons.
    fileprivate var interface: BeaconInterface?
    /// Model representation of entire venue.
    fileprivate var venue: WAYVenue?
    
    /// Whether the controller is still parsing graph and venue data.
    fileprivate var parsingData = true
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = WAYStrings.CommonStrings.Developer
        
        let backButton = UIBarButtonItem(title: WAYStrings.CommonStrings.Back, style: .plain, target: nil, action: nil)
        backButton.accessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.BackBarButtonItem
        navigationItem.backBarButtonItem = backButton
        
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - Setup
    
    /**
    Sets up the `BeaconInterface`.
    */
    fileprivate func setupBeaconInterface() {
        guard let myVenueInterface = venueInterface else {
            return
        }
        
        myVenueInterface.getBeaconInterface(completionHandler: { success, newInterface, error in
            if success, let myInterface = newInterface {
                self.interface = myInterface
            } else if let myError = error, case .failedInitialization(let localizedDescription) = myError {
                self.displayError(title: "", message: localizedDescription)
            } else {
                self.displayError(title: "", message: WAYStrings.ErrorMessages.UnknownError)
            }
        })
    }
    
    
    // MARK: - Load Data
    
    
    fileprivate func fetchData() {
        SVProgressHUD.show()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { [weak self] in
            self?.loadData()
            self?.parsingData = false
            
            DispatchQueue.main.async(execute: {
                self?.tableView.reloadData()
                SVProgressHUD.dismiss()
                
                self?.setupBeaconInterface()
            })
        })
    }
    
    /**
     Loads all of the data for the venue (both GraphML and JSON). If there is a failure, an alert is presented to the user.
     */
    fileprivate func loadData() {
        venueInterface = DemoVenueInterface()
        
        guard let myVenueInterface = venueInterface else {
            displayError(title: "", message: "Unable to find venue.")
            return
        }
        
        myVenueInterface.getVenue(completionHandler: { success, newVenue, error in
            if success, let myVenue = newVenue {
                self.venue = myVenue
            } else if let myError = error {
                self.displayError(title: WAYStrings.ErrorTitles.VenueLoading, message: myError.description)
            } else {
                self.displayError(title: WAYStrings.ErrorTitles.VenueLoading, message: WAYStrings.ErrorMessages.UnknownError)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperActions.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var text: String?
        var cellAccessibilityIdentifier: String?
        
        if let selectedAction = DeveloperActions(rawValue: indexPath.row) {
            switch selectedAction {
            case .dataExport:
                text = WAYStrings.CommonStrings.DataExport
                cellAccessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.DataExportCell
            case .developerOptions:
                text = WAYStrings.CommonStrings.DeveloperOptions
                cellAccessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.DeveloperOptionsCell
            case .graphValidation:
                text = WAYStrings.DeveloperActionSelection.GraphValidation
                cellAccessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.GraphValidationCell
            case .keyRoutePaths:
                text = WAYStrings.DeveloperActionSelection.KeyRoutePaths
                cellAccessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.KeyRoutePathsCell
            case .missingKeyRoutes:
                text = WAYStrings.DeveloperActionSelection.MissingKeyRoutes
                cellAccessibilityIdentifier = WAYAccessibilityIdentifier.DeveloperActionSelection.MissingKeyRoutesCell
            }
        }
        
        guard let myText = text,
            let myCellAccessibilityIdentifier = cellAccessibilityIdentifier else {
                return
        }
        
        cell.textLabel?.text = myText
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.accessoryType = .disclosureIndicator
        
        cell.accessibilityIdentifier = myCellAccessibilityIdentifier
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let myVenue = venue,
            let myVenueInterface = venueInterface else {
                return
        }
        
        var newViewController: UIViewController?
        
        if let selectedAction = DeveloperActions(rawValue: indexPath.row) {
            switch selectedAction {
            case .dataExport:
                newViewController = DataExportViewController(venue: myVenue)
            case .missingKeyRoutes:
                newViewController = MissingKeyRoutesTableViewController(venue: myVenue)
            case .keyRoutePaths:
                newViewController = KeyRoutePathsTableViewController(venue: myVenue)
            case .developerOptions:
                newViewController = DeveloperOptionsTableViewController()
            case .graphValidation:
                newViewController = GraphValidationViewController(venueInterface: myVenueInterface)
            }
        }
        
        guard let myNewViewController = newViewController else {
            return
        }
        
        navigationController?.pushViewController(myNewViewController, animated: true)
    }
}
