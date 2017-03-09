//
//  BatteryLevelsTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 09/12/2015.
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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//https://github.com/wayfindrltd/wayfindr-demo-ios/issues/6
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



/// Filters for `BatteryLevelsTableViewController`
enum BatteryLevelFilters {
    case battery
    case date
    case minor
    
    var description: String {
        switch self {
        case .battery:
            return WAYStrings.CommonStrings.Battery
        case .date:
            return WAYStrings.CommonStrings.DateWord
        case .minor:
            return WAYStrings.CommonStrings.Minor
        }
    }
    
    static let allValues = [minor, date, battery]
}


/// Displays all the beacons and their respective battery levels.
final class BatteryLevelsTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "BeaconCell"
    
    /// Interface for interacting with beacons.

    private var interface: BeaconInterface
    
    /// Whether the controller is still fetching beacon information.
    fileprivate var fetchingData = true {
        didSet {
            if fetchingData {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    /// Beacon data to display in table. Each beacon is represented by a cell.
    fileprivate var beacons = [WAYBeacon]()
    
    /// Header for the `UITableView`.
    fileprivate let headerView = BatteryLevelsHeaderView()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    /**
    Initializes a `BatteryLevelsTableViewController`.
    
    - parameter interface: `BeaconInterface` for getting current beacon battery levels.
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
        
        tableView.register(SubtitledDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = WAYConstants.WAYSizes.EstimatedCellHeight
        
        headerView.segmentControl.addTarget(self, action: #selector(BatteryLevelsTableViewController.segmentedControlValueChanged(_:)), for: .valueChanged)
        
        title = WAYStrings.CommonStrings.BatteryLevels
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchingData = true
        tableView.reloadData()

        interface.delegate = self
        
        SVProgressHUD.show()
        
        interface.getBeacons(completionHandler: { success, beacons, error in
            self.fetchingData = false
            
            if let myBeacons = beacons, success {
                self.beacons = myBeacons
                
                let filterMode = BatteryLevelFilters.allValues[self.headerView.segmentControl.selectedSegmentIndex]
                self.sortBeacons(filterMode)
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
        
        fetchingData = false
    }
    
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchingData ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let myCell = cell as? SubtitledDetailTableViewCell {
            let beacon = beacons[indexPath.row]
            
            myCell.mainTextLabel.text = "\(WAYStrings.CommonStrings.Major): \(beacon.major) \(WAYStrings.CommonStrings.Minor): \(beacon.minor)"
            
            let subtitleText: String
            if let lastUpdated = beacon.lastUpdated {
                subtitleText = "\(WAYStrings.BatteryLevel.Updated): \(DateFormatter.localizedString(from: lastUpdated as Date, dateStyle: .medium, timeStyle: .short))"
            } else {
                subtitleText = "\(WAYStrings.BatteryLevel.Updated): \(WAYStrings.CommonStrings.Unknown)"
            }
            myCell.subtitleTextLabel.text = subtitleText
            
            let rightText: String
            if let batteryLevel = beacon.batteryLevel {
                rightText = batteryLevel + "%"
            } else {
                rightText = WAYStrings.CommonStrings.Unknown
            }
            myCell.rightValueLabel.text = rightText
            myCell.rightValueLabel.textColor = WAYConstants.WAYColors.Maintainer
            
            myCell.selectionStyle = .none
            
            myCell.setNeedsLayout()
        }
        
        return cell
    }
    
    
    // MARK: - Control Actions
    
    /**
    Action for when the filter `UISegmentedControl` value is changed. Changes sorting of beacons in `UITableView`.
    
    - parameter sender: `UISegmentedControl` whose value was changed.
    */
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let filterMode = BatteryLevelFilters.allValues[sender.selectedSegmentIndex]
        
        sortBeacons(filterMode)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Convenience
    
    /**
    Sort the `beacons` array based on `sortMethod`.
    
    - parameter sortMethod: Method to use for sorting.
    */
    fileprivate func sortBeacons(_ sortMethod: BatteryLevelFilters) {
        switch sortMethod {
        case .battery:
            beacons.sort {Int($0.batteryLevel ?? "-1")! < Int($1.batteryLevel ?? "-1")!}
        case .date:
            beacons.sort {$0.lastUpdated?.timeIntervalSince1970 < $1.lastUpdated?.timeIntervalSince1970}
        case .minor:
            beacons.sort {$0.minor < $1.minor}
        }
    }
    
}


extension BatteryLevelsTableViewController: BeaconInterfaceDelegate {

    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        self.fetchingData = false
        self.beacons = beacons

        let filterMode = BatteryLevelFilters.allValues[self.headerView.segmentControl.selectedSegmentIndex]
        self.sortBeacons(filterMode)

        self.tableView.reloadData()
    }
}
