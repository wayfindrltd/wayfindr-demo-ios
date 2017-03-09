//
//  BlueCatsIBeaconInterface-BCMicroLocationManagerDelegate.swift
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


extension BlueCatsIBeaconInterface: BCMicroLocationManagerDelegate {
    
    func microLocationManager(_ microLocationManager: BCMicroLocationManager!, didFailWithError error: Error!) {
        if printErrorInfo {
            print("microLocationManager didFailWithError:\(error.localizedDescription)")
        }
    }
    
    func microLocationManager(_ microLocationManager: BCMicroLocationManager!, didEnter site: BCSite!) {
        if monitorBeacons {
            currentSite = site
            microLocationManager.startRangingBeacons(in: site)
        }
        
        if printErrorInfo {
            print("microLocationManager didEnterSite:\(site.name)")
        }
    }
    
    func microLocationManager(_ microLocationManager: BCMicroLocationManager!, didExitSite site: BCSite!) {
        microLocationManager.stopRangingBeacons(in: site)
        currentSite = nil
        
        if printErrorInfo {
            print("microLocationManager didExitSite:\(site.name)")
        }
    }
    
    func microLocationManager(_ microLocationManager: BCMicroLocationManager!, monitoringDidFailFor site: BCSite!, withError error: Error!) {
        if printErrorInfo {
            print("microLocationManager monitoringDidFailForSite:\(site.name) withError:\(error.localizedDescription)")
        }
    }
    
    func microLocationManager(_ microLocationManager: BCMicroLocationManager!, didRangeBeacons beacons: [Any]!, in site: BCSite!) {
        guard let myBeacons = beacons as? [BCBeacon] else {
            return
        }
        
        let filteredSortedBeacons = myBeacons.filter({
            beacon in

            let proximity = beacon.proximity != BCProximity.unknown
            let accuracy = beacon.accuracy >= 0.0
            let major = beacon.major != nil
            let minor = beacon.minor != nil

            return proximity && accuracy && major && minor
            
        }).sorted(by: {$0.accuracy < $1.accuracy})
        
        guard !filteredSortedBeacons.isEmpty else {
            return
        }
        
        let validatedBeacons: [BCBeacon]
        if let myValidBeacons = validBeacons {
            validatedBeacons = filteredSortedBeacons.filter({
                let beaconID = BeaconIdentifier(major: Int($0.major), minor: Int($0.minor))
                
                return myValidBeacons.contains(beaconID)
            })
        } else {
            validatedBeacons = filteredSortedBeacons
        }
        
        var foundBeacons = [WAYBeacon]()
        for beacon in validatedBeacons {
            let newBeacon = WAYBeacon(beacon: beacon)
            
            foundBeacons.append(newBeacon)
        }
        
        if !foundBeacons.isEmpty {
            delegate?.beaconInterface(self, didChangeBeacons: foundBeacons)
        }
    }
    
}
