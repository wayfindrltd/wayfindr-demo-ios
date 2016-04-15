//
//  BeaconIdentifier.swift
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


/**
 *  Beacon identification information for quickly comparing two beacons.
 */
struct BeaconIdentifier: Equatable, CustomStringConvertible {
    
    
    // MARK: - Properties
    
    /// Major value for the associated beacon.
    let major: Int
    /// Minor value for the associated beacon.
    let minor: Int
    
    /// Human readable string representation of `BeaconIdentifier`.
    var description: String {
        return "\(WAYStrings.CommonStrings.Major): \(major) \(WAYStrings.CommonStrings.Minor): \(minor)"
    }
    
    
    // MARK: - Initializers
    
    /**
    Initializes a `BeaconIdentifier`.
    
    - parameter major:  Major value for the associated beacon.
    - parameter minor: Minor value for the associated beacon.
    */
    init(major: Int, minor: Int) {
        self.major = major
        self.minor = minor
    }
    
}


// MARK: - Binary Relations/Operations

/**
Equality operation for two `BeaconIdentifier`.

- parameter lhs: Left hand object.
- parameter rhs: Right hand object.

- returns: Whether or not the two `BeaconIdentifier` are equal.
*/
func == (lhs: BeaconIdentifier, rhs: BeaconIdentifier) -> Bool {
    return (lhs.major == rhs.major &&
        lhs.minor == rhs.minor)
}
