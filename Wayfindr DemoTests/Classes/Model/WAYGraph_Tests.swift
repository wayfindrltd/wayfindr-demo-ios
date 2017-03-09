//
//  WAYGraph_Tests.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 10/11/2015.
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

import AEXML

class WAYGraph_Tests: XCTestCase {
    
    
    // MARK: - Properties
    
    var xmlDocument : AEXMLDocument!
    
    
    // MARK: - Setup/Teardown

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        loadTestGraphData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    fileprivate func loadTestGraphData() {
        let filename = "TestData"
        let filetype = "graphml"
        
        if let filepath = Bundle(for: WAYGraph_Tests.self).path(forResource: filename, ofType: filetype),
            let xmlData = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
            let myXMLDocument = try? AEXMLDocument(xml: xmlData) {
                
                xmlDocument = myXMLDocument
                
        }
    }
    
    
    // MARK: - Initializers
    
    func testInitXMLElement_GoodXML() {
        // When
        let testGraph = try? WAYGraph(xmlDocument: xmlDocument)
        
        // Then
        XCTAssertNotNil(testGraph, "Initialization of graph from well formed GraphML expected to be not nil.")
    }
    
    func testInitXMLElement_BadXML_MissingGraph() {
        // Given
        let badXMLDocument = xmlDocument
        
        // When
        badXMLDocument?.root["graph"].removeFromParent()
        
        // Then
        AssertThrow(WAYError.invalidGraph, try WAYGraph(xmlDocument: badXMLDocument!))
    }
    
    func testInitXMLElement_BadXML_MissingNode() {
        // Given
        let badXMLDocument = xmlDocument
        
        // When
        badXMLDocument?.root["graph"]["node"].first?.removeFromParent()
        
        // Then
        AssertThrow(WAYError.invalidGraphEdge, try WAYGraph(xmlDocument: badXMLDocument!))
    }
    
    
    // MARK: - Fetch Vertex
    
    func testGetNode_MajorMinor_Success() {
        // Given
        let testGraph = try? WAYGraph(xmlDocument: xmlDocument)
        
        // When
        let foundNode = testGraph?.getNode(major: 1, minor: 2)
        
        // Then
        XCTAssertNotNil(foundNode, "Expected to find the given node but instead found nil.")
    }
    
    func testGetNode_MajorMinor_Nil() {
        // Given
        let testGraph = try! WAYGraph(xmlDocument: xmlDocument)
        
        // When
        testGraph.graph.removeVertexAtIndex(1)
        let foundNode = testGraph.getNode(major: 1, minor: 2)
        
        // Then
        XCTAssertNil(foundNode, "Expected to fail finding the node but instead found something. \(foundNode)")
    }
    
    func testGetNode_Identifier_Success() {
        // Given
        let testGraph = try? WAYGraph(xmlDocument: xmlDocument)
        
        // When
        let foundNode = testGraph?.getNode(identifier: "1")
        
        // Then
        XCTAssertNotNil(foundNode, "Expected to find the given node but instead found nil.")
    }
    
    func testGetNode_Identifier_Nil() {
        // Given
        let testGraph = try! WAYGraph(xmlDocument: xmlDocument)
        
        // When
        testGraph.graph.removeVertexAtIndex(1)
        let foundNode = testGraph.getNode(identifier: "10")
        
        // Then
        XCTAssertNil(foundNode, "Expected to fail finding the node but instead found something. \(foundNode)")
    }
    
    func testGetEdge_Success() {
        // Given
        let testGraph = try! WAYGraph(xmlDocument: xmlDocument)
        
        // When
        let foundEdge = testGraph.getEdge(0, targetNodeIndex: 1)
        
        // Test
        XCTAssertNotNil(foundEdge, "Expected to find the given edge but instead found nil.")
    }
    
    func testGetEdge_Nil() {
        // Given
        let testGraph = try! WAYGraph(xmlDocument: xmlDocument)
        
        // When
        let foundEdge = testGraph.getEdge(1, targetNodeIndex: 0)
        let foundEdge2 = testGraph.getEdge(0, targetNodeIndex: 11)
        
        // Test
        XCTAssertNil(foundEdge, "Expected to fail finding the edge but instead found something. \(foundEdge)")
        XCTAssertNil(foundEdge2, "Expected to fail finding the edge but instead found something. \(foundEdge2)")
    }
    
    
    // MARK: - Routing
    
