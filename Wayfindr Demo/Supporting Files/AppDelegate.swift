//
//  AppDelegate.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 10/11/2015.
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

import UIKit
import CoreLocation

import AEXML
import SwiftyJSON
import SVProgressHUD


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // MARK: - Properties
    
    var window: UIWindow?
    
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        WAYDeveloperSettings.registerSettings()
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupTheme()
        
        loadMainView()
        
        return true
    }
    
    
    // MARK: - Setup
    
    fileprivate func setupTheme() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = WAYConstants.WAYColors.NavigationText
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)], for: UIControlState())
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0)
        
        UITabBar.appearance().tintColor = WAYConstants.WAYColors.WayfindrMainColor
        
        UISwitch.appearance().onTintColor = WAYConstants.WAYColors.WayfindrMainColor
        
        BaseView.appearance().backgroundColor = WAYConstants.WAYColors.Background
        
        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    fileprivate func loadMainView() {
        let rootViewController = ModeSelectionTabViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
}
