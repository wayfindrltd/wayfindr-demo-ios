//
//  WAYInstructionSet.swift
//  Wayfindr Tests
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

import Foundation
import AEXML


/**
 *  Represents a set of instructions to be associated with a `WAYGraphEdge`.
 */
struct WAYInstructionSet {
    
    
    // MARK: - Properties
    
    /// The language of the instruction set in BCP-47 code format.
    let language: String
    
    /// The instructions for the beginning of the path.
    var beginning: String?
    /// The instructions for the middle of the path.
    var middle: String?
    /// The instructions for the end of the path.
    var ending: String?
    /// The instructions if you are starting the route from with this edge, otherwise unused.
    var startingOnly: String?
    
    /**
     Keys for the data in the `edge` GraphML element.
     */
    enum WAYInstructionKeys: String {
        case InstructionBeginning = "beginning"
        case InstructionMiddle = "middle"
        case InstructionEnd = "ending"
        case InstructionStartingOnly = "starting_only"
        case Language = "language"
        
        static let allValues = [InstructionBeginning, InstructionMiddle, InstructionEnd, InstructionStartingOnly, Language]
    }
    
    
    // MARK: - Initializers
    
    /**
    Initialize a `WAYInstructionSet` from an xml element.
    
    - parameter xmlElement: `AEXMLElement` representing the edge. Must be in GraphML format.
    
    - throws:   Throws a `WAYError` if the `xmlElement` is not in the correct format.
    */
    init(xmlElement: AEXMLElement) throws {
        // Temporary storage for the data elements
        var tempLanguage: String?
        var tempBeginning: String?
        var tempMiddle: String?
        var tempEnding: String?
        var tempStartingOnly: String?
        
        // Parse the data
        for dataItem in xmlElement.children {
            
            if let keyAttribute = dataItem.attributes["key"],
                let dataItemType = WAYInstructionKeys(rawValue: keyAttribute) {
                    
                    switch dataItemType {
                    case .Language:
                        tempLanguage = dataItem.string
                    case .InstructionBeginning:
                        tempBeginning = dataItem.string
                    case .InstructionMiddle:
                        tempMiddle = dataItem.string
                    case .InstructionEnd:
                        tempEnding = dataItem.string
                    case .InstructionStartingOnly:
                        tempStartingOnly = dataItem.string
                    }
            }
            
        }
        
        // Ensure we have found all elements
        guard let myLanguage = tempLanguage else {
            throw WAYError.invalidInstructionSet
        }
        
        // Permanently store the elements
        language = myLanguage
        
        beginning = tempBeginning
        middle = tempMiddle
        ending = tempEnding
        startingOnly = tempStartingOnly
        
        // Check to ensure that the `startingOnly` instruction only exists if no other instructions do.
        if (beginning != nil || middle != nil || ending != nil) && startingOnly != nil {
            throw WAYError.invalidInstructionSet
        }
    }
    
    init(language: String, beginning: String? = nil, middle: String? = nil, ending: String? = nil, startingOnly: String? = nil) {
        self.language = language
        self.beginning = beginning
        self.middle = middle
        self.ending = ending
        self.startingOnly = startingOnly
    }
    
    
    // MARK: - Convenience Getters
    
    func allInstructions() -> [String] {
        var result = [String]()
        
        if let myBeginning = beginning {
            result.append(myBeginning)
        }
        if let myMiddle = middle {
            result.append(myMiddle)
        }
        if let myEnding = ending {
            result.append(myEnding)
        }
        
        return result
    }
    
}
