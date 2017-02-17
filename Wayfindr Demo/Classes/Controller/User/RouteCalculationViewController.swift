//
//  RouteCalculationViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 18/11/2015.
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

import SwiftGraph
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



/// Calculated the route to the desired `desintation` based on the nearest beacon. Gives user option to preview all the instructions or to start route immediately.
final class RouteCalculationViewController: BaseViewController<RouteCalculationView>, BeaconInterfaceDelegate {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate var interface: BeaconInterface
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    /// Selected destination of the route.
    fileprivate let destination: WAYGraphNode
    /// Engine for speech playback.
    fileprivate let speechEngine: AudioEngine
    
    /// Calculated route from current location to `destination`.
    fileprivate var route = [WAYGraphEdge]()
    /// The nearest iBeacon, if one exists.
    fileprivate var nearestBeacon: WAYBeacon?
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(interface: BeaconInterface, venue: WAYVenue, destination: WAYGraphNode, speechEngine: AudioEngine) {
        self.interface = interface
        self.venue = venue
        self.destination = destination
        self.speechEngine = speechEngine
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WAYStrings.RouteCalculation.Routing
        
        underlyingView.yesButton.addTarget(self, action: #selector(RouteCalculationViewController.yesButtonPressed(_:)), for: .touchUpInside)
        underlyingView.skipButton.addTarget(self, action: #selector(RouteCalculationViewController.skipButtonPressed(_:)), for: .touchUpInside)
        
        let recalculateButton = UIBarButtonItem(title: WAYStrings.CommonStrings.Back, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = recalculateButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nearestBeacon = nil
        underlyingView.calculatingLabel.text = WAYStrings.RouteCalculation.CalculatingRoute
        underlyingView.calculating = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interface.delegate = self
    }
    
    
    // MARK: - BeaconInterfaceDelegate
    
    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        guard nearestBeacon == nil else {
            return
        }
        
        let filteredSortedBeacons = beacons.filter({
            if let _ = $0.accuracy {
                return true
            }
            
            return false
        }).sorted(by: {
            $0.accuracy < $1.accuracy
        })
        
        if !filteredSortedBeacons.isEmpty {
            // Calculate the inital route from the nearest beacon
            determineRoute(filteredSortedBeacons)
        }
    }
    
    
    // MARK: - Routing
    
    /**
    Determines a route based on nearby beacons. Finds the nearest beacon, calculates the route, and starts the user on the route.
    
    - parameter beacons: An array of `WAYBeacon` that shows all the nearest beacons. Array in order of nearest to farthest.
    */
    fileprivate func determineRoute(_ beacons: [WAYBeacon]) {
        let myGraph = venue.destinationGraph
        
        if let newNearestBeacon = beacons.first,
            let _ = myGraph.getNode(major: newNearestBeacon.major, minor: newNearestBeacon.minor) {
                
                nearestBeacon = newNearestBeacon
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { [weak self] in
                    guard let success = self?.calculateShortestPath() else {
                        return
                    }
                    
                    if success {
                        DispatchQueue.main.async(execute: {
                            self?.underlyingView.activityIndicator.stopAnimating()
                            self?.underlyingView.calculating = false
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            self?.underlyingView.calculatingLabel.text = WAYStrings.RouteCalculation.TroubleRouting
                            self?.nearestBeacon = nil
                        })
                    }
                })
        }
    }
    
    /**
     Calculates the shortest path based on the nearest beacon and the destination.
     
     - returns: Returns `true` if a path was calculated. Returns `false` if a path was not calculated.
     */
    fileprivate func calculateShortestPath() -> Bool {
        let myGraph = venue.destinationGraph
        
        guard let myNearestBeacon = nearestBeacon,
            let nearestNode = myGraph.getNode(major: myNearestBeacon.major, minor: myNearestBeacon.minor) else {
                return false
        }
        
        guard let shortestPath = myGraph.shortestRoute(nearestNode, toNode: destination), !shortestPath.isEmpty else {
                    
            return false
        }
        
        route = shortestPath
        
        return true
    }
    
    
    // MARK: - Button Actions
    
    /**
    Button action to preview the full set of instructions for the route.
    
    - parameter sender: Button that has been pressed.
    */
    func yesButtonPressed(_ sender: UIButton) {
        guard let myNearestBeacon = nearestBeacon else {
            return
        }
        
        let viewController = DirectionsPreviewViewController(interface: interface, venue: venue, route: route, startingBeacon: myNearestBeacon, speechEngine: speechEngine)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /**
     Button action to skip the preview and begin the route immediately.
     
     - parameter sender: Button that has been pressed.
     */
    func skipButtonPressed(_ sender: UIButton) {
        guard let myNearestBeacon = nearestBeacon else {
            return
        }
        
        let viewController = ActiveRouteViewController(interface: interface, venue: venue, route: route, startingBeacon: myNearestBeacon, speechEngine: speechEngine)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
