//
//  Log.swift
//  Wayfindr Demo
//
//  Created by Carlos Monfort Gómez on 5/10/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import Foundation

struct Log {
    
    //MARK: - Write
    
    func writeLog(log: String) {
        var textFile = ""
        
        let file = "Log.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                // Open the file
                textFile = try String(contentsOf: fileURL, encoding: .utf8)
                textFile = textFile + "\n" + log
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            do {
                // Write to the file
                try textFile.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        } else {
            print("FILE UNAVAILABLE")
        }
    }
    
    func writeLogWayfindr(log: String) {
        var textFile = ""
        
        let file = "LogWayfindr.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                // Open the file
                textFile = try String(contentsOf: fileURL, encoding: .utf8)
                textFile = textFile + "\n" + log
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            do {
                // Write to the file
                try textFile.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        } else {
            print("FILE UNAVAILABLE")
        }
    }
    
    // MARK: - Instruction
    
    func writeInstructionLog(option: Int, currentNodeID: Int, instruction: String?, destinationNode: Node, fingerprint: Fingerprint, euclideanDistance: Double, angle: Double, instructionDistance: String?) {
        
        let routeID = UserDefaults.standard.object(forKey: "Route")
        var logInstructions = ""
        let d = Double(UserDefaults.standard.integer(forKey: "Instruction of distance"))
        let nd = Double(UserDefaults.standard.integer(forKey: "Near instructions"))
        let p = UserDefaults.standard.double(forKey: "Precision")
        
        switch option {
        case 1:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), New node detection = Current Node: \(currentNodeID), " +
                "Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance), Instruction: \(instruction) \n"
        case 2:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), Not instruction given. Reasons: Previously given instructions on approach and on distance." +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance) \n"
        case 3:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), On Distance Instruction, " +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance), Instruction: \(instruction) \n"
        case 4:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), Not instruction given. Reasons: On Distance instruction doesn't exist." +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance) \n"
        case 5:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), On Approach Instruction, " +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance), Instruction: \(instruction) \n"
        case 6:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), Not instruction given. Reasons: On Approach instruction doesn't exist." +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance) \n"
        case 7:
            logInstructions = "LOG INSTRUCTION GENERATOR: TimeStamp: \(getCurrentDate()), RouteID: \(String(describing: routeID)), Not instruction given. Reasons: Previous on distance instruction given = \(instructionDistance)" +
                "Distance ranges: [\(d + p), \(nd + p)] and [\(nd + p), 0], " +
                "Current Node: \(currentNodeID), Fingerprint: \(fingerprint.fingerprintID), Angle: \(angle), Destination Node: \(destinationNode.nodeID), " +
            "Eucledian Distance: \(euclideanDistance), Instruction: \(instruction) \n"
        default:
            logInstructions = "LOG INSTRUCTION GENERATOR: Default \n"
        }
        
        print(logInstructions)
        
        writeLog(log: logInstructions)
        writeLogWayfindr(log: logInstructions)
    }
    
    // MARK: - Router
    
    func writeRouterLog(currentFingerprint: Fingerprint, currentNode: Node, angle: Double, destinationNode: Node, eucledianDistance: Double) {
        let routeID = UserDefaults.standard.object(forKey: "Route")
        
        let log = "ROUTER LOG: TimeStamp: \(getCurrentDate()), Route: \(String(describing: routeID)), Not instructions given. " +
            "Reasons: In the same position (Fingerprint = \(currentFingerprint.fingerprintID), Current Node: \(currentNode.nodeID), " +
        "Angle: \(angle), Destination Node: \(destinationNode.nodeID), Eucledian Distance: \(eucledianDistance) \n"
        
        writeLog(log: log)
        writeLogWayfindr(log: log)
    }
    
    // MARK: - Get, Delete and Print Log
    
    func getLog() -> String {
        
        let file = "Log.txt"
        var textFile = ""
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            do {
                // Open the file
                textFile = try String(contentsOf: fileURL, encoding: .utf8)
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
        } else {
            print("FILE UNAVAILABLE")
        }
        
        return textFile
    }
    
    func deleteLog() {
        
        let file = "Log.txt"
        let textFile = ""
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            do {
                // Write to the file
                try textFile.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
        } else {
            print("FILE UNAVAILABLE")
        }
    }
    
    func printLog() {
        
        let file = "Log.txt"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            print("FILE AVAILABLE")
            do {
                // Open the file
                let textFile = try String(contentsOf: fileURL, encoding: .utf8)
                print("****************************************************************************************")
                print("******************************            LOG            *******************************")
                print(" ")
                print(textFile)
                print(" ")
                print("****************************************************************************************")
            } catch let error as NSError {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
        } else {
            print("FILE UNAVAILABLE")
        }
        
    }
    
    // MARK: - Settings
    
    func writeSettingsToLog() {
        let instructionsDistance = UserDefaults.standard.integer(forKey: "Instruction of distance")
        let nearInstructions = UserDefaults.standard.integer(forKey: "Near instructions")
        let assignationDistance: Int = UserDefaults.standard.integer(forKey: "Assignation distance")
        let precision = UserDefaults.standard.double(forKey: "Precision")
        let locator = UserDefaults.standard.integer(forKey: "Locator")
        let scanningTime = UserDefaults.standard.integer(forKey: "Scanning time")
        let k = UserDefaults.standard.integer(forKey: "K")
        let weight = UserDefaults.standard.integer(forKey: "Weight")
        let maxAccuracy = UserDefaults.standard.integer(forKey: "Max Accuracy")
        let minAccuracy = UserDefaults.standard.integer(forKey: "Min Accuracy")
        let smooth = UserDefaults.standard.float(forKey: "Smooth")
        
        let textFile = "SETTINGS: \n" + "Instructions Distance: \(instructionsDistance) \n" + "Near Instructions: \(nearInstructions) \n" + "Assignation Distance: \(assignationDistance) \n" + "Precision: \(precision) \n" + "Locator: \(locator) \n" + "Scanning Time: \(scanningTime) \n" + "K: \(k) \n" + "Weight: \(weight) \n" + "Max Accuracy: \(maxAccuracy) \n" + "Min Accuracy: \(minAccuracy) \n" + "Smooth: \(smooth) \n"
        
        writeLog(log: textFile)
    }
    
    //MARK: - Date
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.string(from: date)
        
        return formatter.string(from: date)
    }
}
