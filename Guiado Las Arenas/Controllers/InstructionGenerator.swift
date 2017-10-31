//
//  InstructionGenerator.swift
//  Wayfindr Demo
//
//  Created by Technosite on 19/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import Foundation

struct InstructionGenerator {
    
    //MARK: - Variables
    
    var previousNode: Node
    var currentNode: Node
    var destinationNode: Node
    var euclideanDistance: Double
    var flagRecalculated: Bool
    var nearInstruction: Bool
    var instructionDistance: Bool
    var fingerprint: Fingerprint
    var routeID: Int
    var angle: Double
    let d = Double(UserDefaults.standard.integer(forKey: "Instruction of distance"))
    let nd = Double(UserDefaults.standard.integer(forKey: "Near instructions"))
    let p = UserDefaults.standard.double(forKey: "Precision")
    let log = Log()
    
    //MARK: - Init
    
    init(previousNode: Node, currentNode: Node, destinationNode: Node, eucledianDistance: Double, flagRecalculated: Bool,
         nearInstruction: Bool, instructionDistance: Bool, fingerprint: Fingerprint, routeID: Int, angle: Double) {
        self.previousNode = previousNode
        self.currentNode = currentNode
        self.destinationNode = destinationNode
        self.euclideanDistance = eucledianDistance
        self.flagRecalculated = flagRecalculated
        self.nearInstruction = nearInstruction
        self.instructionDistance = instructionDistance
        self.fingerprint = fingerprint
        self.routeID = routeID
        self.angle = angle
    }
    
    //MARK: - Main function
    
    mutating func generateInstruction() -> String? {
        
        var instruction: String?
        
        if previousNode.nodeID == currentNode.nodeID {
            if instructionDistance == true && nearInstruction == true {
                instruction = nil
                log.writeInstructionLog(option: 2, currentNodeID: currentNode.nodeID, instruction: nil, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: nil)
            } else {
                
                if (instructionDistance == false && (d + p >= euclideanDistance) && (euclideanDistance > (nd + p))) {
                    instructionDistance = true
                    instruction = setUpInstructionType1()
                } else {
                    
                    if (nearInstruction == false && (nd + p >= euclideanDistance)) {
                        nearInstruction = true
                        instruction = setUpInstructionType2()
                    } else {
                        instruction = nil
                        log.writeInstructionLog(option: 7, currentNodeID: currentNode.nodeID, instruction: nil, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: nil)
                    }
                }
            }
        } else {
            instruction = setUpInstructionType0()
        }
        
        return instruction
    }
    
    // MARK: - Getters
    
    func getInstructionDistance() -> Bool {
        return instructionDistance
    }
    
    func getNearInstruction() -> Bool {
        return nearInstruction
    }
    
    // MARK: - Instruction Type
    
    mutating func setUpInstructionType0() -> String? {
        var instruction: String?
        previousNode = currentNode
        instructionDistance = false
        nearInstruction = false
        if flagRecalculated == false {
            instruction = DBManager.shared.loadInstruction(startNodeID: currentNode.nodeID, endNodeId: destinationNode.nodeID, routeID: routeID, Type: 0)
        } else {
            instruction = ConstantsStrings.instructions.error
        }
        
        log.writeInstructionLog(option: 1, currentNodeID: currentNode.nodeID, instruction: instruction, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: instruction)
        return instruction
    }
    
    func setUpInstructionType1() -> String? {
        let instruction = DBManager.shared.loadInstruction(startNodeID: currentNode.nodeID, endNodeId: destinationNode.nodeID, routeID: routeID, Type: 1)
        
        if instruction != nil {
            log.writeInstructionLog(option: 3, currentNodeID: currentNode.nodeID, instruction: instruction, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: instruction)
        } else {
            log.writeInstructionLog(option: 4, currentNodeID: currentNode.nodeID, instruction: nil, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: nil)
        }
        
        return instruction
    }
    
    func setUpInstructionType2() -> String? {
        let instruction = DBManager.shared.loadInstruction(startNodeID: currentNode.nodeID, endNodeId: destinationNode.nodeID, routeID: routeID, Type: 2)
        
        if instruction != nil {
            log.writeInstructionLog(option: 5, currentNodeID: currentNode.nodeID, instruction: instruction, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: instruction)
        } else {
            log.writeInstructionLog(option: 6, currentNodeID: currentNode.nodeID, instruction: nil, destinationNode: destinationNode, fingerprint: fingerprint, euclideanDistance: euclideanDistance, angle: angle, instructionDistance: instruction)
        }
        
        return instruction
    }
    
}
