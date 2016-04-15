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


/// Displays instructions to the user based on the current route.
final class ActiveRouteViewController: BaseViewController<ActiveRouteView>, BeaconInterfaceDelegate {

    
    // MARK: - Types
    
    struct ForcePlaybackOptions: OptionSetType {
        let rawValue: UInt
        
        static let None = ForcePlaybackOptions(rawValue:  1 << 1)
        static let Middle = ForcePlaybackOptions(rawValue:  1 << 2)
        static let Ending = ForcePlaybackOptions(rawValue: 1 << 3)
        static let StartingOnly = ForcePlaybackOptions(rawValue: 1 << 4)
        
        static let allValues: ForcePlaybackOptions = [.None, .Middle, .Ending, .StartingOnly]
        
    }
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    private var interface: BeaconInterface
    /// Model representation of entire venue.
    private let venue: WAYVenue
    /// Engine for speech playback.
    private let speechEngine: AudioEngine
    
    /// Calculated route from current location to `destination`.
    private var route: [WAYGraphEdge]
    /// Nodes along the calculated route from current location to `destination`.
    private var routeNodes = [WAYGraphNode]()
    /// The nearest iBeacon, if one exists.
    private var nearestBeacon: WAYBeacon
    
    private var firstInstruction = true
    
    private var firstAppearance = true
    
    private var nextButton = UIBarButtonItem()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(interface: BeaconInterface, venue: WAYVenue, route: [WAYGraphEdge], startingBeacon: WAYBeacon, speechEngine: AudioEngine) {
        self.interface = interface
        self.venue = venue
        self.route = route
        self.nearestBeacon = startingBeacon
        self.speechEngine = speechEngine
        
        super.init()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIAccessibilityVoiceOverStatusChanged, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WAYDeveloperSettings.DeveloperSettingsChangedNotification, object: nil)
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = WAYStrings.ActiveRoute.ActiveRoute
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveRouteViewController.voiceOverStatusChanged), name: UIAccessibilityVoiceOverStatusChanged, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ActiveRouteViewController.developerSettingsChanged), name: WAYDeveloperSettings.DeveloperSettingsChangedNotification, object: nil)
        
        nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(ActiveRouteViewController.nextButtonPressed(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstAppearance {
            extractNodesFromRoute()
        }
        
        developerSettingsChanged()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        interface.delegate = self
        
        speechEngine.textView = underlyingView.textView
        speechEngine.repeatButton = underlyingView.repeatButton
        
        if firstAppearance {
            firstAppearance = false
            beginRoute()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        speechEngine.stopPlayback()
        speechEngine.textView = nil
        speechEngine.repeatButton = nil
    }
    
    /**
     Finishes setting up the view.
     */
    override func setupView() {
        super.setupView()
        
        underlyingView.repeatButton.addTarget(self, action: #selector(ActiveRouteViewController.repeatButtonPressed(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    // MARK: - BeaconInterfaceDelegate
    
    func beaconInterface(beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        let filteredSortedBeacons = beacons.filter({
            if let _ = $0.accuracy {
                return true
            }
            
            return false
        }).sort({
            $0.accuracy < $1.accuracy
        })
        
        if !filteredSortedBeacons.isEmpty {
            // Continue the route from the nearest beacon
            continueRoute(filteredSortedBeacons)
        }
    }
    
    
    // MARK: - Routing
    
    /**
     Extracts the nodes from the `route` and copys them into `routeNodes`.
     */
    private func extractNodesFromRoute() {
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
    private func beginRoute() {
        guard !route.isEmpty else {
            underlyingView.textView.text = WAYStrings.ActiveRoute.UnableToRoute
            underlyingView.repeatButton.hidden = true
            return
        }
        
        if let beginning = route[0].instructions.beginning {
            underlyingView.textView.text = beginning
            playNextInstruction()
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
    private func continueRoute(beacons: [WAYBeacon]) {
        guard !route.isEmpty && !firstInstruction else {
            return
        }
        
        let myGraph = venue.destinationGraph
        
        let filteredBeacons = beacons.filter({$0.accuracy >= 0.0})
        
        for beacon in filteredBeacons {
            if beacon.identifier == nearestBeacon.identifier {
                continue
            }
            
            if let node = myGraph.getNode(major: beacon.major, minor: beacon.minor)
                where beacon.accuracy < node.accuracy {
                    
                let routeItem = route[0]
                
                if routeItem.targetID == node.identifier {
                    // We've completed this route item, move onto the next one.
                    
                    nearestBeacon = beacon
                    
                    playNextInstruction()
                    
                    return
                } else if let routeIndex = routeNodes.indexOf(node) {
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
    private func playNextInstruction(forcePlayback forcePlayback: ForcePlaybackOptions = .None) {
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
        }
        
        routeNodes.removeFirst()
        
        // Play beginning instruction from next `routeItem`
        if let beginning = route[0].instructions.beginning {
            speechEngine.playInstruction(beginning)
        }
        
        if let middle = route[0].instructions.middle {
            if forcePlayback.contains(.Middle) {
                speechEngine.playInstruction(middle)
            } else {
                // Play the middle instruction from next `routeItem` halfway between the beacons
                let timeInterval = route[0].weight
                
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
    private func skipToInstruction(index: Int) {
        guard index < route.count && index > 1 else {
            return
        }
        
        route.removeRange(0 ..< index - 1)
        routeNodes.removeRange(0 ..< index - 1)
        
        playNextInstruction()
    }
    
    
    // MARK: - Button Actions
    
    func nextButtonPressed(sender: UIBarButtonItem) {
        playNextInstruction()
    }
    
    /**
    Initiate a repeat of the current instruction displayed to the user.
    
    - parameter sender: Button calling the action.
    */
    func repeatButtonPressed(sender: UIButton) {
        guard let myInstruction = speechEngine.currentInstruction else {
            return
        }
        
        speechEngine.playInstruction(myInstruction)
    }
    
    
    // MARK: - Accessibility
    
    /**
    Display `repeatButton` only when VoiceOver is turned off. Otherwise it is redundant.
    */
    func voiceOverStatusChanged() {
        if !WAYDeveloperSettings.sharedInstance.showRepeatButton {
            underlyingView.repeatButton.hidden = UIAccessibilityIsVoiceOverRunning()
        }
    }
    
    
    // MARK: - Developer Settings
    
    func developerSettingsChanged() {
        voiceOverStatusChanged()
        
        let rightButton: UIBarButtonItem? = WAYDeveloperSettings.sharedInstance.showForceNextButton ? nextButton : nil
        navigationItem.rightBarButtonItem = rightButton
    }
    
}
