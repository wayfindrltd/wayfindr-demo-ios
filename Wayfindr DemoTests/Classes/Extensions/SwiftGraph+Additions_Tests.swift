//
//  SwiftGraph+Additions_Tests.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 03/12/2015.
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

import XCTest

@testable import Wayfindr_Demo


class SwiftGraph_Additions_Tests : XCTestCase {
    
    
    // MARK: - Properties
    
    var venue: WAYVenue!
    
    
    // MARK: - Setup/Teardown
    
    override func setUp() {
        super.setUp()
        
        guard let myVenue = testVenue() else {
            XCTFail("Unable to load test data.")
            return
        }
        
        venue = myVenue
    }
    
    
    // MARK: - Tests
    
    func testIsConnected_True() {
        // Given
        let graph = venue.destinationGraph.graph
        
        // When
        graph.addEdge(from: 0, to: 1, directed: true, weight: 1.0)
        graph.addEdge(from: 1, to: 0, directed: true, weight: 1.0)
        
        // Then
        XCTAssertTrue(graph.isConnected, "Expected graph to be connected but instead found it was disconnected.")
    }
    
    func testIsConnected_False() {
        // Given
        let graph = venue.destinationGraph.graph
        
        // When
        graph.removeAllEdges(from: 0, to: 1)
        
        // Then
        XCTAssertFalse(graph.isConnected, "Expected graph to be disconnected but instead found it was connected.")
    }
    
}
