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


/// Filters for `BatteryLevelsTableViewController`
enum BatteryLevelFilters {
    case Battery
    case Date
    case Minor
    
    var description: String {
        switch self {
        case .Battery:
            return WAYStrings.CommonStrings.Battery
        case .Date:
            return WAYStrings.CommonStrings.DateWord
        case .Minor:
            return WAYStrings.CommonStrings.Minor
        }
    }
    
    static let allValues = [Minor, Date, Battery]
}


/// Displays all the beacons and their respective battery levels.
final class BatteryLevelsTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    private let reuseIdentifier = "BeaconCell"
    
    /// Interface for interacting with beacons.
    private let interface: BeaconInterface
    
    /// Whether the controller is still fetching beacon information.
    private var fetchingData = true
    
    /// Beacon data to display in table. Each beacon is represented by a cell.
    private var beacons = [WAYBeacon]()
    
    /// Header for the `UITableView`.
    private let headerView = BatteryLevelsHeaderView()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    /**
    Initializes a `BatteryLevelsTableViewController`.
    
    - parameter interface: `BeaconInterface` for getting current beacon battery levels.
    */
    init(interface: BeaconInterface) {
        self.interface = interface
        
        super.init(style: .Plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SubtitledDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = WAYConstants.WAYSizes.EstimatedCellHeight
        
        headerView.segmentControl.addTarget(self, action: #selector(BatteryLevelsTableViewController.segmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        
        title = WAYStrings.CommonStrings.BatteryLevels
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchingData = true
        tableView.reloadData()
        
        SVProgressHUD.show()
        
        interface.getBeacons(completionHandler: { success, beacons, error in
            self.fetchingData = false
            
            if let myBeacons = beacons where success {
                self.beacons = myBeacons
                
                let filterMode = BatteryLevelFilters.allValues[self.headerView.segmentControl.selectedSegmentIndex]
                self.sortBeacons(filterMode)
            } else {
                self.displayError(title: "", message: WAYStrings.ErrorMessages.UnableBeacons)
                print(error)
            }
            
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchingData ? 0 : 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let myCell = cell as? SubtitledDetailTableViewCell {
            let beacon = beacons[indexPath.row]
            
            myCell.mainTextLabel.text = "\(WAYStrings.CommonStrings.Major): \(beacon.major) \(WAYStrings.CommonStrings.Minor): \(beacon.minor)"
            
            let subtitleText: String
            if let lastUpdated = beacon.lastUpdated {
                subtitleText = "\(WAYStrings.BatteryLevel.Updated): \(NSDateFormatter.localizedStringFromDate(lastUpdated, dateStyle: .MediumStyle, timeStyle: .ShortStyle))"
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
            
            myCell.selectionStyle = .None
            
            myCell.setNeedsLayout()
        }
        
        return cell
    }
    
    
    // MARK: - Control Actions
    
    /**
    Action for when the filter `UISegmentedControl` value is changed. Changes sorting of beacons in `UITableView`.
    
    - parameter sender: `UISegmentedControl` whose value was changed.
    */
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        let filterMode = BatteryLevelFilters.allValues[sender.selectedSegmentIndex]
        
        sortBeacons(filterMode)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Convenience
    
    /**
    Sort the `beacons` array based on `sortMethod`.
    
    - parameter sortMethod: Method to use for sorting.
    */
    private func sortBeacons(sortMethod: BatteryLevelFilters) {
        switch sortMethod {
        case .Battery:
            beacons.sortInPlace {Int($0.batteryLevel ?? "-1")! < Int($1.batteryLevel ?? "-1")!}
        case .Date:
            beacons.sortInPlace {$0.lastUpdated?.timeIntervalSince1970 < $1.lastUpdated?.timeIntervalSince1970}
        case .Minor:
            beacons.sortInPlace {$0.minor < $1.minor}
        }
    }
    
}
