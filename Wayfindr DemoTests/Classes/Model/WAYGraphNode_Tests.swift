//
//  WAYGraphNode_Tests.swift
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

class WAYGraphNode_Tests: XCTestCase {
    
    
    // MARK: - Properties

    var xmlElement : AEXMLElement!
    
    fileprivate let nodeMajor = "1"
    fileprivate let nodeMinor = "2"
    fileprivate let nodeName = "Black"
    fileprivate let nodeType = "Entrance,Exit"
    fileprivate let accuracy = "2.0"
    
    fileprivate let defaultAccuracy = 5.0
    
    
    // MARK: - Setup/Teardown
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        xmlElement = AEXMLElement(name: "node")
        xmlElement.name = "node"
        xmlElement.attributes["id"] = "1"
        xmlElement.addChild(name: "data", value: nodeMajor, attributes: ["key" : "major"])
        xmlElement.addChild(name: "data", value: nodeMinor, attributes: ["key" : "minor"])
        xmlElement.addChild(name: "data", value: nodeName, attributes: ["key" : "name"])
        xmlElement.addChild(name: "data", value: nodeType, attributes: ["key" : "waypoint_type"])
        xmlElement.addChild(name: "data", value: accuracy, attributes: ["key" : "accuracy"])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    // MARK: - Initializers
    
    func testInitXMLElement_GoodXML() {
        // When
        let testNode = try? WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        
        // Then
        XCTAssertNotNil(testNode, "Initialization of node from well formed GraphML expected to be not nil.")
    }
    
    func testInitXMLElement_BadXML_Attribute() {
        // Given
        let badXMLElement = xmlElement
        
        // When
        badXMLElement?.attributes.removeValue(forKey: "id")
        
        // Then
        AssertThrow(WAYError.invalidGraphNode, try WAYGraphNode(xmlElement: badXMLElement!, defaultAccuracy: defaultAccuracy))
    }
    
    func testInitXMLElement_BadXML_Data() {
        // Given
        let badXMLElement = xmlElement
        
        // When
        badXMLElement?.children.first?.removeFromParent()
        
        // Then
        AssertThrow(WAYError.invalidGraphNode, try WAYGraphNode(xmlElement: badXMLElement!, defaultAccuracy: defaultAccuracy))
    }
    
    
    // MARK: - Properties
    
    func testDescription() {
        // Given
        let testNode = try! WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        let expectedDescription = "Node <name:\(nodeName) major:\(nodeMajor) minor:\(nodeMinor) type:Entrance; Exit>"
        
        // When
        let description = testNode.description
        
        // Then
        XCTAssertTrue(description == expectedDescription, "Expected `description` to be '\(expectedDescription)' but instead found '\(description)'.")
    }
    
    func testBeaconIdentifier() {
        // Given
        let testNode = try! WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        
        // When
        let identifier = testNode.beaconID
        let expectedResult  = BeaconIdentifier(major: testNode.major, minor: testNode.minor)
        
        // Then
        XCTAssertTrue(identifier == expectedResult, "Expected `beaconID` to be '\(expectedResult)' but instead found '\(identifier)'.")
    }
    
    
    // MARK: - Operations
    
    func testEqualityOperation_True() {
        // Given
        let firstNode = try! WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        let secondNode = try! WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        
        // Then
        XCTAssertTrue(firstNode == secondNode, "Two nodes generated from the same GraphML expected to be equal.")
    }
    
    func testEqualityOperation_False() {
        // Given
        let firstNode = try! WAYGraphNode(xmlElement: xmlElement, defaultAccuracy: defaultAccuracy)
        let secondXMLElement = xmlElement
        
        // When
        secondXMLElement?.attributes["id"] = "foo"
        let secondNode = try! WAYGraphNode(xmlElement: secondXMLElement!, defaultAccuracy: defaultAccuracy)
        
        // Then
        XCTAssertFalse(firstNode == secondNode, "Two nodes generated from the different GraphML expected to be not equal.")
    }
    
}
