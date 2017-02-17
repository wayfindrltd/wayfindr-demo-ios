//
//  WAYDeveloperSettings.swift
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
struct WAYDeveloperSettings {
    
    
    // MARK: - Types
    
    /**
    *  `NSUserDefaults` keys for developer settings.
    */
    fileprivate struct WAYDeveloperSettingsKeys {
        static let ShowForceNextButton  = "Developer_ShowForceNextButton"
        static let ShowRepeatButton     = "Developer_ShowRepeatButton"
    }
    
    
    // MARK: - Properties
    
    /// Single shared instance for `WAYDeveloperSettings`.
    static var sharedInstance = WAYDeveloperSettings()
    
    /// `NSNotification` name for when the settings change.
    static let DeveloperSettingsChangedNotification = "DeveloperSettingsChanged"
    
    var showForceNextButton: Bool {
        didSet {
            saveSettings()
        }
    }
    
    /// Whether or not to show the repeat button when VoiceOver is turned on.
    var showRepeatButton: Bool {
        didSet {
            saveSettings()
        }
    }
    
    
    // MARK: - Initializers
    
    init() {
        let defaults = UserDefaults.standard
        
        showForceNextButton = defaults.bool(forKey: WAYDeveloperSettingsKeys.ShowForceNextButton)
        showRepeatButton = defaults.bool(forKey: WAYDeveloperSettingsKeys.ShowRepeatButton)
    }
    
    
    // MARK: - Save Changes
    
    /**
    Save the settings into `NSUserDefaults`.
    */
    fileprivate func saveSettings() {
        let defaults = UserDefaults.standard
        
        defaults.set(showForceNextButton, forKey: WAYDeveloperSettingsKeys.ShowForceNextButton)
        defaults.set(showRepeatButton, forKey: WAYDeveloperSettingsKeys.ShowRepeatButton)
        defaults.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: WAYDeveloperSettings.DeveloperSettingsChangedNotification), object: nil)
    }
    
    
    // MARK: - Convenience

    /**
    Register the default `WAYDeveloperSettings` settings.
    */
    static func registerSettings() {
        let defaults = UserDefaults.standard
        
        defaults.register(defaults: [WAYDeveloperSettingsKeys.ShowForceNextButton : false])
        defaults.register(defaults: [WAYDeveloperSettingsKeys.ShowRepeatButton : true])
    }

}
