//
//  VenueInterface.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 11/12/2015.
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
 *  Interface for interacting between the app and a venue.
 */
protocol VenueInterface {
    
    
    // MARK: - GET
    
    /**
    Fetches an appropriate `BeaconInterface` for interacting with the venue's beacons.
    
    - parameter completionHandler: Asynchronous call back closure that is called when the `BeaconInterface` is created. There are three parameters: a `Bool` that states whether or not the creation of the interface was successful, an optional `BeaconInterface` with the resulting interface, and an optional `BeaconInterfaceError` storing information if the creation was unsuccessful.
    */
    func getBeaconInterface(completionHandler: ((Bool, BeaconInterface?, BeaconInterfaceError?) -> Void))
    
    /**
     Fetches an appropriate `WAYVenue` to represent the venue.
     
     - parameter completionHandler: Asynchronous call back closure that is called when the `WAYVenue` is created. There are three parameters: a `Bool` that states whether or not the creation of the venue was successful, an optional `WAYVenue` with the resulting venue, and an optional `WAYError` storing information if the creation was unsuccessful.
     */
    func getVenue(completionHandler: ((Bool, WAYVenue?, WAYError?) -> Void))
    
    /**
     Fetches a URL to a PDF map of the venue.
     
     - parameter completionHandler: Asynchronous call back closure that is called when the `WAYVenue` is created. There are three parameters: a `Bool` that states whether or not the creation of the URL to the map was successful, an optional `NSURL` with the resulting url, and an optional `VenueInterfaceAPIError` storing information if the fetch unsuccessful.
     */
    func getVenueMap(completionHandler: ((Bool, URL?, VenueInterfaceAPIError?) -> Void))
    
}
