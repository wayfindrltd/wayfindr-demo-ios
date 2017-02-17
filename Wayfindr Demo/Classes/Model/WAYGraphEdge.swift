//
//  WAYGraphEdge.swift
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
 *  Represents a edge (i.e. a route from one beacon to the next).
 */
struct WAYGraphEdge {
    
    
    // MARK: - Properties
    
    /// Identifier for the edge. Used in the GraphML representation.
    let identifier: String
    /// Identifier for the source node of the edge.
    let sourceID: String
    /// Identifier for the target node of the edge.
    let targetID: String
    
    /// Weight of the edge. Represents the average travel time from source to target in seconds.
    let weight: Double
    
    /// Instructions in for travelling from the source node to the target node.
    let instructions: WAYInstructionSet
    
    /**
     *  Attributes for the `edge` GraphML element.
     */
    struct WAYGraphEdgeAttributes {
        static let identifier = "id"
        static let sourceID = "source"
        static let targetID = "target"
        
        static let allValues = [identifier, sourceID, targetID]
    }
    
    /**
     Keys for the data in the `edge` GraphML element.
     */
    enum WAYGraphEdgeKeys: String {
        case Weight = "travel_time"
        
        static let allValues = [Weight]
    }
    
    
    // MARK: - Initializers
    
    /**
    Initialize a `WAYGraphEdge` from an xml element.
    
    - parameter xmlElement: `AEXMLElement` representing the edge. Must be in GraphML format.
    - parameter languageCode: Language code in BCP-47 code format for instructions. Default is "en-GB".
    
    - throws: Throws a `WAYError` if the `xmlElement` is not in the correct format.
    */
    init?(xmlElement: AEXMLElement, languageCode: String = "en-GB") throws {
        // Temporary storage for the data elements
        var tempWeight: Double?
        
        // Retrieve the ID's
        guard let myID = xmlElement.attributes[WAYGraphEdgeAttributes.identifier],
            let mySourceID = xmlElement.attributes[WAYGraphEdgeAttributes.sourceID],
            let myTargetID = xmlElement.attributes[WAYGraphEdgeAttributes.targetID] else {
            
            throw WAYError.invalidGraphEdge
        }
        identifier = myID
        sourceID = mySourceID
        targetID = myTargetID
        
        // Parse the data
        for dataItem in xmlElement.children {
            
            if let keyAttribute = dataItem.attributes["key"],
                let dataItemType = WAYGraphEdgeKeys(rawValue: keyAttribute) {
                    
                    switch dataItemType {
                    case .Weight:
                        tempWeight = dataItem.double
                    }
            }
            
        }
        
        // Ensure we have found all elements
        guard let myWeight = tempWeight else {
            throw WAYError.invalidGraphEdge
        }
        
        // Permanently store the elements
        weight = myWeight
        
        do {
            let myInstructions = try WAYInstructionSet(xmlElement: xmlElement)
            
            if myInstructions.language == languageCode {
                instructions = myInstructions
            } else {
                // Instruction set was not from the correct language. Return nil as this is not an error.
                return nil
            }
        } catch let error as WAYError {
            throw error
        }
    }
    
    init(identifier: String, sourceID: String, targetID: String, weight: Double, instructions: WAYInstructionSet) {
        
        self.identifier = identifier
        self.sourceID = sourceID
        self.targetID = targetID
        self.weight = weight
        self.instructions = instructions
    }
    
}
