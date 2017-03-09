//
//  ActiveRouteViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//https://github.com/wayfindrltd/wayfindr-demo-ios/issues/6
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

/// Displays instructions to the user based on the current route.
final class ActiveRouteViewController: BaseViewController<ActiveRouteView>, BeaconInterfaceDelegate {

    
    // MARK: - Types
    
    struct ForcePlaybackOptions: OptionSet {
        let rawValue: UInt
        
        static let None = ForcePlaybackOptions(rawValue:  1 << 1)
        static let Middle = ForcePlaybackOptions(rawValue:  1 << 2)
        static let Ending = ForcePlaybackOptions(rawValue: 1 << 3)
        static let StartingOnly = ForcePlaybackOptions(rawValue: 1 << 4)
        
        static let allValues: ForcePlaybackOptions = [.None, .Middle, .Ending, .StartingOnly]
        
    }
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate var interface: BeaconInterface
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    /// Engine for speech playback.
    fileprivate let speechEngine: AudioEngine
    
    /// Calculated route from current location to `destination`.
    fileprivate var route: [WAYGraphEdge]
    /// Nodes along the calculated route from current location to `destination`.
    fileprivate var routeNodes = [WAYGraphNode]()
    /// The nearest iBeacon, if one exists.
    fileprivate var nearestBeacon: WAYBeacon
    
    fileprivate var firstInstruction = true
    
    fileprivate var firstAppearance = true
    
    fileprivate var nextButton = UIBarButtonItem()
    
    fileprivate let originalRoute: [WAYGraphEdge]
    
    /// A stopwatch for mesuring the time from start to end for each route. Can be switched off in WAYSettings
    private var stopwatch: Stopwatch?
    
    // MARK: - Intiailizers / Deinitializers
    
