//
//  WAYStrings.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
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


/**
 *  Localized strings used within the app.
 */
struct WAYStrings {
    
    
    // MARK: - General
    
    struct CommonStrings {
        static let Back         = NSLocalizedString("Back", comment: "")
        static let Battery      = NSLocalizedString("Battery", comment: "")
        static let Beacon       = NSLocalizedString("Beacon", comment: "")
        static let Cancel       = NSLocalizedString("Cancel", comment: "")
        static let Change       = NSLocalizedString("Change", comment: "")
        static let DateWord     = NSLocalizedString("Date", comment: "")
        static let Developer    = NSLocalizedString("Developer", comment: "")
        static let Done         = NSLocalizedString("Done", comment: "")
        static let Error        = NSLocalizedString("Error", comment: "")
        static let Maintainer   = NSLocalizedString("Maintainer", comment: "")
        static let Major        = NSLocalizedString("Major", comment: "")
        static let Minor        = NSLocalizedString("Minor", comment: "")
        static let PrivateWord  = NSLocalizedString("Private", comment: "")
        static let PublicWord   = NSLocalizedString("Public", comment: "")
        static let Save         = NSLocalizedString("Save", comment: "")
        static let YesWord      = NSLocalizedString("Yes", comment: "")
        static let Unknown      = NSLocalizedString("Unknown", comment: "")

        static let BatteryLevels    = NSLocalizedString("Battery Levels", comment: "")
        static let DataExport       = NSLocalizedString("Data Export", comment: "")
        static let DeveloperOptions = NSLocalizedString("Developer Options", comment: "")
    }
    
    struct ErrorTitles {
        static let DisconnectedGraph    = NSLocalizedString("Disconnected Graph", comment: "")
        static let GraphLoading         = NSLocalizedString("Error Loading Graph", comment: "")
        static let NoDirections         = NSLocalizedString("Missing Instructions", comment: "")
        static let NoInternet           = NSLocalizedString("Internet", comment: "")
        static let VenueLoading         = NSLocalizedString("Error Loading Venue", comment: "")
    }
    
    struct ErrorMessages {
        static let AudioEngine          = NSLocalizedString("There was a problem creating the audio engine. Please restart the app.", comment: "")
        static let DisconnectedGraph    = NSLocalizedString("Warning! You have loaded a disconnected GRAPHML file. This means that we may not be able to route you from any beacon to any other beacon.", comment: "")
        static let FailedParsing        = NSLocalizedString("Failed parsing data.", comment: "")
        static let GraphLoading         = NSLocalizedString("There was an error loading the venue GRAPHML data.", comment: "")
        static let NoDirections         = NSLocalizedString("Oops! We appear to be missing some instructions!", comment: "")
        static let NoInternet           = NSLocalizedString("Please check your Internet connection and restart the app. Wayfindr needs a working Internet connection during first launch.", comment: "")
        static let VenueLoading         = NSLocalizedString("There was an error loading the venue JSON data.", comment: "")
        static let UnableBeacons        = NSLocalizedString("Unable to fetch beacons.", comment: "")
        static let UnableFindFiles      = NSLocalizedString("Unable to find data files.", comment: "")
        static let UnableMonitor        = NSLocalizedString("This device cannot monitor beacons in its current configuration. Please check to make sure you have Bluetooth turned on.", comment: "")
        static let UnknownError         = NSLocalizedString("Unknown Error", comment: "")
        static let UnknownVenue         = NSLocalizedString("Unknown Venue", comment: "")
    }
    
    struct ModeSelection {
        static let User         = NSLocalizedString("User", comment: "")
    }
    
    
    // MARK: - Developer
    
    struct DeveloperActionSelection {
        static let GraphValidation  = NSLocalizedString("Graph Validation", comment: "")
        static let KeyRoutePaths    = NSLocalizedString("Key Route Paths", comment: "")
        static let MissingKeyRoutes = NSLocalizedString("Missing Key Routes", comment: "")
    }
    
    
    // MARK: - Maintainer
    
    struct BatteryLevel {
        static let Updated          = NSLocalizedString("Updated", comment: "")
    }
    
    struct BeaconsInRange {
        static let Accuracy         = NSLocalizedString("Accuracy", comment: "")
        static let AdvertisingRate  = NSLocalizedString("Advertising Rate", comment: "")
        static let BeaconsInRange   = NSLocalizedString("Beacons in Range", comment: "")
        static let NoBeacons        = NSLocalizedString("No Beacons in Range", comment: "")
        static let NoSpecificBeacon = NSLocalizedString("Beacon %@ not in range.", comment: "")
        static let RSSI             = NSLocalizedString("RSSI", comment: "")
        static let TBD              = NSLocalizedString("To Be Determined", comment: "")
        static let TxPower          = NSLocalizedString("Tx Power", comment: "")
        static let UUID             = NSLocalizedString("UUID", comment: "")
    }
    
