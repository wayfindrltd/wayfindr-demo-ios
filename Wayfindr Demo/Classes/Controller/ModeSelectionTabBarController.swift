//
//  ModeSelectionTabViewController.swift
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

import UIKit


/// Tab bar to select between modes of the app.
final class ModeSelectionTabViewController: UITabBarController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        
        setupTabs()
    }
    
    
    // MARK: - Setup
    
    fileprivate func setupTabs() {
        // Setup Modes

        let userMode = setupUserMode()
        let maintainerMode = setupMaintainerMode()
        let developerMode = setupDeveloperMode()
        
        // Add Controllers to TabBar
        
        setViewControllers([userMode, maintainerMode, developerMode], animated: false)
    }
    
    fileprivate func setupUserMode() -> UIViewController {
        let userController = UserActionTableViewController()
        
        let userNavigationController = UINavigationController(rootViewController: userController)
        userNavigationController.navigationBar.barTintColor = WAYConstants.WAYColors.WayfindrMainColor
        userNavigationController.navigationBar.tintColor = WAYConstants.WAYColors.NavigationText
        userNavigationController.navigationBar.isTranslucent = false
        
        let userTabBarItem = UITabBarItem(title: WAYStrings.ModeSelection.User, image: UIImage(assetIdentifier: .User), tag: 1)
        userTabBarItem.accessibilityIdentifier = WAYAccessibilityIdentifier.ModeSelection.UserTabBarItem
        userNavigationController.tabBarItem = userTabBarItem
        
        return userNavigationController
    }
    
    fileprivate func setupMaintainerMode() -> UIViewController {
        let maintainerController = MaintainerActionSelectionTableView()
        
        let maintainerNavigationController = UINavigationController(rootViewController: maintainerController)
        maintainerNavigationController.navigationBar.barTintColor = WAYConstants.WAYColors.Maintainer
        maintainerNavigationController.navigationBar.isTranslucent = false
        
        let maintainerTabBarItem = UITabBarItem(title: WAYStrings.CommonStrings.Maintainer, image: UIImage(assetIdentifier: .Maintenance), tag: 1)
        maintainerTabBarItem.accessibilityIdentifier = WAYAccessibilityIdentifier.ModeSelection.MaintainerTabBarItem
        maintainerNavigationController.tabBarItem = maintainerTabBarItem
        
        return maintainerNavigationController
    }

    
    fileprivate func setupDeveloperMode() -> UIViewController {
        let viewController = DeveloperActionSelectionTableView()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = WAYConstants.WAYColors.Developer
        navigationController.navigationBar.isTranslucent = false
        
        let tabBarItem = UITabBarItem(title: WAYStrings.CommonStrings.Developer, image: UIImage(assetIdentifier: .Developer), tag: 1)
        tabBarItem.accessibilityIdentifier = WAYAccessibilityIdentifier.ModeSelection.DeveloperTabBarItem
        navigationController.tabBarItem = tabBarItem
        
        return navigationController
    }
    
}
