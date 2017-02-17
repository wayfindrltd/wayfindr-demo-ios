//
//  BeaconInterfaceDelegate.swift
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


protocol BeaconInterfaceDelegate: class {
    
    /**
     Updates the delegate when the beacons within range have changed or have updated information.
     
     - parameter beaconInterface: `BeaconInterface` calling the delegate.
     - parameter beacons:         New and/or updated array of `WAYBeacon` nearby.
     */
    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeBeacons beacons: [WAYBeacon])
    
}


protocol BeaconInterfaceStateDelegate: class {
    
    /**
     Updates the delegate when the state of the `BeaconInterface` has changed.
     
     - parameter beaconInterface: `BeaconInterface` calling the delegate.
     - parameter state:           New and/or updated state.
     */
    func beaconInterface(_ beaconInterface: BeaconInterface, didChangeState state: BeaconInterfaceState)
    
}
