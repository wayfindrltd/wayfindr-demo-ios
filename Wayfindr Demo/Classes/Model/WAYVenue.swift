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
    private(set) var platforms: [WAYPlatform]
    /// All of the exits in the venue.
    private(set) var exits: [WAYExit]
    /// All of the station facilities in the venue.
    private(set) var stationFacilities: [WAYFacility]
    
    /**
     Keys for the data in the `venue` JSON element.
     */

    fileprivate enum WAYVenueKeys: String {
        case Name               = "name"
        case Platforms          = "platforms"
        case Exits              = "exits"
        case StationFacilities  = "station_facilities"
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

    private enum WAYExitKeys: String {
        case Name                   = "name"
        case Mode                   = "mode"
        case EntranceBeaconMajor    = "entrance_beacon_major"
        case EntranceBeaconMinor    = "entrance_beacon_minor"
        case ExitBeaconMajor        = "exit_beacon_major"
        case ExitBeaconMinor        = "exit_beacon_minor"
    }

    /**
     Keys for the data in the facilities (`station_facilities`) JSON element.
     */
    private enum WAYFacilityKeys: String {
        case Name                   = "name"
        case Mode                   = "mode"
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

        self.name = venueJSON[WAYVenueKeys.Name.rawValue].stringValue
        self.platforms = [WAYPlatform]()
        self.exits = [WAYExit]()
        self.stationFacilities = [WAYFacility]()
        self.destinationGraph = graph

        try platforms = platformsFromJSON(venueJSON: venueJSON, graph: graph)
        try exits = exitsFromJSON(venueJSON: venueJSON, graph: graph)
        try stationFacilities = stationFacilitiesFromJSON(venueJSON: venueJSON, graph: graph)
    }


    private func platformsFromJSON(venueJSON: JSON, graph: WAYGraph) throws -> [WAYPlatform] {
        var tempPlatforms = [WAYPlatform]()


        if let platformsJSON = venueJSON[WAYVenueKeys.Platforms.rawValue].array {
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
        } else {
            throw WAYError.invalidVenue
        }

        return tempPlatforms
    }

    private func exitsFromJSON(venueJSON: JSON, graph: WAYGraph) throws -> [WAYExit] {
        var tempExits = [WAYExit]()

        if let exitsJSON = venueJSON[WAYVenueKeys.Exits.rawValue].array {
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
        } else {
            throw WAYError.invalidVenue
        }

        return tempExits
    }

    func stationFacilitiesFromJSON(venueJSON: JSON, graph: WAYGraph) throws -> [WAYFacility] {
        if let facilitiesJSON = venueJSON[WAYVenueKeys.StationFacilities.rawValue].array {
            do {
                return try facilitiesFromJSON(facilitiesJSON: facilitiesJSON, graph: graph)

            } catch { throw WAYError.invalidStationFacility }

        } else {
            throw WAYError.invalidVenue
        }
    }

    func facilitiesFromJSON(facilitiesJSON: [JSON], graph: WAYGraph) throws -> [WAYFacility] {
        var facilities = [WAYFacility]()

        for facilityJSON in facilitiesJSON {
            let facility = try facilityFromJSON(facilityJSON: facilityJSON, graph: graph)

            facilities.append(facility)
        }

        return facilities
    }

    func facilityFromJSON(facilityJSON: JSON, graph: WAYGraph) throws -> WAYFacility {
        guard let facilityName = facilityJSON[WAYFacilityKeys.Name.rawValue].string,
            let facilityEntranceBeaconMajor = facilityJSON[WAYFacilityKeys.EntranceBeaconMajor.rawValue].int,
            let facilityEntranceBeaconMinor = facilityJSON[WAYFacilityKeys.EntranceBeaconMinor.rawValue].int,
            let facilityExitBeaconMajor = facilityJSON[WAYFacilityKeys.ExitBeaconMajor.rawValue].int,
            let facilityExitBeaconMinor = facilityJSON[WAYFacilityKeys.ExitBeaconMinor.rawValue].int,
            let facilityEntranceNode = graph.getNode(major: facilityEntranceBeaconMajor, minor: facilityEntranceBeaconMinor),
            let facilityExitNode = graph.getNode(major: facilityExitBeaconMajor, minor: facilityExitBeaconMinor) else {

                throw WAYError.invalidFacility
        }

        return WAYFacility(entranceNode: facilityEntranceNode, exitNode: facilityExitNode, name: facilityName)
    }
}
