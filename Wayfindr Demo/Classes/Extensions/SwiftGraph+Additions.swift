//
//  SwiftGraph+Additions.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 18/11/2015.
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

import SwiftGraph


extension Graph {
    
    /// Whether or not the graph is connected (i.e. you can travel from any node to any other node).
    var isConnected: Bool {
        for (index, _) in self.enumerated() {
            for (index2, _) in self.enumerated() {
                if index != index2 {
                    
                    let route = self.bfs(from: index, to: index2)
                    
                    if route.isEmpty {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    /// Returns an array of tuples identifying discontinuities in the graph. Each tuple represents indices of a two nodes with the initial value being the index of the starting node. 
    var discontinuities: [(Int, Int)] {
        var missingEdges = [(Int, Int)]()
        
        for (index, _) in self.enumerated() {
            for (index2, _) in self.enumerated() {
                if index != index2 {
                    let route = self.bfs(from: index, to: index2)
                    
                    if route.isEmpty {
                        missingEdges.append((index, index2))
                    }
                }
            }
        }
        
        return missingEdges
    }
    
}
