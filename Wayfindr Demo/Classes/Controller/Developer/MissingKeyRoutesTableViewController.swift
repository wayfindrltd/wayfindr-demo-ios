//
//  MissingKeyRoutes.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 18/11/2015.
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

import SwiftGraph
import SVProgressHUD


/// Table view for displaying any missing key routes (i.e. those between platforms and exits).
final class MissingKeyRoutesTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    /// Reuse identifier for the table cells.
    fileprivate let reuseIdentifier = "RouteCell"
 
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    
    /// Whether the controller is still computing missing routes.
    fileprivate var parsingData = true
    
    /// Array of all the currently missing routes (or a congratulations message if there are none).
    fileprivate var missingRoutes = [String]()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    /**
    Initializes a `MissingKeyRoutesTableViewController`.
    
    - parameter venue: Model representation of entire venue.
    */
    init(venue: WAYVenue) {
        self.venue = venue
        
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.estimatedRowHeight = WAYConstants.WAYSizes.EstimatedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        title = WAYStrings.MissingKeyRoutes.MissingRoutes
        
        SVProgressHUD.show()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: { [weak self] in
            self?.determineMissingRoutes()
            self?.parsingData = false
            
            DispatchQueue.main.async(execute: {
                SVProgressHUD.dismiss()
                self?.tableView.reloadData()
            })
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - Setup
    
    /**
     Calculates all the missing key routes (those between platforms and exits) and adds them to the  `missingRoutes` array.
     */
    fileprivate func determineMissingRoutes() {
        let venueGraph = venue.destinationGraph
        
        // Routes starting at a platform
        for startPlatform in venue.platforms {
            let startNode = startPlatform.exitNode
            
            for platform in venue.platforms {
                if startPlatform.name == platform.name { continue }
                
                let destinationNode = platform.entranceNode
                
                if !venueGraph.canRoute(startNode, toNode: destinationNode) {
                    let newMissingRoute = "Platform \(startPlatform.name) to Platform \(platform.name)"
                    missingRoutes.append(newMissingRoute)
                }
            } // Next platform
            
            for exit in venue.exits {
                let destinationNode = exit.entranceNode
                
                if !venueGraph.canRoute(startNode, toNode: destinationNode) {
                    let newMissingRoute = "Platform \(startPlatform.name) to Exit \(exit.name)"
                    missingRoutes.append(newMissingRoute)
                }
            } // Next exit
            
        } // Next startPlatform
        
        // Routes starting at an exit
        for startExit in venue.exits {
            let startNode = startExit.exitNode
            
            for platform in venue.platforms {
                let destinationNode = platform.entranceNode
                
                if !venueGraph.canRoute(startNode, toNode: destinationNode) {
                    let newMissingRoute = "Entrance \(startExit.name) to Platform \(platform.name)"
                    missingRoutes.append(newMissingRoute)
                }
            } // Next platform
            
            for exit in venue.exits {
                if startExit.name == exit.name { continue }
                
                let destinationNode = exit.entranceNode
                
                if !venueGraph.canRoute(startNode, toNode: destinationNode) {
                    let newMissingRoute = "Entrance \(startExit.name) to Exit \(exit.name)"
                    missingRoutes.append(newMissingRoute)
                }
            } // Next exit
            
        } // Next startExit
        
        if missingRoutes.isEmpty {
            missingRoutes.append(WAYStrings.MissingKeyRoutes.Congratulations)
        }
    }
    
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return parsingData ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missingRoutes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = missingRoutes[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
