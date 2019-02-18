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
        static var ConfigFile   = "beaconsconfig"
        static var VenueName    = "Full scale trial"
        static var GraphData    = "DemoGraphData"
        static var VenueData  = "DemoVenueData"
        static var VenueMap   = "DemoMap"
    }
    
    
    // MARK: - GET
    
    func loadDemoFileInfo ()
    {
        let currentVenue = WAYAppSettings.sharedInstance.currentVenueSelected as Int
        WAYAppSettings.loadWAYAppConfig()
        
        if (currentVenue >= 0) && (WAYAppSettings.sharedInstance.isMultiSite)
        {
            DemoFileInformation.ConfigFile = WAYAppSettings.sharedInstance.wayAppConfig.ConfigFileList[ currentVenue ]
            DemoFileInformation.GraphData = WAYAppSettings.sharedInstance.wayAppConfig.GraphDataList [ currentVenue ]
            DemoFileInformation.VenueData = WAYAppSettings.sharedInstance.wayAppConfig.VenueMapList [ currentVenue ]
            DemoFileInformation.VenueName = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList [ currentVenue ]
        }
        
    }
    
    func getBeaconInterface(completionHandler: ((Bool, BeaconInterface?, BeaconInterfaceError?) -> Void)) {
        let interface: BeaconInterface
        //if let multivenueconfigFilePath = Bundle.main.path(forResource: "venue", ofType: "plist")
        //{
        loadDemoFileInfo()
        
        /*let appConfigDictionary = NSDictionary(contentsOfFile: multivenueconfigFilePath) as? [String : AnyObject]
         let venuenames = appConfigDictionary?["venuenames"] as? String
         let venuenameslist = venuenames?.components(separatedBy: ",")
         
         let venuegraphs = appConfigDictionary?["venuegraphs"] as? String
         let venuegraphslist = venuegraphs?.components(separatedBy: ",")
         
         let venuemaps = appConfigDictionary?["venuemaps"] as? String
         let venuemapslist = venuemaps?.components(separatedBy: ",")
         
         let venueconfigs = appConfigDictionary?["venueconfigs"] as? String
         let venueconfigslist = venueconfigs?.components(separatedBy: ",")
         */
        
        //}
        
        if let configFilePath = Bundle.main.path(forResource: DemoFileInformation.ConfigFile, ofType: "plist"),
            let configDictionary = NSDictionary(contentsOfFile: configFilePath) as? [String : AnyObject],
            let defaultsdk = configDictionary["defaultsdk"] as? String {
                switch defaultsdk
                {
                case  "Bluecats":
                    let apiKey = configDictionary["bcapikeyrsbc"] as? String
                    interface = BlueCatsIBeaconInterface(apiKey: apiKey!)
                case "iBeacon":
                    let regionID = configDictionary["demoregionid"] as? String
                    let regionName = configDictionary["demoregionname"] as? String
                    interface = IOSIBeaconInterface(regionID: regionID!, regionName: regionName!)
                default:
                    interface = DemoBeaconInterface()
                }
            
        } else {
            completionHandler(false, nil, BeaconInterfaceError.failedInitialization(localizedDescription: WAYStrings.ErrorMessages.UnknownError))
            return
        }
        
        completionHandler(true, interface, nil)
    }
    
    
    func getVenue(completionHandler: ((Bool, WAYVenue?, WAYError?) -> Void)) {
        let venue: WAYVenue
        
        loadDemoFileInfo()
        
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
