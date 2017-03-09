//
//  BeaconInterface.swift
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


enum BeaconInterfaceError: Error {
    case failedInitialization(localizedDescription: String)
    case failedParsingData
}


/**
 *  Interface for interacting between the app and a beacon manufacturer's implementation of beacons.
 */
protocol BeaconInterface {
    
    // MARK: - Properties
    
    /// Whether or not maximum data about the beacon is needed.
    ///     This can be used to provide a minimal amount if information for
    ///     speed, battery, etc. improvements.
    var needsFullBeaconData: Bool { get set }
    
    /// List of valid beacons that the `BeaconInterface` use for filtering.
    ///     If `nil` then the `BeaconInterface` should parse all beacons.
    var validBeacons: [BeaconIdentifier]? { get set }
    
    /// Delegate for the `BeaconInterface`.
    weak var delegate: BeaconInterfaceDelegate? { get set }
    
    /// Current state of the `BeaconInterface`.
    var interfaceState: BeaconInterfaceState { get }
    /// Delegate to get updates on the `state` of the `BeaconInterface`.
    weak var stateDelegate: BeaconInterfaceStateDelegate? { get set }


    // MARK: - GET
    
    func getBeacons(completionHandler: ((Bool, [WAYBeacon]?, BeaconInterfaceAPIError?) -> Void)?)

}
