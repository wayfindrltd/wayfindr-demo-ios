//
//  Router.swift
//  Wayfindr Demo
//
//  Created by Technosite on 18/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import Foundation
import UIKit

struct Router {
    
    //MARK: - Variables
    
    var currentFingerprint: Fingerprint
    var newFingerprint: Fingerprint
    var currentNode: Node
    var destinationNode: Node
    var nodes: [Node]
    var routeID: Int
    var currentEucledianDistance: Double
    var allNodes: [Node]
    let log = Log()
    var angle: Double = 0.0
    
    //MARK: - Init
    
    init(currentFingerprint: Fingerprint,
         newFingerprint: Fingerprint, currentNode: Node, destinationNode: Node, nodes: [Node], routeID: Int, currentEucledianDistance: Double) {
        self.currentFingerprint = currentFingerprint
        self.newFingerprint = newFingerprint
        self.currentNode = currentNode
        self.destinationNode = destinationNode
        self.nodes = nodes
        self.routeID = routeID
        self.currentEucledianDistance = currentEucledianDistance
        self.allNodes = DBManager.shared.loadNodes()
    }
    
    //MARK: - Main Function
    
    mutating func checkFingerprint() -> Orquestrator {
        
        var orquestrator: Orquestrator = Orquestrator(currentNode: currentNode, destinationNode: destinationNode, eucledianDistance: currentEucledianDistance, flagRecalculated: false, angle: angle)
        var eucledianDistanceNode: Double
        let eucledianDistanceFingerprint = getDistanceFromFingerprintToDestinationNode(destinationNode: destinationNode)
        var logRouter = ""
        
        if newFingerprint.fingerprintID == currentFingerprint.fingerprintID {
            
            angle = calculateAngle(fingerprint: currentFingerprint, obtainedFingerprint: newFingerprint, destinationNode: destinationNode)
            orquestrator = Orquestrator(currentNode: nil, destinationNode: nil, eucledianDistance: -1, flagRecalculated: false, angle: angle)
            log.writeRouterLog(currentFingerprint: currentFingerprint, currentNode: currentNode, angle: angle, destinationNode: destinationNode, eucledianDistance: 0)
        } else {
            
            let obtainedNode = getNearNode(nodes: allNodes).0
            eucledianDistanceNode = getNearNode(nodes: allNodes).1
            let assignationDistance = UserDefaults.standard.integer(forKey: "Assignation distance")
            let precision = UserDefaults.standard.double(forKey: "Precision")
            let sumAdP = Double(assignationDistance) + precision
            
            if eucledianDistanceNode <= sumAdP {
                if obtainedNode.nodeID == currentNode.nodeID {
                    
                    angle = calculateAngle(fingerprint: currentFingerprint, obtainedFingerprint: newFingerprint, destinationNode: destinationNode)
                    currentFingerprint = newFingerprint
                    
                    orquestrator = Orquestrator(currentNode: currentNode, destinationNode: destinationNode, eucledianDistance: eucledianDistanceFingerprint, flagRecalculated: false, angle: angle)
                    log.writeRouterLog(currentFingerprint: currentFingerprint, currentNode: currentNode, angle: angle, destinationNode: destinationNode, eucledianDistance: eucledianDistanceNode)
                    
                } else {
                    if destinationNode.nodeID == obtainedNode.nodeID || checkifNodeExist(checkedNode: obtainedNode) {
                        
                        currentNode = obtainedNode
                        destinationNode = DBManager.shared.loadEndNode(routeID: routeID, startNodeID: currentNode.nodeID)
                        angle = calculateAngle(fingerprint: currentFingerprint, obtainedFingerprint: newFingerprint, destinationNode: destinationNode)
                        currentFingerprint = newFingerprint
                        orquestrator = Orquestrator(currentNode: currentNode, destinationNode: destinationNode, eucledianDistance: eucledianDistanceFingerprint, flagRecalculated: false, angle: angle)
                        log.writeRouterLog(currentFingerprint: currentFingerprint, currentNode: currentNode, angle: angle, destinationNode: destinationNode, eucledianDistance: eucledianDistanceNode)
                        
                    } else {
                        destinationNode = currentNode
                        currentNode = obtainedNode
                        
                        angle = calculateAngle(fingerprint: currentFingerprint, obtainedFingerprint: newFingerprint, destinationNode: destinationNode)
                        currentFingerprint = newFingerprint
                        orquestrator = Orquestrator(currentNode: currentNode, destinationNode: destinationNode, eucledianDistance: eucledianDistanceFingerprint, flagRecalculated: true, angle: angle)
                        log.writeRouterLog(currentFingerprint: currentFingerprint, currentNode: currentNode, angle: angle, destinationNode: destinationNode, eucledianDistance: eucledianDistanceNode)
                    }
                }
            } else {
                angle = calculateAngle(fingerprint: currentFingerprint, obtainedFingerprint: newFingerprint, destinationNode: destinationNode)
                currentFingerprint = newFingerprint
                orquestrator = Orquestrator(currentNode: currentNode, destinationNode: destinationNode, eucledianDistance: eucledianDistanceFingerprint, flagRecalculated: false, angle: angle)
                log.writeRouterLog(currentFingerprint: currentFingerprint, currentNode: currentNode, angle: angle, destinationNode: destinationNode, eucledianDistance: eucledianDistanceNode)
            }
        }
        return orquestrator
    }
    
