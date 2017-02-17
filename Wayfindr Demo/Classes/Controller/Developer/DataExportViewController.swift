//
//  DataExportViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 07/01/2016.
//  Copyright © 2016 Wayfindr.org Limited. All rights reserved.
//

import UIKit


final class DataExportViewController: BaseViewController<DataExportView> {
 
    
    // MARK: - Properties
    
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(venue: WAYVenue) {
        self.venue = venue
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    override func setupView() {
        super.setupView()
        
        underlyingView.nodesButton.addTarget(self, action: #selector(DataExportViewController.exportNodeButtonPressed(_:)), for: .touchUpInside)
        underlyingView.edgesButton.addTarget(self, action: #selector(DataExportViewController.exportEdgeButtonPressed(_:)), for: .touchUpInside)
        underlyingView.platformsButton.addTarget(self, action: #selector(DataExportViewController.exportPlatformButtonPressed(_:)), for: .touchUpInside)
        underlyingView.exitsButton.addTarget(self, action: #selector(DataExportViewController.exportExitButtonPressed(_:)), for: .touchUpInside)
    }
    
    
    // MARK: - Control Actions
    
    func exportNodeButtonPressed(_ sender: UIButton) {
        let csvString = csvFromArray(venue.destinationGraph.vertices)
        
        exportCSV(csvString, filePrefix: "node", sourceView: sender)
    }
    
    func exportEdgeButtonPressed(_ sender: UIButton) {
        let csvString = csvFromArray(venue.destinationGraph.edges)
        
        exportCSV(csvString, filePrefix: "edge", sourceView: sender)
    }
    
    func exportPlatformButtonPressed(_ sender: UIButton) {
        let csvString = csvFromArray(venue.platforms)
        
        exportCSV(csvString, filePrefix: "platform", sourceView: sender)
    }
    
    func exportExitButtonPressed(_ sender: UIButton) {
        let csvString = csvFromArray(venue.exits)
        
        exportCSV(csvString, filePrefix: "exit", sourceView: sender)
    }
    
    
    // MARK: - Generate CSV
    
    fileprivate func csvFromArray<T: CSVExportable>(_ dataArray: [T]) -> String {
        var result = T.generateCSVHeaders() + "\n"
        
        for datum in dataArray {
            result += datum.generateCSV() + "\n"
        }
        
        return result
    }
    
    
    // MARK: - Export CSV
    
    fileprivate func exportCSV(_ csvString: String, filePrefix: String, sourceView: UIView) {
        guard let tmpDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            displayExportError()
            print("Error fetching temp directory.")
            return
        }
        
        let tmpDirectoryURL = URL(fileURLWithPath: tmpDirectory, isDirectory: true)
        let fileURL = tmpDirectoryURL.appendingPathComponent("\(filePrefix)_export.csv", isDirectory: false)
        
        guard let csvData = csvString.data(using: String.Encoding.utf16) else {
            displayExportError()
            print("Error encoding data.")
            return
        }
        
        guard (try? csvData.write(to: fileURL, options: [.atomic])) != nil else {
            displayExportError()
            print("Error writing file.")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sourceView
        present(activityController, animated: true, completion: nil)
    }
    
    fileprivate func displayExportError() {
        displayError(title: WAYStrings.CommonStrings.Error, message: "There was an error exporting your data. Please try again.")
    }
    
}


// MARK: - CSVExportable

protocol CSVExportable {
    
    static func generateCSVHeaders() -> String
    func generateCSV() -> String
    
}


// MARK: - WAYGraphNode: CSVExportable

extension WAYGraphNode: CSVExportable {
    
    static func generateCSVHeaders() -> String {
        var result = ""
        let separator = ","
        
        for value in WAYGraphNodeAttributes.allValues {
            if !result.isEmpty { result += separator }
            
            result += value
        }
        
        for value in WAYGraphNodeKeys.allValues {
            if !result.isEmpty { result += separator }
            
            result += value.rawValue
        }
        
        return result
    }
    
    func generateCSV() -> String {
        let separator = ","
        
        return identifier + separator + "\(major)" + separator + "\(minor)" + separator + name + separator + nodeType.description + separator + "\(accuracy)"
    }
    
}


// MARK: - WAYGraphEdge: CSVExportable

extension WAYGraphEdge: CSVExportable {
    
    static func generateCSVHeaders() -> String {
        var result = ""
        let separator = ","
        
        for value in WAYGraphEdgeAttributes.allValues {
            if !result.isEmpty { result += separator }
            
            result += value
        }
        
        for value in WAYGraphEdgeKeys.allValues {
            if !result.isEmpty { result += separator }
            
            result += value.rawValue
        }
        
        if !result.isEmpty { result += separator }
        result += WAYInstructionSet.generateCSVHeaders()
        
        return result
    }
    
    func generateCSV() -> String {
        let separator = ","
        
        return identifier + separator + sourceID + separator + targetID + separator + "\(weight)" + separator + instructions.generateCSV()
    }
    
}


// MARK: - WAYInstructionSet: CSVExportable

extension WAYInstructionSet: CSVExportable {
    
    static func generateCSVHeaders() -> String {
        var result = ""
        let separator = ","
        
        for value in WAYInstructionKeys.allValues {
            if !result.isEmpty { result += separator }
            
            result += value.rawValue
        }
        
        return result
    }
    
    func generateCSV() -> String {
        let separator = ","
        
        return csvEscapeInstruction(beginning) + separator + csvEscapeInstruction(middle) + separator + csvEscapeInstruction(ending) + separator + csvEscapeInstruction(startingOnly) + separator + language
    }
    
    fileprivate func csvEscapeInstruction(_ instruction: String?) -> String {
        var result = ""
        
        if let myInstruction = instruction {
            result = "\"" + myInstruction + "\""
        }
        
        return result
    }
    
}


// MARK: - WAYPlatform: CSVExportable

extension WAYPlatform: CSVExportable {
    
    static func generateCSVHeaders() -> String {
        return "name,entrance,exit,destinations"
    }
    
    func generateCSV() -> String {
        let separator = ","
        
        var destinationList = ""
        for destination in destinations {
            if !destinationList.isEmpty { destinationList += "; " }
            destinationList += destination
        }
        
        return name + separator + entranceNode.beaconID.description + separator + exitNode.beaconID.description + separator + destinationList
    }
    
}


// MARK: - WAYExit: CSVExportable

extension WAYExit: CSVExportable {
    
    static func generateCSVHeaders() -> String {
        return "name,entrance,exit,mode"
    }
    
    func generateCSV() -> String {
        let separator = ","
        
        return name + separator + entranceNode.beaconID.description + separator + exitNode.beaconID.description + separator + mode
    }
    
}
