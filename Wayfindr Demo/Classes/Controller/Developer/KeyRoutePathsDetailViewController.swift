//
//  KeyRoutePathsDetailViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 20/11/2015.
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


/// Displays detailed information regarding the selected key route (e.g. instructions, edges, etc.).
final class KeyRoutePathsDetailViewController: BaseViewController<KeyRoutePathsDetailView> {
    
    
    // MARK: - Properties
    
    /// Selected route data to be displayed
    fileprivate let routeData: KeyRouteData
    
    /// Aggregate of all the instructions from the route
    fileprivate var allInstructions = ""
    /// Aggregate of all the edges from the route
    fileprivate var allEdges = ""
    
    
    // MARK: - Intiailizers / Deinitializers
    
    /**
    Initializes a `KeyRoutePathsDetailViewController`.
    
    - parameter routeData: Data about the route to display.
    */
    init(routeData: KeyRouteData) {
        self.routeData = routeData
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WAYStrings.KeyRoutePathsDetail.RouteDetails
        
        extractInstructions()
        extractEdges()
        
        underlyingView.bodyView.textView.text = allInstructions
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        underlyingView.bodyView.textView.flashScrollIndicators()
    }
    
    
    // MARK: - Setup
    
    /**
    Finishes setting up the view.
    */
    override func setupView() {
        super.setupView()
        
        underlyingView.headerView.titleLabel.text = routeData.name
        underlyingView.headerView.subtitleLabel.text = "\(routeData.travelTime)s"
        
        underlyingView.bodyView.segmentControl.addTarget(self, action: #selector(KeyRoutePathsDetailViewController.segmentedControlChanged(_:)), for: .valueChanged)
    }
    
    /**
     Extracts all of the instructions for the route and stores it in `allInstructions`.
     */
    fileprivate func extractInstructions() {
        var instructions = ""
        for routeItem in routeData.route {
            for instruction in routeItem.instructions.allInstructions() {
                instructions += instruction + "\n\n"
            }
        }
        
        if !instructions.isEmpty {
            instructions = String(instructions.characters.dropLast(2))
        }
        
        allInstructions = instructions
    }
    
    /**
     Extracts all of the edges for the route and stores it in `allEdges`.
     */
    fileprivate func extractEdges() {
        var edges = ""
        for (index, routeItem) in routeData.route.enumerated() {
            edges += "\(index + 1). Node \(routeItem.sourceID) to Node \(routeItem.targetID)\n"
        }
        
        if !edges.isEmpty {
            edges = String(edges.characters.dropLast())
        }
        
        allEdges = edges
    }
    
    
    // MARK: - Control Actions
    
    func segmentedControlChanged(_ sender: UISegmentedControl) {
        guard let segmentType = KeyRoutePathsDetailBodyView.RouteDetailOptions(rawValue: sender.selectedSegmentIndex) else {
            
            return
        }
        
        switch segmentType {
        case .instructions:
            underlyingView.bodyView.textView.text = allInstructions
        case .paths:
            underlyingView.bodyView.textView.text = allEdges
        }
        
        underlyingView.bodyView.textView.flashScrollIndicators()
    }
    
}
