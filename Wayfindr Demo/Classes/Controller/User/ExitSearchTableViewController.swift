//
//  ExitSearchTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/11/2015.
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


/// Table view for selecting the desired exit. Exits are searchable.
final class ExitSearchTableViewController: BaseSearchTableViewController {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate let interface: BeaconInterface
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    /// Engine for speech playback.
    fileprivate let speechEngine: AudioEngine
    
    /// List of destination exits to choose from.
    fileprivate var destinations = [String]()
    
    
    // MARK: - Intiailizers / Deinitializers
    
    init(interface: BeaconInterface, venue: WAYVenue, speechEngine: AudioEngine) {
        self.interface = interface
        self.venue = venue
        self.speechEngine = speechEngine
        
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDestinations()
        
        items = destinations
        
        searchController?.searchBar.placeholder = WAYStrings.ExitSearch.SearchPlaceholder
        
        title = WAYStrings.ExitSearch.ExitSearch
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDestination = itemForIndexPath(tableView, indexPath: indexPath)
        
        if let selectedExit = exitForDestination(selectedDestination) {
            let directionsPreview = RouteCalculationViewController(interface: interface, venue: venue, destination: selectedExit.entranceNode, speechEngine: speechEngine)
            
            navigationController?.pushViewController(directionsPreview, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Convenience Methods
    
    /**
    Sets up the `destinations` array of possible destination exits.
    */
    fileprivate func setupDestinations() {
        var destinationSet = Set<String>()
        
        for exit in venue.exits {
            destinationSet.insert(exit.mode)
        }
        
        destinations = Array(destinationSet).sorted()
    }
    
    /**
     Fetches the exit to use to get to the desired `destination`.
     
     - parameter destination: Desired destination exit.
     
     - returns: The `WAYExit` representation of the exit to use to get to `destination`, if such an exit exists. Otherwise returns `nil`.
     */
    fileprivate func exitForDestination(_ destination: String) -> WAYExit? {
        guard let exitIndex = venue.exits.index(where: {$0.mode == destination}) else {
            return nil
        }
        
        return venue.exits[exitIndex]
    }
    
}
