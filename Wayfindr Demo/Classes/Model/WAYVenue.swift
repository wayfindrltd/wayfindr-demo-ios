//
//  WAYVenue.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 11/11/2015.
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

import SwiftyJSON


/**
 *  Represents a venue
 */
struct WAYVenue {
    
    
    // MARK: - Properties
    
    /// Name of the venue.
    let name: String
    /// Graph of all the destinations (beacons) and paths (edges).
    let destinationGraph: WAYGraph
    
    /// All of the platforms in the venue.
    let platforms: [WAYPlatform]
    /// All of the exits in the venue.
    let exits: [WAYExit]
    
    /**
     Keys for the data in the `venue` JSON element.
     */
    fileprivate enum WAYVenueKeys: String {
        case Name       = "name"
        case Platforms  = "platforms"
        case Exits      = "exits"
    }
    
    /**
     Keys for the data in the `platform` JSON element.
     */
    fileprivate enum WAYPlatformKeys: String {
        case Name                   = "name"
        case Destinations           = "destinations"
        case EntranceBeaconMajor    = "entrance_beacon_major"
        case EntranceBeaconMinor    = "entrance_beacon_minor"
        case ExitBeaconMajor        = "exit_beacon_major"
        case ExitBeaconMinor        = "exit_beacon_minor"
    }
    
    /**
     Keys for the data in the `exit` JSON element.
     */
    fileprivate enum WAYExitKeys: String {
        case Name           = "name"
        case Mode           = "mode"
        case EntranceBeaconMajor    = "entrance_beacon_major"
        case EntranceBeaconMinor    = "entrance_beacon_minor"
        case ExitBeaconMajor        = "exit_beacon_major"
        case ExitBeaconMinor        = "exit_beacon_minor"
    }
    
    
    // MARK: - Initializers
    
    init(venueFilePath: String, graphFilePath: String, updatedEdges: [WAYGraphEdge]? = nil) throws {
        if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: venueFilePath)),
            let myGraph = try WAYGraph(filePath: graphFilePath, updatedEdges: updatedEdges) {
                
                let venueJSON = JSON(data: jsonData)
                try self.init(graph: myGraph, venueJSON: venueJSON["venue"])
                
                return
        } else {
            throw WAYError.failed(localizedDescription: WAYStrings.ErrorMessages.UnableFindFiles)
        }
    }
    
    /**
    Initialize a `WAYVenue` from a graph and a JSON with platform data.
    
    - parameter graph:       Graph of beacons and paths.
    - parameter venueJSON:   JSON containing venue data.
     
    - throws:   Throws a `WAYError` if the `venueJSON` is not in the correct format.
    */
    init(graph: WAYGraph, venueJSON: JSON) throws {
        
        var tempPlatforms = [WAYPlatform]()
        var tempExits = [WAYExit]()
        
        guard let platformsJSON = venueJSON[WAYVenueKeys.Platforms.rawValue].array,
            let exitsJSON = venueJSON[WAYVenueKeys.Exits.rawValue].array else {
                
            throw WAYError.invalidVenue
        }
        
        for platformJSON in platformsJSON {
            guard let platformName = platformJSON[WAYPlatformKeys.Name.rawValue].string,
                let platformDestinationsJSON = platformJSON[WAYPlatformKeys.Destinations.rawValue].array,
                let platformEntranceBeaconMajor = platformJSON[WAYPlatformKeys.EntranceBeaconMajor.rawValue].int,
                let platformEntranceBeaconMinor = platformJSON[WAYPlatformKeys.EntranceBeaconMinor.rawValue].int,
                let platformExitBeaconMajor = platformJSON[WAYPlatformKeys.ExitBeaconMajor.rawValue].int,
                let platformExitBeaconMinor = platformJSON[WAYPlatformKeys.ExitBeaconMinor.rawValue].int,
                let platformEntranceNode = graph.getNode(major: platformEntranceBeaconMajor, minor: platformEntranceBeaconMinor),
                let platformExitNode = graph.getNode(major: platformExitBeaconMajor, minor: platformExitBeaconMinor) else {
                    
                    throw WAYError.invalidPlatform
            }
            
            let platformDestinations = platformDestinationsJSON.map { $0.stringValue }
            
            let platform = WAYPlatform(entranceNode: platformEntranceNode, exitNode: platformExitNode, destinations: platformDestinations, name: platformName)
            
            tempPlatforms.append(platform)
        }
        
        for exitJSON in exitsJSON {
            guard let exitName = exitJSON[WAYExitKeys.Name.rawValue].string,
                let exitMode = exitJSON[WAYExitKeys.Mode.rawValue].string,
                let exitEntranceBeaconMajor = exitJSON[WAYExitKeys.EntranceBeaconMajor.rawValue].int,
                let exitEntranceBeaconMinor = exitJSON[WAYExitKeys.EntranceBeaconMinor.rawValue].int,
                let exitExitBeaconMajor = exitJSON[WAYExitKeys.ExitBeaconMajor.rawValue].int,
                let exitExitBeaconMinor = exitJSON[WAYExitKeys.ExitBeaconMinor.rawValue].int,
                let exitEntranceNode = graph.getNode(major: exitEntranceBeaconMajor, minor: exitEntranceBeaconMinor),
                let exitExitNode = graph.getNode(major: exitExitBeaconMajor, minor: exitExitBeaconMinor) else {
                    
                    throw WAYError.invalidExit
            }
            
            let exit = WAYExit(entranceNode: exitEntranceNode, exitNode: exitExitNode, mode: exitMode, name: exitName)
            
            tempExits.append(exit)
        }
        
        self.name = venueJSON[WAYVenueKeys.Name.rawValue].stringValue
        self.platforms = tempPlatforms
        self.exits = tempExits
        self.destinationGraph = graph
    }
    
}
