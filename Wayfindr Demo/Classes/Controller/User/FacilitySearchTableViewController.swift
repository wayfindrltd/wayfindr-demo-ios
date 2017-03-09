//
//  FacilitySearchTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 21/07/2016.
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


/// Table view for selecting the desired facility. Facilities are searchable.
final class FacilitySearchTableViewController: BaseSearchTableViewController {


    // MARK: - Properties

    /// Interface for interacting with beacons.
    private let interface: BeaconInterface
    /// Model representation of entire venue.
    private let venue: WAYVenue
    /// Engine for speech playback.
    private let speechEngine: AudioEngine


    /// List of Facilities (station facilities) to search for
    private let facilities: [WAYFacility]


    // Strings
    private let searchPlaceholder: String


    // MARK: - Intiailizers / Deinitializers

    init(interface: BeaconInterface, venue: WAYVenue, speechEngine: AudioEngine, facilities: [WAYFacility], pageTitle: String, searchPlaceholder: String) {
        self.interface = interface
        self.venue = venue
        self.speechEngine = speechEngine
        self.facilities = facilities
        self.searchPlaceholder = searchPlaceholder

        super.init(style: .plain)

        title = pageTitle

        items = facilities.map({ $0.name })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController?.searchBar.placeholder = searchPlaceholder
    }


    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFacility = facilities[indexPath.row]
        let directionsPreview = RouteCalculationViewController(interface: interface, venue: venue, destination: selectedFacility.entranceNode, speechEngine: speechEngine)

        navigationController?.pushViewController(directionsPreview, animated: true)
    }

}
