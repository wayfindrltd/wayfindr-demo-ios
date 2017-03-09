//
//  WAYBeacon.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 01/12/2015.
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


/**
 *  Manufacturer and implementation independent representation of a beacon.
 */
struct WAYBeacon: Equatable {
    
    
    // MARK: - Required Properties
    
    /// Major value for the associated beacon.
    let major: Int
    /// Minor value for the associated beacon.
    let minor: Int
    /// UUID string identifying the beacon.
    let UUIDString: String
    
    /// Convenience identifier for quickly comparing `WAYBeacon` based on `major` and `minor` values.
    let identifier: BeaconIdentifier
    
    
    // MARK: - Optional Properties
    
    /// Accuracy of coodinate values in meters (m).
    let accuracy: CLLocationAccuracy?
    /// Advertising interval of the beacon in milliseconds (ms).
    let advertisingInterval: String?
    /// Battery level of the beacon rounded to the nearest percent (%).
    let batteryLevel: String?
    /// The last time the data for the beacon was updated.
    let lastUpdated: Date?
    /// Received signal strength indicator measured in decible-milliwatts (dBm).
    let rssi: Int?
    /// Optional short identifier to use as separate from the `UUIDString`.
    let shortID: String?
    /// Relative indicator of transmission power level.
    let txPower: String?
    
    // MARK: - Initializers
    
    /**
    Initializes a `WAYBeacon`.
    
    - parameter major:               Major value for the associated beacon.
    - parameter minor:               Minor value for the associated beacon.
    - parameter UUIDString:          UUID string identifying the beacon.
    - parameter accuracy:            Accuracy of coodinate values in meters (m).
    - parameter advertisingInterval: Advertising interval of the beacon in milliseconds (ms).
    - parameter batteryLevel:        Battery level of the beacon rounded to the nearest percent (%).
    - parameter lastUpdated:         The last time the data for the beacon was updated.
    - parameter rssi:                Received signal strength indicator measured in decible-milliwatts (dBm).
    - parameter shortID:             Optional short identifier to use as separate from the `UUIDString`.
    - parameter txPower:             Relative indicator of transmission power level.
    */
    init(major: Int, minor: Int, UUIDString: String, accuracy: CLLocationAccuracy? = nil, advertisingInterval: String? = nil, batteryLevel: String? = nil, lastUpdated: Date? = nil, rssi: Int? = nil, shortID: String? = nil, txPower: String? = nil) {
        self.accuracy = accuracy
        self.advertisingInterval = advertisingInterval
        self.batteryLevel = batteryLevel
        self.lastUpdated = lastUpdated
        self.major = major
        self.minor = minor
        self.rssi = rssi
        self.shortID = shortID
        self.txPower = txPower
        self.UUIDString = UUIDString
        
        self.identifier = BeaconIdentifier(major: major, minor: minor)
    }
    
    /**
     Initializes a `WAYBeacon` from a `CLBeacon` object.
     
     - parameter beacon:              `CLBeacon` object to use as foundation of the `WAYBeacon`.
     - parameter advertisingInterval: Advertising interval of the beacon in milliseconds (ms).
     - parameter batteryLevel:        Battery level of the beacon rounded to the nearest percent (%).
     - parameter lastUpdated:         The last time the data for the beacon was updated.
     - parameter shortID:             Optional short identifier to use as separate from the `UUIDString`.
     - parameter txPower:             Relative indicator of transmission power level.
     */
    init(beacon: CLBeacon, advertisingInterval: String? = nil, batteryLevel: String? = nil, lastUpdated: Date? = nil, shortID: String? = nil, txPower: String? = nil) {
        self.accuracy = beacon.accuracy
        self.major = Int(beacon.major)
        self.minor = Int(beacon.minor)
        self.rssi = beacon.rssi
        self.UUIDString = beacon.proximityUUID.uuidString
        
        self.advertisingInterval = advertisingInterval
        self.batteryLevel = batteryLevel
        self.lastUpdated = lastUpdated
        self.shortID = shortID
        self.txPower = txPower
        
        self.identifier = BeaconIdentifier(major: major, minor: minor)
    }
    
    
    // MARK: - Merge Data
    
    /**
    Merge data between two `WAYBeacon` giving preference to the data from `newBeacon` if the data does not match.
    
    - parameter newBeacon: Newer `WAYBeacon` object to merge.
    - parameter oldBeacon: Older `WAYBeacon` object to merge.
    
    - returns: Merged `WAYBeacon` object.
    */
    static func mergeBeacons(_ newBeacon: WAYBeacon, oldBeacon: WAYBeacon) -> WAYBeacon {
        let major = newBeacon.major
        let minor = newBeacon.minor
        let UUIDString = newBeacon.UUIDString
        let accuracy = newBeacon.accuracy ?? oldBeacon.accuracy
        let advertisingInterval = newBeacon.advertisingInterval ?? oldBeacon.advertisingInterval
        let batteryLevel = newBeacon.batteryLevel ?? oldBeacon.batteryLevel
        let lastUpdated = newBeacon.lastUpdated ?? oldBeacon.lastUpdated
        let rssi = newBeacon.rssi ?? oldBeacon.rssi
        let txPower = newBeacon.txPower ?? oldBeacon.txPower
        
        let mergedBeacon = WAYBeacon(major: major, minor: minor, UUIDString: UUIDString, accuracy: accuracy, advertisingInterval: advertisingInterval, batteryLevel: batteryLevel, lastUpdated: lastUpdated, rssi: rssi, txPower: txPower)
        
        return mergedBeacon
    }
    
}


func == (lhs: WAYBeacon, rhs: WAYBeacon) -> Bool {
    return lhs.identifier == rhs.identifier
}
