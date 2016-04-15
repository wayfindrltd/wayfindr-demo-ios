//
//  BaseSearchTableViewController.swift
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


/// Base class for a table view that includes search. Cell content is just a title from an array of strings called `items`.
class BaseSearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    private let reuseIdentifier = "SearchCell"
    
    /// Array of strings to present the user. Each string corresponds to a cell.
    var items = [String]()
    
    /// Search controller.
    var searchController: UISearchController?
    
    /// Results table displayed when searching.
    let resultsTableController = BaseSearchResultsTableViewController()
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableController.tableView.delegate = self
        
        setupSearchController()

        definesPresentationContext = true
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let backButton = UIBarButtonItem(title: WAYStrings.CommonStrings.Back, style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar

        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        self.searchController = searchController
    }
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        resultsTableController.searchArray.removeAll(keepCapacity: false)
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        let array = items.filter { $0.uppercaseString.rangeOfString(searchText.uppercaseString) != nil }
        resultsTableController.searchArray = array
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func willPresentSearchController(searchController: UISearchController) {
        navigationController?.navigationBar.translucent = true
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        navigationController?.navigationBar.translucent = false
    }

    
    // MARK: - UITableViewDatasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    // MARK: - Convenience
    
    /**
    Returns the appropriate string from `items` for `indexPath` based on whether the user is currently searching.
    
    - parameter tableView: `UITableView` currently presented to the user.
    - parameter indexPath: The `NSIndexPath` for the desired string from `items`.
    
    - returns: The desired string.
    */
    func itemForIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> String {
        if tableView == self.tableView {
            return items[indexPath.row]
        } else {
            return resultsTableController.searchArray[indexPath.row]
        }
    }
    
}
