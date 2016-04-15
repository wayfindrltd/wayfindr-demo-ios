//
//  WAYGraph.swift
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
import SwiftGraph


/**
 *  Represents a graph of desitations (nodes) and paths (edges).
 */
struct WAYGraph: CustomStringConvertible {
    
    
    // MARK: - Properties
    
    /// `WeightedGraph` representation of the destination graph.
    let graph = WeightedGraph<WAYGraphNode, Double>()
    var edges = [WAYGraphEdge]()
    
    var vertices: [WAYGraphNode] {
        var result = [WAYGraphNode]()
        
        for index in 0 ..< graph.vertexCount {
            result.append(graph.vertexAtIndex(index))
        }
        
        return result
    }
    
    /// Name of the root graph node in the xml.
    private let rootNodeName = "graph"
    
    /**
     Data element names the `graph` GraphML element.
     */
    private enum WAYGraphElementType: String {
        case Node = "node"
        case Edge = "edge"
    }
    
    /// Plain text description of the graph.
    var description: String {
        get {
            return graph.description
        }
    }
    
    
    // MARK: - Initializers
    
    init?(filePath: String, updatedEdges: [WAYGraphEdge]? = nil) throws {
        if let xmlData = NSData(contentsOfFile: filePath),
            xmlDocument = try? AEXMLDocument(xmlData: xmlData) {
                
                try self.init(xmlDocument: xmlDocument, updatedEdges: updatedEdges)
                
                return
        }
        
        return nil
    }
    
     /**
     Initialize a `WAYGraph` from an xml document.
     
     - parameter xmlDocument:  `AEXMLDocument` representing the graph. Must be in GraphML format.
     - parameter languageCode: Language code in BCP-47 code format for instructions. Default is "en-GB".
     - parameter updatedEdges: An array of more up-to-date edges to supercede those from the `xmlDocument`.
     
     - throws: Thorws a `WAYError` representing the source of the error.
     */
    init(xmlDocument: AEXMLDocument, languageCode: String = "en-GB", updatedEdges: [WAYGraphEdge]? = nil) throws {
        // Ensure the document contains a `graph` element.
        guard xmlDocument.root[rootNodeName].all?.count > 0 else {
            throw WAYError.InvalidGraph
        }
        
        guard let defaultAccuracyNode = xmlDocument.root["key"].allWithAttributes(["id" : "accuracy"])?.first,
            let defaultAccuracy = defaultAccuracyNode["default"].first?.doubleValue else {
            
            throw WAYError.InvalidGraph
        }
        
        let graphRootNode = xmlDocument.root[rootNodeName]
        
        // Parse the nodes and edges.
        for child in graphRootNode.children {
            if let elementType = WAYGraphElementType(rawValue: child.name) {
                
                switch elementType {
                case .Node:
                    do {
                        let node = try WAYGraphNode(xmlElement: child, defaultAccuracy: defaultAccuracy)
                        graph.addVertex(node)
                    } catch let error as WAYError {
                        throw error
                    }
                case .Edge:
                    do {
                        if let edge = try WAYGraphEdge(xmlElement: child, languageCode: languageCode) {
                            edges.append(edge)
                        }
                    } catch let error as WAYError {
                        throw error
                    }
                }
                
            }
        }
        
        // Add the edges to the graph
        for (index, edge) in edges.enumerate() {
            guard let sourceIndex = graph.indexOf({$0.identifier == edge.sourceID}),
                let targetIndex = graph.indexOf({$0.identifier == edge.targetID}) else {
                    
                    // We created an edge but can't find one of its node endpoints. We must have bad XML.
                    throw WAYError.InvalidGraphEdge
            }
            
            // Check to see if there is updated edge information (e.g. there may be a partial closure)
            if let myUpdatedEdges = updatedEdges,
                updatedEdgeIndex = myUpdatedEdges.indexOf({$0.identifier == edge.identifier}) {
                    let updatedEdge = myUpdatedEdges[updatedEdgeIndex]
                
                    edges.removeAtIndex(index)
                    edges.insert(updatedEdge, atIndex: index)
                    
                    graph.addEdge(sourceIndex, to: targetIndex, directed: true, weight: updatedEdge.weight)
            } else {
                graph.addEdge(sourceIndex, to: targetIndex, directed: true, weight: edge.weight)
            }
        }
    }
    
    
    // MARK: - Fetch Vertex/Edge
    