    //MARK: - Calculation functions
    
    func calculateAngle(fingerprint: Fingerprint, obtainedFingerprint: Fingerprint, destinationNode: Node) -> Double {
        
        let a1 = obtainedFingerprint.x - destinationNode.x
        let a2 = obtainedFingerprint.y - destinationNode.y
        let b1 = obtainedFingerprint.x - fingerprint.x
        let b2 = obtainedFingerprint.y - fingerprint.y
        
        let numerator = (b1 * a1) + (b2 * a2)
        let firstOperand = sqrt(pow(a1, 2) + pow(a2, 2))
        let secondOperand = sqrt(pow(b1, 2) + pow(b2, 2))
        let denominator = firstOperand * secondOperand
        let B = acos(numerator/denominator)
        
        var A = 180 - ((B * 180.0)/M_PI)
        
        if fingerprint.y == obtainedFingerprint.y || fingerprint.x == obtainedFingerprint.x {
            if destinationNode.y > fingerprint.y || destinationNode.x > fingerprint.x {
                A = A * -1
            }
            
            if destinationNode.y < fingerprint.y || destinationNode.y == fingerprint.y || destinationNode.x < fingerprint.x || destinationNode.x == fingerprint.x {
                A = A * 1
            }
        } else {
            let x0 = (-fingerprint.y * (obtainedFingerprint.x - fingerprint.x))/((obtainedFingerprint.y - fingerprint.y) + fingerprint.x)
            var alfa = atan(fingerprint.y/(fingerprint.x - x0)) * 180/M_PI
            if alfa < 0 {
                alfa = 180 + alfa
            }
            var beta = atan(destinationNode.y/(destinationNode.x - x0)) * 180/M_PI
            if beta < 0 {
                beta = 180 + beta
            }
            
            if beta < alfa {
                A = A * 1
            } else {
                A = A * -1
            }
        }
        
        return A
    }
    
    func getNearNode(nodes: [Node]) -> (Node, Double){
        
        var eucledianDistance: Double = 1000000.0
        var obtainedNode: Node?
        
        for node in nodes {
            let newEucledianDistance = sqrt((pow(node.x - (newFingerprint.x), 2)) + pow(node.y - (newFingerprint.y), 2))
            if newEucledianDistance < eucledianDistance {
                obtainedNode = node
                eucledianDistance = newEucledianDistance
            }
        }
        
        return (obtainedNode!, eucledianDistance)
        
    }
    
    func getNearNodeFilter(nodes: [Node]) -> (Node, Double){
        var eucledianDistance: Double = 1000000.0
        var obtainedNode: Node?
        
        for node in nodes {
            let newEucledianDistance = sqrt((pow(node.x - (newFingerprint.x), 2)) + pow(node.y - (newFingerprint.y), 2))
            if newEucledianDistance < eucledianDistance {
                obtainedNode = node
                eucledianDistance = newEucledianDistance
            }
        }
        
        return (obtainedNode!, eucledianDistance)
    }
    
    func getDistanceFromFingerprintToDestinationNode(destinationNode: Node) ->  Double{
        
        let newEucledianDistance = sqrt((pow(destinationNode.x - (newFingerprint.x), 2)) + pow(destinationNode.y - (newFingerprint.y), 2))
        
        return newEucledianDistance
        
    }
    
    func getEucledianDistance(nodes: [Node]) -> (Node, Double){
        
        var eucledianDistance: Double = 1000000.0
        var obtainedNode: Node?
        
        for node in nodes {
            let newEucledianDistance = sqrt((pow(node.x - (currentFingerprint.x), 2)) + pow(node.y - (currentFingerprint.y), 2))
            if newEucledianDistance < eucledianDistance {
                obtainedNode = node
                eucledianDistance = newEucledianDistance
            }
        }
        
        return (obtainedNode!, eucledianDistance)
        
    }
    
    func checkifNodeExist(checkedNode: Node) -> Bool {
        var isInNodes = false
        
        for node in nodes {
            if node.nodeID == checkedNode.nodeID {
                isInNodes = true
            }
        }
        
        return isInNodes
    }
}
