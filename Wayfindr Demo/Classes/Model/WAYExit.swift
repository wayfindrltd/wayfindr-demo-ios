//
//  WAYExit.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/11/2015.
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
 *  Represents a transportation exit.
 */
struct WAYExit: WAYDestination {
    
    
    // MARK: - Properties
    
    let entranceNode: WAYGraphNode
    let exitNode: WAYGraphNode
    let name: String
    
    /// Mode by which you can exit the venue (i.e. Escalator, Lift, etc.).
    let mode: String
    
    
    // MARK: - Initializers
    
    /**
    Initialize a `WAYExit`.
    
    - parameter entranceNode:   Beacon associated with the entrance to the exit.
    - parameter exitNode:       Beacon associated with the exit to the exit.
    - parameter mode:           Mode by which you can exit the venue.
    - parameter name:           Name of the exit.
    */
    init(entranceNode: WAYGraphNode, exitNode: WAYGraphNode, mode: String, name: String) {
        self.entranceNode = entranceNode
        self.exitNode = exitNode
        self.mode = mode
        self.name = name
    }
    
}
