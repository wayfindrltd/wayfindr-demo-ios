////
////  DirectionsPreviewViewController_Tests.swift
////  Wayfindr Demo
////
////  Created by Wayfindr on 20/11/2015.
////  Copyright (c) 2016 Wayfindr (http://www.wayfindr.net)
////
////  Permission is hereby granted, free of charge, to any person obtaining a copy
////  of this software and associated documentation files (the "Software"), to deal
////  in the Software without restriction, including without limitation the rights 
////  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
////  copies of the Software, and to permit persons to whom the Software is furnished
////  to do so, subject to the following conditions:
////
////  The above copyright notice and this permission notice shall be included in all 
////  copies or substantial portions of the Software.
////
////  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
////  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
////  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
////  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
////  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
////  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
////
//
//import XCTest
//import CoreLocation
//
//@testable import Wayfindr_Demo
//
//
//class DirectionsPreviewViewController_Tests : XCTestCase {
//    
//    // MARK: - Properties
//    
//    var viewController: DirectionsPreviewViewController!
//    
//    var mockInterface = MockBeaconInterface()
//    let speechEngine = AudioEngine()
//    
//    let fakeBeacon = CLBeacon()
//    
//    
//    // MARK: - Setup/Teardown
//    
//    override func setUp() {
//        super.setUp()
//        
//        guard let venue = testVenue() else {
//            XCTFail("Unable to load test data.")
//            return
//        }
//        
//        let singlePathItem = venue.destinationGraph.edges[0]
//        let firstNode = venue.destinationGraph.getNode(identifier: singlePathItem.sourceID)!
//        //loadFakeBeacon(firstNode.minor)
//        
//        viewController = DirectionsPreviewViewController(interface: mockInterface, venue: venue, route: [singlePathItem], startingBeacon: WAYBeacon(beacon: fakeBeacon), speechEngine: speechEngine)
//        
//        UIApplication.shared.keyWindow!.rootViewController = viewController
//        
//        // Test and Load the View at the Same Time!
//        XCTAssertNotNil(viewController.view)
//    }
//    
//    fileprivate func loadFakeBeacon(_ minor: Int) {
//        fakeBeacon.setValue(1, forKey: "major")
//        fakeBeacon.setValue(minor, forKey: "minor")
//        fakeBeacon.setValue(0.12345, forKey: "accuracy")
//        fakeBeacon.setValue(-68, forKey: "rssi")
//        fakeBeacon.setValue(CLProximity.near.rawValue, forKey: "proximity")
//    }
//    
//    
//    // MARK: - Tests
//    
////    func testLoad() {
////        XCTAssertTrue(true)
////    }
//    
//    func testViewDidAppear() {
//        viewController.viewDidAppear(false)
//        
//        XCTAssertTrue(true)
//    }
//    
//}
//
