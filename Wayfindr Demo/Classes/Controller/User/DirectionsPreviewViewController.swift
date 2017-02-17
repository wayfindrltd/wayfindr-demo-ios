//
//  DirectionsPreviewTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/11/2015.
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
import CoreLocation


/// Displays all the instructions for the route to the user.
final class DirectionsPreviewViewController: BaseViewController<DirectionsPreviewView> {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate let interface: BeaconInterface
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    /// Engine for speech playback.
    fileprivate let speechEngine: AudioEngine
    
    /// Calculated route from current location to `destination`.
    fileprivate var route: [WAYGraphEdge]
    
    /// The nearest iBeacon.
    fileprivate var nearestBeacon: WAYBeacon
    
    /// Button to skip the remainder of the preview.
    fileprivate var skipButton = UIBarButtonItem()
    
    fileprivate let previewTableView: DirectionsPreviewTableViewController
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(interface: BeaconInterface, venue: WAYVenue, route: [WAYGraphEdge], startingBeacon: WAYBeacon, speechEngine: AudioEngine) {
        self.interface = interface
        self.venue = venue
        self.route = route
        self.nearestBeacon = startingBeacon
        self.speechEngine = speechEngine
        
        var directions = [DirectionData]()
        for (index, routeItem) in route.enumerated() {
            let allInstructions = routeItem.instructions.allInstructions()
            
            if !allInstructions.isEmpty {
                for instruction in allInstructions {
                    let datum = DirectionData(instruction: instruction, pathIndex: index)
                    directions.append(datum)
                }
            } else if index == 0, let instruction = routeItem.instructions.startingOnly {
                let datum = DirectionData(instruction: instruction, pathIndex: index)
                directions.append(datum)
            }
        }
        self.previewTableView = DirectionsPreviewTableViewController(directions: directions)
        
        super.init()
        
        addChildViewController(previewTableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WAYStrings.DirectionsPreview.Title
        
        accessibilityLabel = WAYAccessibilityLabel.DirectionsPreview.PreviewDirections
        
        underlyingView.beginRouteButton.addTarget(self, action: #selector(DirectionsPreviewViewController.beginRoute), for: .touchUpInside)
        underlyingView.stackView.insertArrangedSubview(previewTableView.tableView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previewTableView.tableView.reloadData()
    }
    
    
    // MARK: - Button Actions
    
    /**
     Begins the route.
     */
    func beginRoute() {
        let viewController = ActiveRouteViewController(interface: interface, venue: venue, route: route, startingBeacon: nearestBeacon, speechEngine: speechEngine)
        
        // Replace current view with the active route
        if var viewControllers = navigationController?.viewControllers {
            viewControllers[viewControllers.count - 1] = viewController
            
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
}


// MARK: - DirectionsPreviewTableViewController

/// Displays all the instructions for the route to the user in a table.
final class DirectionsPreviewTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "DirectionsCell"
    
    /// Full array of instructions (strings) for the route.
    fileprivate let directions: [DirectionData]
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(directions: [DirectionData]) {
        self.directions = directions
        
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
        
        if directions.isEmpty {
            displayError(title: WAYStrings.ErrorTitles.NoDirections, message: WAYStrings.ErrorMessages.NoDirections)
        }
    }
    
    
    // MARK: - UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        let numberString = NumberFormatter.localizedString(from: NSNumber(integerLiteral: indexPath.row + 1), number: .decimal)
        cell.textLabel?.text = "\(numberString). " + directions[indexPath.row].instruction
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}


// MARK: - DirectionData

/**
 *  Data structure to house the instruction and the index in `route` from which it came.
 */
struct DirectionData {
    let instruction: String
    let pathIndex: Int
    
    init(instruction: String, pathIndex: Int) {
        self.instruction = instruction
        self.pathIndex = pathIndex
    }
}
