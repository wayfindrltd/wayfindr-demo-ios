//
//  UserActionTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 11/11/2015.
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


/// Table view for selecting which action in User Mode to take (e.g. Catch Train, Exit Venue, etc.).
final class UserActionTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "ActionCell"
    
    /// Actions that can be taken in User Mode. Each action is displayed as a cell in the table.

    private enum Actions: Int {
        case goToPlatform
        case exitVenue
        case goToStationFacility
        
        static let allValues = [goToPlatform, exitVenue, goToStationFacility]

    }
    
    /// Interface for gathering information about the venue
    fileprivate var venueInterface: VenueInterface?
    /// Interface for interacting with beacons.
    fileprivate var interface: BeaconInterface?
    /// Model representation of entire venue.
    fileprivate var venue: WAYVenue?
    
    fileprivate let speechEngine = AudioEngine()
    
    /// Whether the controller is still parsing graph and venue data.
    fileprivate var parsingData = true
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        // Add table header view with instructions
        let tableHeaderView = UserActionTableHeaderView()
        tableHeaderView.text = WAYStrings.UserActionSelection.SelectDestination.uppercased()
        tableHeaderView.accessibilityIdentifier = WAYAccessibilityIdentifier.UserActionSelection.SelectDestinationLabel
        tableView.tableHeaderView = tableHeaderView

        
        title = "Wayfindr"
        
        // Improve voice-over by different spelling
        accessibilityLabel = "Way finder"
        
        let backButton = UIBarButtonItem(title: WAYStrings.CommonStrings.Back, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        fetchData()
        
        if !speechEngine.valid {
            displayError(title: WAYStrings.CommonStrings.Error, message: WAYStrings.ErrorMessages.AudioEngine)
        }
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
                
                if let myVenue = self.venue {
                    var validBeacons = [BeaconIdentifier]()
                    for node in myVenue.destinationGraph.graph {
                        validBeacons.append(node.beaconID)
                    }
                    
                    if !validBeacons.isEmpty {
                        self.interface?.validBeacons = validBeacons
                    }
                }
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
        return parsingData ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Actions.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }

    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let selectedAction = Actions(rawValue: indexPath.row) {
            let text: String
            let accessibilityID: String
            
            switch selectedAction {

            case .goToPlatform:
                text = WAYStrings.UserActionSelection.TrainPlatforms
                accessibilityID = WAYAccessibilityIdentifier.UserActionSelection.TrainPlatformsCell
            case .exitVenue:
                text = WAYStrings.UserActionSelection.StationExits
                accessibilityID = WAYAccessibilityIdentifier.UserActionSelection.StationExitsCell
            case .goToStationFacility:
                text = WAYStrings.UserActionSelection.StationFacilities
                accessibilityID = WAYAccessibilityIdentifier.UserActionSelection.StationFacilitiesCell
            }
            
            cell.textLabel?.text = text
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            cell.accessoryType = .disclosureIndicator
            
            cell.accessibilityIdentifier = accessibilityID
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedAction = Actions(rawValue: indexPath.row),
            let myVenue = venue,
            let myInterface = interface, myInterface.interfaceState == BeaconInterfaceState.operating {
            
            var newViewController: UIViewController?

            switch selectedAction {

            case .goToPlatform:
                let searchViewController = DestinationSearchTableViewController(interface: myInterface, venue: myVenue, transportDestinations: myVenue.platforms, speechEngine: speechEngine, pageTitle: WAYStrings.DestinationSearch.TrainPlatformSearch, searchPlaceholder: WAYStrings.DestinationSearch.SearchPlatformPlaceholder)
                
                newViewController = searchViewController
            case .exitVenue:
                let searchViewController = ExitSearchTableViewController(interface: myInterface, venue: myVenue, speechEngine: speechEngine)
                
                newViewController = searchViewController
            case .goToStationFacility:
                let searchViewController = FacilitySearchTableViewController(interface: myInterface, venue: myVenue, speechEngine: speechEngine, facilities: myVenue.stationFacilities, pageTitle: WAYStrings.StationFacilitySearch.StationFacilitySearch, searchPlaceholder: WAYStrings.StationFacilitySearch.SearchPlaceholder)

                newViewController = searchViewController
            }

            if let newViewController = newViewController {
                navigationController?.pushViewController(newViewController, animated: true)
            }
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
