//
//  BlueCatsIBeaconInterface.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 22/12/2015.
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

import Foundation
import CoreLocation


final class IOSIBeaconInterface: NSObject, BeaconInterface,CLLocationManagerDelegate {
    
    
    // MARK: - Properties
    
    var needsFullBeaconData = false
    
    var monitorBeacons = true
    
    weak var delegate: BeaconInterfaceDelegate?
    
    weak var stateDelegate: BeaconInterfaceStateDelegate?
    
    var validBeacons: [BeaconIdentifier]?
    
    private(set) var interfaceState = BeaconInterfaceState.initializing {
        didSet {
            stateDelegate?.beaconInterface(self, didChangeState: interfaceState)
        }
    }
    
    func getBeacons(completionHandler: ((Bool, [WAYBeacon]?, BeaconInterfaceAPIError?) -> Void)?) {
        
    }
    
    /// Print errors to assist with debugging this controller.
    internal let printErrorInfo     = true
    
    /// Region UUID and the region name used to subscribe to beacons
    private let regionID: String
    private let regionName: String
    
    /// Location manager that searches for nearby iBeacons.
    
    let locationManager = CLLocationManager()
    
    // MARK: - Initializers
    
    init(regionID: String, regionName: String, monitorBeacons: Bool = true) {
        self.regionID = regionID
        self.regionName = regionName
        
        super.init()
        
        setupClient(completionHandler: {success, error in
            if success {
                self.setupLocationManager()
                
                self.interfaceState = .operating
            } else {
                if let myError = error, case .failedInitialization(let localizedDescription) = myError {
                    self.interfaceState = .failed(localizedDescription: localizedDescription)
                } else {
                    self.interfaceState = .failed(localizedDescription: WAYStrings.ErrorMessages.UnknownError)
                }
            }
        })
    }
    
    
    // MARK: - Setup
    
    private func setupClient(completionHandler: ((Bool, BeaconInterfaceError?) -> Void)? = nil) {
        completionHandler?(true, nil)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let thisregion = CLBeaconRegion(proximityUUID: UUID(uuidString: self.regionID)!, identifier: self.regionName)
        
        locationManager.startRangingBeacons(in: thisregion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //  let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (beacons.count > 0) {
            // let closestBeacon = beacons[0] as CLBeacon
            // self.view.backgroundColor = self.colors[closestBeacon.minor.intValue]
            var foundBeacons = [WAYBeacon]()
            for beacon in beacons {
                //  NSLog("beacon found \(beacon.minor.intValue),\(beacon.major.intValue),\(beacon.rssi)");
                let newBeacon = WAYBeacon(beacon: beacon)
                
                foundBeacons.append(newBeacon)
            }
            
            if !foundBeacons.isEmpty {
                delegate?.beaconInterface(self, didChangeBeacons: foundBeacons)
            }
            //            delegate?.beaconInterface(self, didChangeBeacons: [WAYBeacon(beacon: closestBeacon)]);
        }
        else
        {
            NSLog("no beacon");
        }
        
    }
}


extension WAYBeacon {
    
    init(beacon: CLBeacon) {
        self.accuracy = beacon.accuracy
        
        //        if beacon.targetSpeed != nil {
        //            self.advertisingInterval = "\(beacon.targetSpeed.milliseconds)"
        //        } else {
        self.advertisingInterval = nil
        //        }
        
        //        if beacon.lastKnownBatteryLevel != nil {
        //            self.batteryLevel = "\(beacon.lastKnownBatteryLevel)"
        //        } else {
        self.batteryLevel = nil
        //        }
        
        //        self.lastUpdated = beacon.lastRangedAt
        
        let date = Date()
        self.lastUpdated = date
        self.major = beacon.major.intValue
        self.minor = beacon.minor.intValue
        
        self.rssi = beacon.rssi
        
        self.shortID = nil // Not used by BlueCats
        
        //        if beacon.beaconLoudness != nil {
        //            self.txPower = "\(beacon.beaconLoudness.measuredPowerAt1Meter) dbm"
        //        } else {
        self.txPower = nil
        //        }
        
        //        self.UUIDString = beacon.proximityUUIDString
        self.UUIDString = beacon.proximityUUID.uuidString
        self.identifier = BeaconIdentifier(major: major, minor: minor)
    }
    
}

