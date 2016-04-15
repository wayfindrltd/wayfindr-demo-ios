//
//  DeveloperOptionsTableViewController.swift
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

import UIKit


/// Table view for viewing and adjusting developer/tester settings.
final class DeveloperOptionsTableViewController: UITableViewController {
    
    
    // MARK: - Types
    
    /// List of options to show the user.
    private enum DeveloperOptions: Int {
        case ShowForceNext
        case ShowRepeatInAccessibility
        
        static let allValues = [ShowForceNext, ShowRepeatInAccessibility]
    }
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    private let reuseIdentifier = "OptionCell"
    
    
    
    // MARK: - Initializers
    
    init() {
        super.init(style: .Grouped)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = WAYStrings.CommonStrings.DeveloperOptions
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperOptions.allValues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let switchCell = cell as? SwitchTableViewCell {
            if let selectedOption = DeveloperOptions(rawValue: indexPath.row) {
                switch selectedOption {
                case .ShowForceNext:
                    switchCell.textLabel?.text = WAYStrings.DeveloperOptions.ShowForceNextButton
                    
                    switchCell.switchControl.on = WAYDeveloperSettings.sharedInstance.showForceNextButton
                case .ShowRepeatInAccessibility:
                    switchCell.textLabel?.text = WAYStrings.DeveloperOptions.ShowRepeatButton
                    
                    switchCell.switchControl.on = WAYDeveloperSettings.sharedInstance.showRepeatButton
                }
            }
            
            switchCell.textLabel?.numberOfLines = 0
            switchCell.textLabel?.lineBreakMode = .ByWordWrapping
            
            switchCell.switchControl.addTarget(self, action: #selector(DeveloperOptionsTableViewController.switchValueChanged(_:)), forControlEvents: .ValueChanged)
            switchCell.switchControl.tag = indexPath.row
        }
        
        return cell
    }
    
    
    // MARK: - Control Actions
    
    /**
    Action when the user flips a switch.
    
    - parameter sender: `UISwitch` that changed value.
    */
    func switchValueChanged(sender: UISwitch) {
        if let selectedOption = DeveloperOptions(rawValue: sender.tag) {
            switch selectedOption {
            case .ShowForceNext:
                WAYDeveloperSettings.sharedInstance.showForceNextButton = sender.on
            case .ShowRepeatInAccessibility:
                WAYDeveloperSettings.sharedInstance.showRepeatButton = sender.on
            }
        }
    }
    
}