    struct BeaconsInRangeMode {
        static let AnyBeacon        = NSLocalizedString("Any Beacon", comment: "")
        static let Instructions     = NSLocalizedString("Please choose whether you would like to search for a specific beacon or any nearby beacons.", comment: "")
        static let ModeWord         = NSLocalizedString("Mode", comment: "")
        static let SelectMode       = NSLocalizedString("Select Mode", comment: "")
        static let SpecificBeacon   = NSLocalizedString("Specific Beacon", comment: "")
    }
    
    struct BeaconsInRangeSearch {
        static let BeaconSearch         = NSLocalizedString("Beacon Search", comment: "")
        static let SearchPlaceholder    = NSLocalizedString("Search beacons", comment: "")
    }
    
    struct DeveloperOptions {
        static let ShowForceNextButton  = NSLocalizedString("Show Force Next Beacon Button", comment: "")
        static let ShowRepeatButton     = NSLocalizedString("Show Repeat Button with Voiceover", comment: "")
    }
    
    struct KeyRoutePaths {
        static let KeyPaths         = NSLocalizedString("Key Paths", comment: "")
    }
    
    struct KeyRoutePathsDetail {
        static let Instructions     = NSLocalizedString("Instructions", comment: "")
        static let Paths            = NSLocalizedString("Paths", comment: "")
        static let RouteDetails     = NSLocalizedString("Route Details", comment: "")
    }
    
    struct MaintainerActionSelection {
        static let CheckBeacons     = NSLocalizedString("Check Beacons in Range", comment: "")
    }
    
    struct MissingKeyRoutes {
        static let MissingRoutes    = NSLocalizedString("Missing Routes", comment: "")
        static let Congratulations  = NSLocalizedString("Congratulations! You have no missing key routes.", comment: "")
    }


    // MARK: - User
    
    struct ActiveRoute {
        static let ActiveRoute      = NSLocalizedString("Active Route", comment: "")
        static let Calculating      = NSLocalizedString("Calculating Route", comment: "")
        static let Repeat           = NSLocalizedString("Repeat", comment: "")
        static let UnableToRoute    = NSLocalizedString("Unable to Find Route", comment: "")
        static let FirstInstructionPrefix = NSLocalizedString("For your destination", comment: "")
        static let FirstInstructionPrefixFormat = NSLocalizedString("%@:\n", comment: "")
    }
    
    struct DirectionsPreview {
        static let BeginRoute       = NSLocalizedString("Begin Route", comment: "")
        static let SkipWord         = NSLocalizedString("Skip", comment: "")
        static let Title            = NSLocalizedString("Preview", comment: "")
    }
    
    struct RouteCalculation {
        static let CalculatingRoute     = NSLocalizedString("Calculating Route...", comment: "")
        static let InstructionsQuestion = NSLocalizedString("Do you want to preview all instructions before starting your journey?", comment: "")
        static let Routing              = NSLocalizedString("Routing", comment: "")
        static let SkipPreview          = NSLocalizedString("Skip Preview", comment: "")
        static let TroubleRouting       = NSLocalizedString("We are having trouble finding your current location. Please begin walking while we continue to locate you within the venue.", comment: "")
        static let Yes                  = NSLocalizedString("Yes", comment: "")
    }
    
    struct UserActionSelection {
        static let SelectDestination 		= NSLocalizedString("Select a destination point below", comment: "")
        static let TrainPlatforms           = NSLocalizedString("Train platforms", comment: "")
        static let StationExits             = NSLocalizedString("Station exits", comment: "")
        static let StationFacilities        = NSLocalizedString("Station facilities", comment: "")
    }

    struct DestinationSearch {
        static let TrainPlatformSearch          = NSLocalizedString("Train Platform Search", comment: "")
        static let SearchPlatformPlaceholder    = NSLocalizedString("Search platforms", comment: "")
    }

    struct ExitSearch {
        static let ExitSearch           = NSLocalizedString("Station Exit Search", comment: "")
        static let SearchPlaceholder    = NSLocalizedString("Search exits", comment: "")
    }

    struct StationFacilitySearch {
        static let StationFacilitySearch = NSLocalizedString("Station Facility Search", comment: "")
        static let SearchPlaceholder     = NSLocalizedString("Search facilities", comment: "")
    }
    
    struct WarningView {
        static let Dismiss  = NSLocalizedString("Dismiss", comment: "")
    }
    
}