    init(interface: BeaconInterface, venue: WAYVenue, route: [WAYGraphEdge], startingBeacon: WAYBeacon, speechEngine: AudioEngine) {
        self.interface = interface
        self.venue = venue
        self.route = route
        self.nearestBeacon = startingBeacon
        self.speechEngine = speechEngine
        
        self.originalRoute = route
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WAYDeveloperSettings.DeveloperSettingsChangedNotification), object: nil)
        
        stopwatch?.stop()
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = WAYStrings.ActiveRoute.ActiveRoute
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActiveRouteViewController.voiceOverStatusChanged), name: NSNotification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActiveRouteViewController.developerSettingsChanged), name: NSNotification.Name(rawValue: WAYDeveloperSettings.DeveloperSettingsChangedNotification), object: nil)
        
        nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ActiveRouteViewController.nextButtonPressed(_:)))
        
        if WAYConstants.WAYSettings.stopwatchEnabled {
            stopwatch = Stopwatch()
            stopwatch?.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            extractNodesFromRoute()
        }
        
        developerSettingsChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interface.delegate = self
        
        speechEngine.textView = underlyingView.textView
        speechEngine.repeatButton = underlyingView.repeatButton
        
        if firstAppearance {
            firstAppearance = false

            if UIAccessibilityIsVoiceOverRunning() {
                beginRouteWithDelay(delay: 2)
            } else {
                beginRoute()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        interface.delegate = nil
        
        speechEngine.stopPlayback()
        speechEngine.textView = nil
        speechEngine.repeatButton = nil
    }
    
    /**
     Finishes setting up the view.
     */
    override func setupView() {
        super.setupView()
        
        underlyingView.repeatButton.addTarget(self, action: #selector(ActiveRouteViewController.repeatButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    // MARK: - BeaconInterfaceDelegate
    
    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        
        let filteredSortedBeacons = filteredSorted(beacons: beacons)
        
        if !filteredSortedBeacons.isEmpty {
            
            guard let nextBeacon = filteredSortedBeacons.first,
                let fromNode = venue.destinationGraph.getNode(major: nearestBeacon.major, minor: nearestBeacon.minor),
                let toNode = venue.destinationGraph.getNode(major: nextBeacon.major, minor: nextBeacon.minor)
                else {
                
                return
            }
            
            
            if WAYConstants.WAYSettings.strictRouting {
                // Check if the next beacon is next in the route before we continue
                
                if toNode.isNext(in: originalRoute, from: fromNode) {
                    // Continue the route from the nearest beacon
                    
                    continueRoute(filteredSortedBeacons)
                }
            } else {
                
                continueRoute(filteredSortedBeacons)
            }
        }
    }
    
    private func filteredSorted(beacons: [WAYBeacon]) -> [WAYBeacon] {
        
        return beacons.filter({
            
            if WAYConstants.WAYSettings.locateNearestBeaconUsingRssi {
                
                if let _ = $0.rssi {
                    return true
                }
            } else {
                
                if let _ = $0.accuracy {
                    return true
                }
            }
            
            return false
            
        }).sorted(by: {
            
            if WAYConstants.WAYSettings.locateNearestBeaconUsingRssi {
                
                if let lhsRssi = $0.rssi, let rhsRssi = $1.rssi {
                    
                    return lhsRssi > rhsRssi
                }
            } else {
                
                if let lhsAccuracy = $0.accuracy, let rhsAccuracy = $1.accuracy {
                    
                    return lhsAccuracy < rhsAccuracy
                }
            }
            
            return false
        })
    }
    
    // MARK: - Routing
    
    /**
     Extracts the nodes from the `route` and copys them into `routeNodes`.
     */
    fileprivate func extractNodesFromRoute() {
        routeNodes.removeAll()
        
        guard !route.isEmpty else {
            return
        }
        
        let myGraph = venue.destinationGraph
        
        if let firstNode = myGraph.getNode(identifier: route[0].sourceID) {
            routeNodes.append(firstNode)
        }
        
        for routeItem in route {
            if let nextNode = myGraph.getNode(identifier: routeItem.targetID) {
                routeNodes.append(nextNode)
            }
        }
    }
    
    /**
     Starts the user on the `route`.
     */

    private func beginRouteWithDelay(delay: Double) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.beginRoute()
        }
    }

    
    fileprivate func beginRoute() {

        guard !route.isEmpty else {
            underlyingView.textView.text = WAYStrings.ActiveRoute.UnableToRoute
            underlyingView.repeatButton.isHidden = true
            
            return
        }

        if let beginning = route[0].instructions.beginning {
            let prefix = String(format: WAYStrings.ActiveRoute.FirstInstructionPrefixFormat, WAYStrings.ActiveRoute.FirstInstructionPrefix)

            underlyingView.textView.text = prefix + beginning
            playNextInstruction(forcePlayback: .None, prefix: prefix)
        } else if let middle = route[0].instructions.middle {
            underlyingView.textView.text = middle
            playNextInstruction(forcePlayback: .Middle)
        } else if let _ = route[0].instructions.ending {
            
        } else if let startingOnly = route[0].instructions.startingOnly {
            underlyingView.textView.text = startingOnly
            playNextInstruction(forcePlayback: .StartingOnly)
        }
    }
    
    /**
     Continues the `route` based on the nearby beacons.
     
     - parameter beacons: An array of `WAYBeacon` that shows all the nearest beacons. Array in order of nearest to farthest.
     */
    fileprivate func continueRoute(_ beacons: [WAYBeacon]) {
        guard !route.isEmpty && !firstInstruction else {
            return
        }
        
        let myGraph = venue.destinationGraph
        
        let filteredBeacons = beacons.filter({$0.accuracy >= 0.0})
        
        for beacon in filteredBeacons {
            if beacon.identifier == nearestBeacon.identifier {
                continue
            }
            
            if let node = myGraph.getNode(major: beacon.major, minor: beacon.minor),
                WAYGraph.beacon(beacon: beacon, isWithinRangeOf: node, isUsingRssi: WAYConstants.WAYSettings.locateNearestBeaconUsingRssi) {
                
                let routeItem = route[0]
                
                if routeItem.targetID == node.identifier {
                    // We've completed this route item, move onto the next one.
                    
                    nearestBeacon = beacon
                    
                    playNextInstruction()
                    
                    return
                } else if let routeIndex = routeNodes.index(of: node) {
                    // We've skipped a beacon (or a few) for some reason. Continue the route from this new point.

                    skipToInstruction(routeIndex)

                    nearestBeacon = beacon
                    
                    return
                }
            }
        }
    }
    
    
    // MARK: - Playback
    
    /**
     Plays the next instruction(s) on the `route`.
    
    - parameter forcePlayback: Option set to force playback of specific instructions immediately (e.g. the `middle` instruction). Default value is `None`.
     */

    fileprivate func playNextInstruction(forcePlayback: ForcePlaybackOptions = .None, prefix: String? = nil) {
        
        var timeInterval: TimeInterval = 0
        
        if !firstInstruction {
            let routeItem = route[0]
            
            // Check if there are upcomming instructions
            if route.count > 1 &&
                route[1].instructions.beginning != nil {
                    // Stop any currently playing instructions in case we have a speedy walker
                    speechEngine.stopPlayback()
            }
            
            // Play ending instruction from previous `routeItem`
            if let ending = routeItem.instructions.ending {
                if route.count == 1 {
                    speechEngine.playArrivalInstruction(ending)
                    stopwatch?.stop()
                } else {
                    speechEngine.playInstruction(ending)
                }
            }
            
            // Remove finished routeItem
            route.removeFirst()
            
            // Check to see if we have completed the route
            if route.isEmpty {
                return
            }
        } else {
            firstInstruction = false
            stopwatch?.start()
        }
        
        routeNodes.removeFirst()
        
        // Play beginning instruction from next `routeItem`
        if let beginning = route[0].instructions.beginning {
            speechEngine.playInstruction((prefix ?? "") + beginning)
        }
        
        if let middle = route[0].instructions.middle {
            if forcePlayback.contains(.Middle) {
                speechEngine.playInstruction(middle)
            } else {
                // Play the middle instruction from next `routeItem` halfway between the beacons
                timeInterval = route[0].weight
                
                speechEngine.playInstruction(middle, delayInterval: timeInterval / 2.0)
            }
        }
        
        if forcePlayback.contains(.StartingOnly),
            let startingOnly = route[0].instructions.startingOnly {
            speechEngine.playInstruction(startingOnly)
        }
    }
    
    /**
     Skips to node at `index` in `routeNodes` and plays the next instruction(s).
     
     - parameter index: Index of the next beacon in `routeNodes`.
     */

    fileprivate func skipToInstruction(_ index: Int) {
        guard index < route.count && index > 1 else {
            return
        }
        
        route.removeSubrange(0 ..< index - 1)
        routeNodes.removeSubrange(0 ..< index - 1)

        
        playNextInstruction()
    }
    
    
    // MARK: - Button Actions
    
    func nextButtonPressed(_ sender: UIBarButtonItem) {
        playNextInstruction()
    }
    
    /**
    Initiate a repeat of the current instruction displayed to the user.
    
    - parameter sender: Button calling the action.
    */
    func repeatButtonPressed(_ sender: UIButton) {
        guard let myInstruction = speechEngine.currentInstruction else {
            return
        }

        if UIAccessibilityIsVoiceOverRunning() {
            speechEngine.playInstruction(myInstruction, delayInterval: 1)
        } else {
            speechEngine.playInstruction(myInstruction)
        }
    }
    
    
    // MARK: - Accessibility
    
    /**
    Display `repeatButton` only when VoiceOver is turned off. Otherwise it is redundant.
    */
    func voiceOverStatusChanged() {
        if !WAYDeveloperSettings.sharedInstance.showRepeatButton {
            underlyingView.repeatButton.isHidden = UIAccessibilityIsVoiceOverRunning()
        }
    }
    
    
    // MARK: - Developer Settings
    
    func developerSettingsChanged() {
        voiceOverStatusChanged()
        
        let rightButton: UIBarButtonItem? = WAYDeveloperSettings.sharedInstance.showForceNextButton ? nextButton : nil
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    
}

// MARK: - Stopwatch

extension ActiveRouteViewController: StopwatchDelegate {
    
    func stopwatch(stopwatch: Stopwatch, timeDidUpdate timeText: String) {
        
        underlyingView.timeLabel.text = timeText
    }
}
