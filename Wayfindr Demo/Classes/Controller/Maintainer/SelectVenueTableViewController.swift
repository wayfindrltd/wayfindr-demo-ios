//
//  SelectVenueTableViewController.swift
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
final class SelectVenueTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "SelectVenue"
    
    /// Header for the `UITableView`.
    fileprivate let headerView = SelectVenueHeaderView()
    
    // MARK: - Initializers
    
    //init() {
    //    super.init(style: .grouped)
    //}
    
    //override init(style: UITableViewStyle) {
    //    super.init(style: .grouped)
    //}
    
    //required init?(coder aDecoder: NSCoder) {
    //   super.init(coder: aDecoder)
    //}
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        //tableView.heightAnchor.constraint(equalToConstant: WAYConstants.WAYSizes.EstimatedCellHeight).isActive = true
        
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = WAYConstants.WAYSizes.EstimatedCellHeight
        
        title = WAYStrings.CommonStrings.SelectVenue
        
        let backButton = UIBarButtonItem(title: WAYStrings.CommonStrings.Back, style: .plain, target: nil, action: nil)
        backButton.accessibilityIdentifier = WAYAccessibilityIdentifier.MaintainerActionSelection.BackBarButtonItem
        navigationItem.backBarButtonItem = backButton
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let accessibilityID: String
        
        cell.textLabel?.text = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList[indexPath.row]
        accessibilityID = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        if  indexPath.row == WAYAppSettings.sharedInstance.currentVenueSelected {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        cell.accessibilityIdentifier = accessibilityID
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ipath = NSIndexPath(row: WAYAppSettings.sharedInstance.currentVenueSelected, section: 0)
        let oldselection = tableView.cellForRow(at:ipath as IndexPath)
        
        oldselection?.accessoryType = .none
        
        WAYAppSettings.sharedInstance.currentVenueSelected = indexPath.row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        headerView.selectedVenueLabel.text = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList[indexPath.row]
    }
    
    /* override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     cell.textLabel?.text = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList[indexPath.row]
     cell.textLabel?.numberOfLines = 0
     cell.textLabel?.lineBreakMode = .byWordWrapping
     
     cell.accessoryType = .disclosureIndicator
     
     cell.accessibilityIdentifier = WAYAppSettings.sharedInstance.wayAppConfig.VenueNameList[indexPath.row]
     }
     */
}



