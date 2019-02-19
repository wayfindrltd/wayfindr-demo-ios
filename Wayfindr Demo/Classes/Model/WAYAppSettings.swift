//
//  WAYAppSettings.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 30/11/2015.
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
 *  Developer settings.
 */
struct WAYAppSettings {
    
    
    // MARK: - Types
    
    /**
     *  `NSUserDefaults` keys for developer settings.
     */
    fileprivate struct WAYAppSettingsKeys {
        static let CurrentVenueSelected  = "App_VenueSelected"
    }
    
    struct WAYAppConfig {
        var ConfigFileList:[String]
        var VenueNameList :[String]
        var GraphDataList :[String]
        var VenueDataList :[String]
        var VenueMapList  :[String]
    }
    
    // MARK: - Properties
    
    /// Single shared instance for `WAYAppSettings`.
    static var sharedInstance = WAYAppSettings()
    
    

    
    /// `NSNotification` name for when the settings change.
    static let AppSettingsChangedNotification = "AppSettingsChanged"
    
    var wayAppConfig:WAYAppConfig
    
    var currentVenueSelected: Int {
        didSet {
            saveSettings()
        }
    }
    
    /// Shared multi site indicator
    var isMultiSite:Bool = false
    
    // MARK: - Initializers
    
    init() {
        let defaults = UserDefaults.standard
        
        isMultiSite = false
        
        currentVenueSelected = defaults.integer(forKey: WAYAppSettingsKeys.CurrentVenueSelected)
        wayAppConfig = WAYAppConfig(ConfigFileList: [], VenueNameList: [], GraphDataList: [], VenueDataList: [], VenueMapList: [])
        
    }
    
    
    // MARK: - Save Changes
    
    /**
     Save the settings into `NSUserDefaults`.
     */
    fileprivate func saveSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(currentVenueSelected, forKey: WAYAppSettingsKeys.CurrentVenueSelected)
        defaults.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: WAYAppSettings.AppSettingsChangedNotification), object: nil)
    }
    
    
    // MARK: - Convenience
    
    /**
     Register the default `WAYAppSettings` settings.
     */
    static func registerSettings() {
        let defaults = UserDefaults.standard
        
        defaults.register(defaults: [WAYAppSettingsKeys.CurrentVenueSelected : false])

    }
    
    static func loadWAYAppConfig (){
        
        if let multivenueconfigFilePath = Bundle.main.path(forResource: "venue", ofType: "plist")
        {
            let appConfigDictionary = NSDictionary(contentsOfFile: multivenueconfigFilePath) as? [String : AnyObject]
            let venuenames = appConfigDictionary?["venuenames"] as? String
            WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList = (venuenames?.components(separatedBy: ","))!
            
            let venuegraphs = appConfigDictionary?["venuegraphs"] as? String
            WAYAppSettings.sharedInstance.wayAppConfig.GraphDataList = (venuegraphs?.components(separatedBy: ","))!
            
            let venuemaps = appConfigDictionary?["venuemaps"] as? String
            WAYAppSettings.sharedInstance.wayAppConfig.VenueMapList = (venuemaps?.components(separatedBy: ","))!
            
            let venueconfigs = appConfigDictionary?["venueconfigs"] as? String
            WAYAppSettings.sharedInstance.wayAppConfig.ConfigFileList = (venueconfigs?.components(separatedBy: ","))!
            
            self.sharedInstance.isMultiSite = true
        }

    }
}

