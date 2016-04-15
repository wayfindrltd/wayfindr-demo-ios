//
//  BeaconsInRangeViewController.swift
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


/// Displays the nearest beacon to the user and all its relevant information (RSSI, Battery Level, etc.).
final class BeaconsInRangeViewController: BaseViewController<BeaconsInRangeView>, BeaconInterfaceDelegate {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    private var interface: BeaconInterface
    
    /// The nearest beacon, if one exists.
    private var nearestBeacon: WAYBeacon?
    /// Desired beacon for which to show data. If nil, then just display data for nearest beacon.
    private let desiredBeacon: BeaconIdentifier?
    
    /// Print debug info to assist with debugging this controller.
    private let printDebugInfo = false
    /// Print errors to assist with debugging this controller.
    private let printErrorInfo = true
    
    /// Commonly used "To Be Determined" string to display when not all information is available.
    private let tbdText = WAYStrings.BeaconsInRange.TBD
    
    
    // MARK: - Intiailizers / Deinitializers
    
    /**
    Initializes a `BeaconsInRangeViewController`.
    
    - parameter interface:     `BeaconInterface` to use for determining nearby beacons.
    - parameter desiredBeacon: Identifier of the beacon to look for. Defaults to nil, in which case the nearest beacon is displayed. Otherwise only the `desiredBeacon` will be displayed.
    */
    init(interface: BeaconInterface, desiredBeacon: BeaconIdentifier? = nil) {
        self.interface = interface
        self.desiredBeacon = desiredBeacon
        
        super.init()
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WAYStrings.BeaconsInRange.BeaconsInRange
        
        if let myDesiredBeacon = desiredBeacon {
            let noBeaconText = String(format: WAYStrings.BeaconsInRange.NoSpecificBeacon, myDesiredBeacon.description)
            underlyingView.setLocatingLabelText(noBeaconText)
        }
        
        navigationController?.navigationBar.translucent = false
        extendedLayoutIncludesOpaqueBars = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let myDesiredBeacon = desiredBeacon {
            interface.validBeacons = [myDesiredBeacon]
        }
        interface.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        interface.needsFullBeaconData = false
        interface.validBeacons = nil
        nearestBeacon = nil
        underlyingView.locatingLabelHidden = false
    }
    
    
    // MARK: - BeaconInterfaceDelegate
    
    func beaconInterface(beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon]) {
        let beaconsWithAccuracy = beacons.filter({
            if let _ = $0.accuracy {
                return true
            }
            
            return false
        })
        
        if !beaconsWithAccuracy.isEmpty {
            // We have beacons with accuracy data
            let filteredBeacons = beaconsWithAccuracy.filter({$0.accuracy >= 0.0}).sort({$0.accuracy < $1.accuracy})
            
            if let firstBeacon = filteredBeacons.first {
                
                if let myNearestBeacon = nearestBeacon
                    where myNearestBeacon.UUIDString == firstBeacon.UUIDString {
                        // Update the existing nearest beacon
                        let mergedBeacon = WAYBeacon.mergeBeacons(firstBeacon, oldBeacon: myNearestBeacon)
                        
                        nearestBeacon = mergedBeacon
                        
                        self.updateData(mergedBeacon)
                } else {
                    if let myDesiredBeacon = self.desiredBeacon
                        where myDesiredBeacon != firstBeacon.identifier {
                            // We're looking for a specific beacon, but found a different one.
                            //      So we ignore this beacon.
                            return
                    }
                    
                    // New nearest beacon
                    nearestBeacon = firstBeacon
                    interface.needsFullBeaconData = true
                    
                    self.updateData(firstBeacon)
                }
            }
        } else {
            // We don't have any beacons with accuracy data.
            //      Compare with `nearestBeacon` for updated information
            if let myNearestBeacon = nearestBeacon,
                desiredBeaconIndex = beacons.indexOf({$0.identifier == myNearestBeacon.identifier}) {
                    
                    // Update the existing nearest beacon
                    
                    let desiredBeacon = beacons[desiredBeaconIndex]
                    let mergedBeacon = WAYBeacon.mergeBeacons(desiredBeacon, oldBeacon: myNearestBeacon)
                    
                    nearestBeacon = mergedBeacon
                    
                    self.updateData(mergedBeacon)
            }
        }
    }
    
    
    // MARK: - Convenience
    
    /**
    Updates the data on the screen with the nearest beacon's information.
    
    - parameter beacon:          Beacon information.
    */
    private func updateData(beacon: WAYBeacon) {
        underlyingView.locatingLabelHidden = true
        
        underlyingView.headerView.bodyLabel.text = String(beacon.minor)
        
        underlyingView.bodyView.majorLabel.valueLabel.text = String(beacon.major)
        underlyingView.bodyView.minorLabel.valueLabel.text = String(beacon.minor)
        underlyingView.bodyView.uuidLabel.valueLabel.text = String(beacon.UUIDString)
        
        if let myRSSI = beacon.rssi {
            updateLabel(underlyingView.bodyView.rssiLabel.valueLabel, text: String(myRSSI), units: " dBm")
        } else {
            updateLabel(underlyingView.bodyView.rssiLabel.valueLabel, text: nil)
        }
        
        if let myAccuracy = beacon.accuracy {
            updateLabel(underlyingView.bodyView.accuracyLabel.valueLabel, text: myAccuracy.description)
        } else {
            updateLabel(underlyingView.bodyView.accuracyLabel.valueLabel, text: nil)
        }
        
        updateLabel(underlyingView.bodyView.txPowerLabel.valueLabel, text: beacon.txPower)
        
        updateLabel(underlyingView.bodyView.advertisingRateLabel.valueLabel, text: beacon.advertisingInterval, units: " ms")
        
        updateLabel(underlyingView.bodyView.batteryLabel.valueLabel, text: beacon.batteryLevel, units: "%")
        
        underlyingView.setNeedsDisplay()
    }
    
    /**
     Update a label with information or a "To Be Determined" message if no information is available.
     
     - parameter label: `UILabel` to update.
     - parameter text:  Information to update the `label` with, if it exists.
     - parameter units: Units to append to `text`, if it exists.
     */
    private func updateLabel(label: UILabel, text: String?, units: String = "") {
        if let myText = text {
            label.text = myText + units
        } else {
            label.text = tbdText
        }
    }
    
}
