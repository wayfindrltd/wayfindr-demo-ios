//
//  WAYGraphNode.swift
//  Wayfindr Tests
//
//  Created by Wayfindr on 09/11/2015.
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

import AEXML


/**
 *  Option set of types for a WAYGraphNode. (e.g. Entrance, Exit, Lift, etc.)
 */
struct WAYGraphNodeType: OptionSet, CustomStringConvertible {
    let rawValue: UInt
    
    static let None = WAYGraphNodeType(rawValue:  1 << 1)
    static let Entrance = WAYGraphNodeType(rawValue: 1 << 2)
    static let Exit = WAYGraphNodeType(rawValue: 1 << 3)
    static let Lift = WAYGraphNodeType(rawValue: 1 << 4)
    static let Escalator = WAYGraphNodeType(rawValue: 1 << 5)
    static let MensToilet = WAYGraphNodeType(rawValue: 1 << 6)
    static let WomensToilet = WAYGraphNodeType(rawValue: 1 << 7)
    static let Stairs = WAYGraphNodeType(rawValue: 1 << 8)
    static let Platform = WAYGraphNodeType(rawValue: 1 << 9)
    static let TicketBarrier = WAYGraphNodeType(rawValue: 1 << 10)
    static let TicketMachine = WAYGraphNodeType(rawValue: 1 << 11)
    static let ATM = WAYGraphNodeType(rawValue: 1 << 12)
    static let TaxiRank = WAYGraphNodeType(rawValue: 1 << 13)
    static let Shop = WAYGraphNodeType(rawValue: 1 << 14)
    static let StreetCrossing = WAYGraphNodeType(rawValue: 1 << 15)
    static let BusStop = WAYGraphNodeType(rawValue: 1 << 16)

    /// Plain text description of the current state of the option set.
    var description: String {
        let strings = ["None", "Entrance", "Exit", "Lift", "Escalator", "MensToilet", "WomensToilet", "Stairs", "Platform", "TicketBarrier", "TicketMachine", "ATM", "TaxiRank", "Shop", "StreetCrossing", "BusStop"]
        var members = [String]()
        
        for (flag, string) in strings.enumerated() where contains(WAYGraphNodeType(rawValue: 1 << (UInt(flag) + 1))) {
            members.append(string)
        }
        
        var result = ""
        let separator = "; "
        for member in members {
            if !result.isEmpty { result += separator }
            result += member
        }
            
        return result
    }
    
    static let allValues: WAYGraphNodeType = [.None, .Entrance, .Exit, .Lift, .Escalator, .MensToilet, .WomensToilet, .Stairs, .Platform, .TicketBarrier]
    
}


/**
 *  Represents a destination node (i.e. a Beacon).
 */
struct WAYGraphNode: Equatable, CustomStringConvertible {
    
    // MARK: - Properties
    
    /// Identifier for the node. Used in the GraphML representation.
    let identifier: String
    /// Major value for the associated beacon.
    let major: Int
    /// Minor value for the associated beacon.
    let minor: Int
    /// Name of the associated beacon's location.
    let name: String
    /// All of the waypoint types supported by this node.
    let nodeType: WAYGraphNodeType
    /// The minimum CLBeacon accuracy level required to activate the node.
    let accuracy: Double
    /// The minimum CLBeacon rssi level required to activate the node.
    let rssi: Int
    
    
    /**
     *  Attributes for the `node` GraphML element.
     */
    struct WAYGraphNodeAttributes {
        static let identifier = "id"
        
        static let allValues = [identifier]
    }
    
    /**
     Keys for the data in the `node` GraphML element.
     */
    enum WAYGraphNodeKeys: String {
        case Major                  = "major"
        case Minor                  = "minor"
        case Name                   = "name"
        case NodeType               = "waypoint_type"
        case Accuracy               = "accuracy"
        case Rssi                   = "rssi"
        
        static let allValues = [Major, Minor, Name, NodeType, Accuracy, Rssi]
    }
    
    /// Plain text description of the node.
    var description: String {
        get {
            return "Node <name:\(name) major:\(major) minor:\(minor) type:\(nodeType)>"
        }
    }
    
    /// `BeaconIdentifier` representation of the beacon corresponding to the `WAYGraphNode`.
    var beaconID: BeaconIdentifier {
        get {
            return BeaconIdentifier(major: major, minor: minor)
        }
    }
    
    
    // MARK: - Initializers
    