    func testCanRoute() {
        // Given
        let testGraph = try! WAYGraph(xmlDocument: xmlDocument)
        
        // When
        let node1 = testGraph.graph[0]
        let node2 = testGraph.graph[1]
        
        // Test
        XCTAssertTrue(testGraph.canRoute(node1, toNode: node2))
        XCTAssertFalse(testGraph.canRoute(node2, toNode: node1))
    }
    
    
    // MARK: - Accuracy between nodes and beacons
    
    func testBeaconIsWithinRangeOfNodeUsingRssi() {
        
        // Given
        
        let mockBeacon = WAYBeacon(major: 1, minor: 2, UUIDString: "123", accuracy: 4.0, advertisingInterval: "100", batteryLevel: "", lastUpdated: Date(), rssi: -96, txPower: "")
        
        guard let mockNode = testNode else {
            
            XCTFail("Error: Could not create node")
            return
        }
        
        // Test
        
        let isInRange = WAYGraph.beacon(beacon: mockBeacon, isWithinRangeOf: mockNode, isUsingRssi: true)
        
        XCTAssertTrue(isInRange, "Beacon should be in range of the node")
    }
    
    func testBeaconIsNotWithinRangeOfNodeUsingRssi() {
        
        // Given
        
        let mockBeacon = WAYBeacon(major: 1, minor: 2, UUIDString: "123", accuracy: 4.0, advertisingInterval: "100", batteryLevel: "", lastUpdated: Date(), rssi: -98, txPower: "")
        
        guard let mockNode = testNode else {
            
            XCTFail("Error: Could not create node")
            return
        }
        
        // Test
        
        let isInRange = WAYGraph.beacon(beacon: mockBeacon, isWithinRangeOf: mockNode, isUsingRssi: true)
        
        XCTAssertFalse(isInRange, "Beacon should not be in range of the node")
    }
    
    func testBeaconIsWithinRangeOfNodeUsingAccuracy() {
        
        // Given
        
        let mockBeacon = WAYBeacon(major: 1, minor: 2, UUIDString: "123", accuracy: 2.0, advertisingInterval: "100", batteryLevel: "", lastUpdated: Date(), rssi: -96, txPower: "")
        
        guard let mockNode = testNode else {
            
            XCTFail("Error: Could not create node")
            return
        }
        
        // Test
        
        let isInRange = WAYGraph.beacon(beacon: mockBeacon, isWithinRangeOf: mockNode, isUsingRssi: false)
        
        XCTAssertTrue(isInRange, "Beacon should be in range of the node")
    }
    
    func testBeaconIsNotWithinRangeOfNodeUsingAccuracy() {
        
        // Given
        
        let mockBeacon = WAYBeacon(major: 1, minor: 2, UUIDString: "123", accuracy: 4.0, advertisingInterval: "100", batteryLevel: "", lastUpdated: Date(), rssi: -98, txPower: "")
        
        guard let mockNode = testNode else {
            
            XCTFail("Error: Could not create node")
            return
        }
        
        // Test
        
        let isInRange = WAYGraph.beacon(beacon: mockBeacon, isWithinRangeOf: mockNode, isUsingRssi: false)
        
        XCTAssertFalse(isInRange, "Beacon should not be in range of the node")
    }
    
    var testNode: WAYGraphNode? {
        
        let xmlElement = AEXMLElement(name: "node")
        xmlElement.name = "node"
        xmlElement.attributes["id"] = "1"
        xmlElement.addChild(name: "data", value: "1", attributes: ["key" : "major"])
        xmlElement.addChild(name: "data", value: "2", attributes: ["key" : "minor"])
        xmlElement.addChild(name: "data", value: "node", attributes: ["key" : "name"])
        xmlElement.addChild(name: "data", value: "testType", attributes: ["key" : "waypoint_type"])
        xmlElement.addChild(name: "data", value: "3.0", attributes: ["key" : "accuracy"])
        xmlElement.addChild(name: "data", value: "-97", attributes: ["key" : "rssi"])
        
        let testNode = try? WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: 3.0)
        
        return testNode
    }
    
    
}
