//
//  DestinationSearchTableViewController.swift
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


/// Table view for selecting the destination. Destinations are searchable.
final class DestinationSearchTableViewController: BaseSearchTableViewController {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate let interface: BeaconInterface
    /// Model representation of entire venue.
    fileprivate let venue: WAYVenue
    /// Engine for speech playback.
    fileprivate let speechEngine: AudioEngine
    
    /// List of destination venues to choose from.
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
        
        searchController?.searchBar.placeholder = WAYStrings.DestinationSearch.SearchPlaceholder
        searchController?.searchBar.accessibilityIdentifier = WAYAccessibilityIdentifier.DestinationSearch.DestinationSearchBar
        
        title = WAYStrings.DestinationSearch.DestinationSearch
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDestination = itemForIndexPath(tableView, indexPath: indexPath)
        
        if let selectedPlatform = platformForDestination(selectedDestination) {
            let directionsPreview = RouteCalculationViewController(interface: interface, venue: venue, destination: selectedPlatform.entranceNode, speechEngine: speechEngine)
            
            navigationController?.pushViewController(directionsPreview, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Convenience Methods
    
    /**
    Sets up the `destinations` array of possible destination venues.
    */
    fileprivate func setupDestinations() {
        var destinationSet = Set<String>()
        
        let platforms: [WAYPlatform]
        if WAYConstants.WAYSettings.showOnlyPlatformsThatRouteToAllExits {
            var routablePlatforms = [WAYPlatform]()
            
            platformSearch: for platform in venue.platforms {
                
                for exit in venue.exits {
                    if !venue.destinationGraph.canRoute(platform.exitNode, toNode: exit.entranceNode) ||
                       !venue.destinationGraph.canRoute(exit.exitNode, toNode: platform.entranceNode) {
                        continue platformSearch
                    }
                } // Next exit
                
                routablePlatforms.append(platform)
                
            } // Next platform
            
            platforms = routablePlatforms
        } else {
            platforms = venue.platforms
        }
        
        for platform in platforms {
            for destination in platform.destinations {
                destinationSet.insert(destination)
            }
        }
        
        destinations = Array(destinationSet).sorted()
    }
    
    /**
     Fetches the platform to use to get to the desired `destination`.
     
     - parameter destination: Desired destination venue.
     
     - returns: The `WAYPlatform` representation of the platform to use to get to `destination`, if such a platform exists. Otherwise returns `nil`.
     */
    fileprivate func platformForDestination(_ destination: String) -> WAYPlatform? {
        guard let platformIndex = venue.platforms.index(where: {$0.destinations.contains(destination)}) else {
            return nil
        }
        
        return venue.platforms[platformIndex]
    }
    
}
