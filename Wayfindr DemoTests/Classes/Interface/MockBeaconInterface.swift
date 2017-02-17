//
//  MockBeaconInterface.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 02/12/2015.
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

@testable import Wayfindr_Demo


struct MockBeaconInterface : BeaconInterface {
    
    
    // MARK: - Properties
    
    var needsFullBeaconData: Bool = false
    
    fileprivate(set) var interfaceState = BeaconInterfaceState.initializing {
        didSet {
            stateDelegate?.beaconInterface(self, didChangeState: interfaceState)
        }
    }
    
    var validBeacons: [BeaconIdentifier]?
    
    weak var delegate: BeaconInterfaceDelegate?
    
    weak var stateDelegate: BeaconInterfaceStateDelegate?
    
    let fakeBeacon = CLBeacon()
    
    
    // MARK: - Initializers
    
    init() {
        //loadFakeBeacon()
        
        interfaceState = .operating
    }
    
    
    // MARK: - GET
    
    func getBeacons(completionHandler: ((Bool, [WAYBeacon]?, BeaconInterfaceAPIError?) -> Void)?) {
        let beacon = WAYBeacon(beacon: fakeBeacon)
        
        completionHandler?(true, [beacon], nil)
    }


    // MARK: - Mock
    
    func mockBeaconChange() {
        let fakeWAYBeacon = WAYBeacon(beacon: fakeBeacon)
        
        delegate?.beaconInterface(self, didChangeBeacons: [fakeWAYBeacon])
    }
    
    fileprivate func loadFakeBeacon() {
        fakeBeacon.setValue(1, forKey: "major")
        fakeBeacon.setValue(1, forKey: "minor")
        fakeBeacon.setValue(0.12345, forKey: "accuracy")
        fakeBeacon.setValue(-68, forKey: "rssi")
        fakeBeacon.setValue(CLProximity.near.rawValue, forKey: "proximity")
    }
    
}
