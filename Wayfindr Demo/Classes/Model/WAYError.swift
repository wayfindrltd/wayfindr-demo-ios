//
//  WAYError.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
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


enum WAYError: Error, Equatable, CustomStringConvertible {
    
    case failed(localizedDescription: String)
    case invalidExit
    case invalidGraph
    case invalidGraphEdge
    case invalidGraphNode
    case invalidInstructionSet
    case invalidPlatform
    case invalidFacility
    case invalidStationFacility
    case invalidVenue

    
    var description: String {
        switch self {
        case let .failed(localizedDescription):
            return "Failed: \(localizedDescription)"
        case .invalidExit:
            return "Invalid Exit"
        case .invalidGraph:
            return "Invalid Graph"
        case .invalidGraphEdge:
            return "Invalid Graph Edge"
        case .invalidGraphNode:
            return "Invalid Graph Node"
        case .invalidInstructionSet:
            return "Invalid Instruction Set"
        case .invalidPlatform:
            return "Invalid Platform"
        case .invalidFacility:
            return "Invalid Facility"
        case .invalidStationFacility:
            return "Invalid Station Facility"
        case .invalidVenue:
            return "Invalid Venue"
        }
    }
}

func == (lhs: WAYError, rhs: WAYError) -> Bool {
    return lhs.description == rhs.description
}