    /**
    Initialize a `WAYGraphNode` from an xml element.
    
    - parameter xmlElement: `AEXMLElement` representing the node. Must be in GraphML format.
    - parameter defaultAccuracy:    The default accuracy value to use for the node if node is supplied in the `xmlElement`.
    
    - throws:   Throws a `WAYError` if the `xmlElement` is not in the correct format.
    */
    init(xmlElement: AEXMLElement, defaultAccuracy: Double) throws {
        // Temporary storage for the data elements
        var tempMajor: Int?
        var tempMinor: Int?
        var tempName: String?
        var tempNodeType = WAYGraphNodeType.None
        var tempAccuracy: Double?
        var tempRssi: Int?
        
        // Retrieve the ID
        guard let myID = xmlElement.attributes[WAYGraphNodeAttributes.identifier] else {
            throw WAYError.invalidGraphNode
        }
        identifier = myID
        
        // Parse the data
        for dataItem in xmlElement.children {
            
            if let keyAttribute = dataItem.attributes["key"],
                let dataItemType = WAYGraphNodeKeys(rawValue: keyAttribute) {
                
                    switch dataItemType {
                    case .Major:
                        tempMajor = dataItem.int
                    case .Minor:
                        tempMinor = dataItem.int
                    case .Name:
                        tempName = dataItem.string
                    case .NodeType:
                        let stringValue = dataItem.string
                        let nodeTypes = stringValue.components(separatedBy: ",")
                        for newNodeType in nodeTypes {
                            if let newValue = WAYGraphNode.stringToNodeType(newNodeType) {
                                if newValue != .None && tempNodeType.contains(.None) {
                                    tempNodeType.remove(.None)
                                }
                                
                                tempNodeType.insert(newValue)
                            }
                        }
                    case .Accuracy:

                        tempAccuracy = dataItem.double
                    case .Rssi:
                        
                        tempRssi = dataItem.int
                    }
            }
            
        }
        
        // Ensure we have found all elements
        guard let myMajor = tempMajor,
            let myMinor = tempMinor,
            let myName = tempName else {
                
                throw WAYError.invalidGraphNode
        }
        
        // Permanently store the elements
        major = myMajor
        minor = myMinor
        name = myName
        nodeType = tempNodeType
        accuracy = tempAccuracy ?? defaultAccuracy
        rssi = tempRssi ?? -1000
    }
    
    fileprivate static func stringToNodeType(_ value: String) -> WAYGraphNodeType? {
        switch value {
        case "None":
            return .none
        case "Entrance":
            return .Entrance
        case "Exit":
            return .Exit
        case "Lift":
            return .Lift
        case "Escalator":
            return .Escalator
        case "MensToilet":
            return .MensToilet
        case "WomensToilet":
            return .WomensToilet
        case "Stairs":
            return .Stairs
        case "Platform":
            return .Platform
        case "TicketBarrier":
            return .TicketBarrier
        case "TicketMachine":
            return .TicketMachine
        case "ATM":
            return .ATM
        case "TaxiRank":
            return .TaxiRank
        case "Shop":
            return .Shop
        case "StreetCrossing":
            return .StreetCrossing
        case "BusStop":
            return .BusStop
        default:
            return nil
        }
    }
    
    func isNext(in route: [WAYGraphEdge], from fromNode: WAYGraphNode) -> Bool {
        
        guard let fromIndex = route.index(where: { $0.sourceID == fromNode.identifier }) else {
            
            return false
        }
        
        let toIndex = fromIndex+1
        
        if route.indices.contains(toIndex) {
            
            return self.identifier == route[toIndex].sourceID
            
        } else {
            
            let nextToLastEdge = route[fromIndex]
            
            return self.identifier == route.last?.targetID && fromNode.identifier == nextToLastEdge.sourceID
        }
    }
    
}


// MARK: - Binary Relations/Operations

/**
Equality operation for two `WAYGraphNode`.

- parameter lhs: Left hand object.
- parameter rhs: Right hand object.

- returns: Whether or not the two `WAYGraphNode` are equal.
*/
func ==(lhs: WAYGraphNode, rhs: WAYGraphNode) -> Bool {
    return (lhs.identifier == rhs.identifier &&
        lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.name == rhs.name &&
        lhs.accuracy == rhs.accuracy)
}
