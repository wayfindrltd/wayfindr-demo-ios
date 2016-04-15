//
//  DemoVenueInterface.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/01/2016.
//  Copyright © 2016 Wayfindr.org Limited. All rights reserved.
//

import Foundation


/**
 *  Interface for interacting with Demo.
 */
struct DemoVenueInterface: VenueInterface {
    
    
    // MARK: - Private Demo Information
    
    /**
    *  Temporary information used in the Demo of Wayfindr.
    */
    private struct DemoFileInformation {
        static let ConfigFile   = "beaconsconfig"
        static let VenueName    = "Full scale trial"
        static let GraphData    = "DemoGraphData"
        static let VenueData  = "DemoVenueData"
        static let VenueMap   = "DemoMap"
    }
    
    
    // MARK: - GET
    
    func getBeaconInterface(completionHandler completionHandler: ((Bool, BeaconInterface?, BeaconInterfaceError?) -> Void)) {
        let interface: BeaconInterface
        
        if let configFilePath = NSBundle.mainBundle().pathForResource(DemoFileInformation.ConfigFile, ofType: "plist"),
            configDictionary = NSDictionary(contentsOfFile: configFilePath) as? [String : AnyObject],
            apiKey = configDictionary["apikey"] as? String {
                interface = DemoBeaconInterface(apiKey: apiKey)
        } else {
            completionHandler(false, nil, BeaconInterfaceError.FailedInitialization(localizedDescription: WAYStrings.ErrorMessages.UnknownError))
            return
        }
        
        completionHandler(true, interface, nil)
    }
    
    
    func getVenue(completionHandler completionHandler: ((Bool, WAYVenue?, WAYError?) -> Void)) {
        let venue: WAYVenue
        
        let venueFileName = DemoFileInformation.VenueData
        let venueFileType = "json"
        
        let graphFileName = DemoFileInformation.GraphData
        let graphFileType = "graphml"
        
        if let venueFilePath = NSBundle.mainBundle().pathForResource(venueFileName, ofType: venueFileType),
            graphFilePath = NSBundle.mainBundle().pathForResource(graphFileName, ofType: graphFileType) {
                
                do {
                    venue = try WAYVenue(venueFilePath: venueFilePath, graphFilePath: graphFilePath)
                } catch let error as WAYError {
                    completionHandler(false, nil, error)
                    return
                } catch let error as NSError {
                    completionHandler(false, nil, WAYError.Failed(localizedDescription: error.localizedDescription))
                    return
                }
        } else {
            completionHandler(false, nil, WAYError.Failed(localizedDescription: WAYStrings.ErrorMessages.UnableFindFiles))
            return
        }
        
        completionHandler(true, venue, nil)
    }
    
    func getVenueMap(completionHandler completionHandler: ((Bool, NSURL?, VenueInterfaceAPIError?) -> Void)) {
        let mapURL = NSBundle.mainBundle().URLForResource(DemoFileInformation.VenueMap, withExtension: "pdf")
        
        if let myMapURL = mapURL {
            completionHandler(true, myMapURL, nil)
        } else {
            completionHandler(false, nil, VenueInterfaceAPIError.UnableToFindResource)
        }
    }
    
}