    /**
    Returns the `WAYGraphNode` with the given `major` and `minor` values.
    
    - parameter major: Major becaon value.
    - parameter minor: Minor beacon value.
    
    - returns: The `WAYGraphNode` with the given `major` and `minor` values, if one exists.
    */
    func getNode(major major: Int, minor: Int) -> WAYGraphNode? {
        guard let vertexIndex = graph.indexOf({ $0.major == major && $0.minor == minor }) else {
            return nil
        }
        
        return graph.vertexAtIndex(vertexIndex)
    }
    
    /**
     Returns the `WAYGraphNode` with the given identifier.
     
     - parameter nodeIdentifier: Identifier of the node.
     
     - returns: The `WAYGraphNode` with the given identifier, if one exists.
     */
    func getNode(identifier nodeIdentifier: String) -> WAYGraphNode? {
        guard let vertexIndex = graph.indexOf({ $0.identifier == nodeIdentifier }) else {
            return nil
        }
        
        return graph.vertexAtIndex(vertexIndex)
    }
    
    /**
     Returns the `WAYGraphEdge` with the given source and target node indices.
     
     - parameter sourceNodeIndex: Index of the source node.
     - parameter targetNodeIndex: Index of the target node.
     
     - returns: The `WAYGraphEdge` with the given source and target node indices, if one exists.
     */
    func getEdge(sourceNodeIndex: Int, targetNodeIndex: Int) -> WAYGraphEdge? {
        guard sourceNodeIndex < graph.count &&
            targetNodeIndex < graph.count else {
                return nil
        }
        
        let sourceNode = graph.vertexAtIndex(sourceNodeIndex)
        let targetNode = graph.vertexAtIndex(targetNodeIndex)
        
        guard let edgeIndex = edges.indexOf({ $0.sourceID == sourceNode.identifier && $0.targetID == targetNode.identifier }) else {
            return nil
        }
        
        return edges[edgeIndex]
    }
    
    
    // MARK: - Routing
    
    /**
    Determines whether or not you can find a path from the `fromNode` to the `toNode`.
    
    - parameter fromNode: Beginning of the path.
    - parameter toNode:   End of the path.
    
    - returns: Whether or not you can find a path from the `fromNode` to the `toNode`.
    */
    func canRoute(fromNode: WAYGraphNode, toNode: WAYGraphNode) -> Bool {
        guard let startNodeIndex = graph.indexOf(fromNode),
            let destinationNodeIndex = graph.indexOf(toNode) else {
                return false
        }
        
        let route = bfs(startNodeIndex, to: destinationNodeIndex, graph: graph)
        
        return !route.isEmpty
    }
    
    /**
     Calculates the shortest route between the nodes, if one exists. Otherwise returns nil.
     
     - parameter fromNode: Beginning of the path.
     - parameter toNode:   End of the path.
     
     - returns: The shortest route between the nodes, if one exists. Otherwise returns nil.
     */
    func shortestRoute(fromNode: WAYGraphNode, toNode: WAYGraphNode) -> [WAYGraphEdge]? {
        guard canRoute(fromNode, toNode: toNode) else {
            return nil
        }
        
        guard let fromIndex = graph.indexOf(fromNode),
            let toIndex = graph.indexOf(toNode) else {
                return nil
        }
        
        let (_, paths) = dijkstra(graph, root: fromNode)
        
        let shortestPath = pathDictToPath(fromIndex, to: toIndex, pathDict: paths)
        
        var route = [WAYGraphEdge]()
        for pathItem in shortestPath {
            if let myEdge = getEdge(pathItem.u, targetNodeIndex: pathItem.v) {
                route.append(myEdge)
            }
        }
        
        return route
    }
    
}
