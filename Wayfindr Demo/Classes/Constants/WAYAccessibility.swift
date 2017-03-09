//
//  WAYAccessibility.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 13/11/2015.
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
 *  Accessibility Identifiers for app.
 */
struct WAYAccessibilityIdentifier {
    
    
    // General
    
    struct ModeSelection {
        static let MaintainerTabBarItem = "Maintainer_TabBarItem"
        static let UserTabBarItem       = "User_TabBarItem"
        static let DeveloperTabBarItem  = "Developer_TabBarItem"
    }
    
    
    // MARK: - Developer
    
    struct DeveloperActionSelection {
        static let BackBarButtonItem    = "DeveloperHome_BarButtonItem"
        static let DataExportCell       = "DataExport_Cell"
        static let DeveloperOptionsCell = "DeveloperOptions_Cell"
        static let GraphValidationCell  = "GraphValidation_Cell"
        static let KeyRoutePathsCell    = "KeyRoutePaths_Cell"
        static let MissingKeyRoutesCell = "MissingKeyRoutes_Cell"
    }
    
    
    // MARK: - Maintainer
    
    struct BeaconsInRangeSearch {
        static let BeaconSearchBar  = "BeaconSearch_SearchBar"
    }
    
    struct MaintainerActionSelection {
        static let BackBarButtonItem    = "MaintainerHome_BarButtonItem"
        static let BatteryLevelsCell    = "BatteryLevels_Cell"
        static let BeaconsInRangeCell   = "BeaconsInRange_Cell"
    }
    
    
    // MARK: - Shared
    
    struct Banner {
        static let TextLabel    = "BannerText_Label"
        static let BannerView   = "Banner_View"
    }
    
    
    // MARK: - User
    
    struct DestinationSearch {
        static let DestinationSearchBar = "DestinationSearch_SearchBar"
    }
    
    struct UserActionSelection {
        static let SelectDestinationLabel = "SelectDestination_Label"
        static let TrainPlatformsCell     = "TrainPlatforms_Cell"
        static let StationExitsCell       = "StationExits_Cell"
        static let StationFacilitiesCell  = "StationFacilities_Cell"
    }
    
}


/**
 *  Accessibility Labels for the app.
 */
struct WAYAccessibilityLabel {
    
    
    // MARK: - User
    
    struct DirectionsPreview {
        static let PreviewDirections    = NSLocalizedString("Preview Directions", comment: "")
    }
    
}
