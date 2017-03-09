//
//  KeyRoutePathsTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 20/11/2015.
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

import SwiftGraph
import SVProgressHUD


/**
 *  Data structure storing information regarding a key route.
 */
struct KeyRouteData {
    /// Name of the route
    let name: String
    /// Total travel time of the route
    let travelTime: Double
    /// Edges (in order) for the walk of the route
    let route: [WAYGraphEdge]
    
    /**
     Initialize a `KeyRouteData`.
     
     - parameter name:  Name of the route
     - parameter route: Edges (in order) for the walk of the route
     */
    init(name: String, route: [WAYGraphEdge]) {
        self.name = name
        self.route = route
        
        self.travelTime = route.reduce(0.0, {$0 + $1.weight})
    }
}


/// Table view for displaying information about available key routes (i.e. those between platforms and exits).
final class KeyRoutePathsTableViewController: UITableViewController {

    typealias KeyRoutesFrom = (name: String, routes: [KeyRoutesDestination])
    typealias KeyRoutesDestination = (name: String, routes: [KeyRouteData])

    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "RouteCell"
    
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    
    /// Whether the controller is still computing missing routes.

    fileprivate var parsingData = true {
        didSet {
            updateProgress()
        }
    }
    
    /// Table segmented control to filter the key routes
    private var segmentedControl = UISegmentedControl()
    
    /// Array of all the currently available routes.
    fileprivate var keyRoutes = [KeyRoutesFrom]()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(venue: WAYVenue) {
        self.venue = venue
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
        parsingData = false
    }


    // MARK: - Private helper methods

    private func updateProgress() {
        if parsingData {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }


    @objc private func reloadTable() {
        tableView.reloadData()
    }


    private func reloadSegmentControl() {
        segmentedControl.removeAllSegments()

        for keyRouteFrom in keyRoutes {
            segmentedControl.insertSegment(withTitle: keyRouteFrom.name, at: segmentedControl.numberOfSegments, animated: false)
        }

        segmentedControl.selectedSegmentIndex = 0
    }


    // MARK: - Setup

    private func setup() {
        setupSegmentedControl()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        title = WAYStrings.KeyRoutePaths.KeyPaths

        setupRoutes()
    }

    private func setupSegmentedControl() {
        let segmentedControlView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        segmentedControlView.addSubview(segmentedControl)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = WAYConstants.WAYColors.Developer
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 9)], for: .normal)
        segmentedControl.addTarget(self, action: #selector(reloadTable), for: .valueChanged)

        let top = segmentedControl.topAnchor.constraint(equalTo: segmentedControlView.topAnchor)
        top.isActive = true
        top.constant = 5

        let bottom = segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlView.bottomAnchor)
        bottom.isActive = true
        bottom.constant = -5

        let leading = segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor)
        leading.isActive = true
        leading.constant = 5

        let trailing = segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlView.trailingAnchor)
        trailing.isActive = true
        trailing.constant = -5

        tableView.tableHeaderView = segmentedControlView
    }

    private func setupRoutes() {
        parsingData = true
        SVProgressHUD.show()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { [weak self] in
            self?.determineKeyRoutes()
            self?.parsingData = false
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                self?.reloadSegmentControl()
                self?.tableView.reloadData()
            })
        })
    }
    
    
    // MARK: - Setup
    
    /**
     Calculates all the missing key routes (those between platforms and exits) and adds them to the  `missingRoutes` array.
     */

    private func determineKeyRoutes() {
        keyRoutes.append(determineKeyRoutesFrom(destinations: venue.platforms, withName: "Platform"))
        keyRoutes.append(determineKeyRoutesFrom(destinations: venue.exits, withName: "Entrance"))
        keyRoutes.append(determineKeyRoutesFrom(destinations: venue.stationFacilities, withName: "Station Facility"))
    }

    private func determineKeyRoutesFrom<T: WAYDestination>(destinations: [T], withName name: String) -> KeyRoutesFrom {
        var keyRoutesDestinations = [KeyRoutesDestination]()

        var toPlatformRoutes = KeyRoutesDestination(name: "Platform", routes: [KeyRouteData]())
        var toExitRoutes = KeyRoutesDestination(name: "Exit", routes: [KeyRouteData]())
        var toStationFacilityRoutes = KeyRoutesDestination(name: "Station Facility", routes: [KeyRouteData]())


        for destination in destinations {
            toPlatformRoutes.routes.append(contentsOf: determineKeyRoutesFrom(destination: destination, withName: name, toDestinations: venue.platforms, withName: toPlatformRoutes.name))
            toExitRoutes.routes.append(contentsOf: determineKeyRoutesFrom(destination: destination, withName: name, toDestinations: venue.exits, withName: toExitRoutes.name))
            toStationFacilityRoutes.routes.append(contentsOf: determineKeyRoutesFrom(destination: destination, withName: name, toDestinations: venue.stationFacilities, withName: toStationFacilityRoutes.name))
        }

        keyRoutesDestinations.append(toPlatformRoutes)
        keyRoutesDestinations.append(toExitRoutes)
        keyRoutesDestinations.append(toStationFacilityRoutes)

        return KeyRoutesFrom(name: name, routes: keyRoutesDestinations)
    }

    private func determineKeyRoutesFrom<T: WAYDestination, W: WAYDestination>(destination: T, withName fromName: String, toDestinations destinations: [W], withName toName: String) -> [KeyRouteData] {

        let venueGraph = venue.destinationGraph
        let startNode = destination.exitNode

        var routes = [KeyRouteData]()

        for toDestination in destinations {
            if destination.name == toDestination.name { continue }

            let destinationNode = toDestination.entranceNode

            if venueGraph.canRoute(startNode, toNode: destinationNode) {
                if let route = venue.destinationGraph.shortestRoute(startNode, toNode: destinationNode) {
                    let routeName = "\(fromName) \(destination.name) to \(toName) \(toDestination.name)"

                    let keyRoute = KeyRouteData(name: routeName, route: route)
                    routes.append(keyRoute)
                }
            }
        }

        return routes
    }
    
    
    // MARK: - UITableViewDatasource
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let routes = parsingData ? [] : keyRoutes[segmentedControl.selectedSegmentIndex].routes

        return routes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard segmentedControl.selectedSegmentIndex != -1 else {
            return 0
        }
        let routes = keyRoutes[segmentedControl.selectedSegmentIndex].routes[section].routes

        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath)

        let routes = keyRoutes[segmentedControl.selectedSegmentIndex].routes
        let routeData = routes[indexPath.section].routes[indexPath.row]

        
        cell.textLabel?.text = routeData.name + " (\(routeData.travelTime)s)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let from = keyRoutes[segmentedControl.selectedSegmentIndex]
        let routes = from.routes[section]

        return "from \(from.name) to \(routes.name)"
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let routes = keyRoutes[segmentedControl.selectedSegmentIndex].routes
        let routeData = routes[indexPath.section].routes[indexPath.row]
        
        let viewController = KeyRoutePathsDetailViewController(routeData: routeData)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
