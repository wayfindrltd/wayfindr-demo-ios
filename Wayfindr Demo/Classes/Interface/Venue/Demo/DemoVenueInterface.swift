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
    fileprivate struct DemoFileInformation {
        static let ConfigFile   = "beaconsconfig"
        static let VenueName    = "Full scale trial"
        static let GraphData    = "DemoGraphData"
        static let VenueData  = "DemoVenueData"
        static let VenueMap   = "DemoMap"
    }
    
    
    // MARK: - GET
    
    func getBeaconInterface(completionHandler: ((Bool, BeaconInterface?, BeaconInterfaceError?) -> Void)) {
        let interface: BeaconInterface
        
        if let configFilePath = Bundle.main.path(forResource: DemoFileInformation.ConfigFile, ofType: "plist"),
            let configDictionary = NSDictionary(contentsOfFile: configFilePath) as? [String : AnyObject],
            let apiKey = configDictionary["apikey"] as? String {
                interface = DemoBeaconInterface(apiKey: apiKey)
        } else {
            completionHandler(false, nil, BeaconInterfaceError.failedInitialization(localizedDescription: WAYStrings.ErrorMessages.UnknownError))
            return
        }
        
        completionHandler(true, interface, nil)
    }
    
    
    func getVenue(completionHandler: ((Bool, WAYVenue?, WAYError?) -> Void)) {
        let venue: WAYVenue
        
        let venueFileName = DemoFileInformation.VenueData
        let venueFileType = "json"
        
        let graphFileName = DemoFileInformation.GraphData
        let graphFileType = "graphml"
        
        if let venueFilePath = Bundle.main.path(forResource: venueFileName, ofType: venueFileType),
            let graphFilePath = Bundle.main.path(forResource: graphFileName, ofType: graphFileType) {
                
                do {
                    venue = try WAYVenue(venueFilePath: venueFilePath, graphFilePath: graphFilePath)
                } catch let error as WAYError {
                    completionHandler(false, nil, error)
                    return
                } catch let error as NSError {
                    completionHandler(false, nil, WAYError.failed(localizedDescription: error.localizedDescription))
                    return
                }
        } else {
            completionHandler(false, nil, WAYError.failed(localizedDescription: WAYStrings.ErrorMessages.UnableFindFiles))
            return
        }
        
        completionHandler(true, venue, nil)
    }
    
    func getVenueMap(completionHandler: ((Bool, URL?, VenueInterfaceAPIError?) -> Void)) {
        let mapURL = Bundle.main.url(forResource: DemoFileInformation.VenueMap, withExtension: "pdf")
        
        if let myMapURL = mapURL {
            completionHandler(true, myMapURL, nil)
        } else {
            completionHandler(false, nil, VenueInterfaceAPIError.unableToFindResource)
        }
    }
    
}
