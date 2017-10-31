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
import UserNotifications
import AEXML
import SwiftyJSON
import SVProgressHUD


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ITBeepconsManagerDelegate {

    
    // MARK: - Properties
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var beepconsManager: ITBeepconsManager?
    
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        WAYDeveloperSettings.registerSettings()
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupTheme()
        locationManager.delegate = self
        
        if beepconsManager == nil {
            beepconsManager = ITBeepconsManager(delegate: self)
        }
        
        // Request permission to send notifications
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        } else {
            // Fallback on earlier versions
        }
        
        
        //loadMainView()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Notificacion_" + "\\^([1-9][0-9]{0,2}|1000)$"), object: self)
    }
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		NotificationCenter.default.post(name: Notification.Name(rawValue: "Notificacion_" + "\\^([1-9][0-9]{0,2}|1000)$"), object: self)
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

// MARK: CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "Wayfindr"
            content.body = "You are entering a region with beacons"
            content.sound = .default()
            let request = UNNotificationRequest(identifier: "Wayfindr", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "Wayfindr"
            content.body = "You are entering a region with beacons"
            content.sound = .default()
            let request = UNNotificationRequest(identifier: "Wayfindr", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "Wayfindr"
            content.body = "Are you forgetting something?"
            content.sound = .default()
            let request = UNNotificationRequest(identifier: "Wayfindr", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}

