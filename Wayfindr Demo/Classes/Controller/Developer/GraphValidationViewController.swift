//
//  GraphValidationViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 17/12/2015.
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


/// Checks the `WAYVenue` graph data. Displays possible errors and problems.
final class GraphValidationViewController: BaseViewController<GraphValidationView> {
    
    
    // MARK: - Properties
    
    /// Interface for gathering information about the venue
    private let venueInterface: VenueInterface
    /// Model representation of entire venue.
    private var venue: WAYVenue?
    
    /// Array of words that means the validation check passed.
    private let passWords = ["PASS"]
    /// Array of words that means the validation check failed.
    private let failWords = ["ERROR", "FAIL", "INVALID"]
    
    
    // MARK: - Initializers
    
    /**
    Initializes a `GraphValidationViewController`.
    
    - parameter venueInterface: Interface for gathering information about the venue.
    */
    init(venueInterface: VenueInterface) {
        self.venueInterface = venueInterface
        
        super.init()
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Validation"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(GraphValidationViewController.actionButtonPressed(_:)))
        
        venueInterface.getVenue(completionHandler: { success, newVenue, error in
            if success, let myVenue = newVenue {
                self.venue = myVenue
                
                self.underlyingView.headerLabel.text = "Graph: VALID"
                
                self.checkGraph(verbose: false)
            } else if let myError = error {
                self.underlyingView.headerLabel.text = "Graph: " + myError.description
            } else {
                self.underlyingView.headerLabel.text = "Graph: " + WAYStrings.ErrorMessages.UnknownError
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    override func setupView() {
        super.setupView()
        
        underlyingView.verboseLabeledSwitch.switchControl.addTarget(self, action: #selector(GraphValidationViewController.verboseSwitchValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    
    
    // MARK: - Graph Checking
    
    /**
    Checks the graph.
    
    - parameter verbose: Whether or not to use a verbose output.
    */
    private func checkGraph(verbose verbose: Bool) {
        guard let myVenue = venue else {
            return
        }
        
        SVProgressHUD.show()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { [weak self] in
            self?.checkPlatformConnectivity(verbose: verbose)
            self?.checkExitConnectivity(verbose: verbose)
            self?.checkEdgesWithoutInstructions(myVenue.destinationGraph, verbose: verbose)
            
            self?.checkFullConnectivity(myVenue.destinationGraph, verbose: verbose)
            
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
            })
        })
    }
    
    /**
     Checks whether or not the graph is connected. In other words, that you can route from any node to any other node.
     
     - parameter destinationGraph: `WAYGraph` representation to check.
     - parameter verbose:          Whether or not to print out details about where the discontinuities are, if they exist.
     */
    private func checkFullConnectivity(destinationGraph: WAYGraph, verbose: Bool) {
        var newText = ""
        
        let isConnected = destinationGraph.graph.isConnected
        let result: String
        if isConnected {
            result = "PASS"
        } else {
            result = "FAIL"
        }
        newText = "Fully Connected Graph: \(result)"
        
        if !isConnected && verbose {
            let discontinuities = destinationGraph.graph.discontinuities
            
            for (startIndex, endIndex) in discontinuities {
                let startNode = destinationGraph.graph[startIndex]
                let endNode = destinationGraph.graph[endIndex]
                
                newText = newText + "\n\n  - Missing Path: \(startNode.identifier) to \(endNode.identifier)"
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.addInformation(newText)
        })
    }
    
    /**
     Checks whether you can get from any node to each platform.
     
     - parameter verbose: Whether or not to print out details about where the discontinuities are, if they exist.
     */
    private func checkPlatformConnectivity(verbose verbose: Bool) {
        guard let myVenue = venue else {
            return
        }
        
        let platformDestinations = myVenue.platforms.map { $0 as WAYDestination }
        let exitDestinations = myVenue.exits.map { $0 as WAYDestination }
        
        let ignoreDestinations = [platformDestinations, exitDestinations].flatMap { $0 }
        
        checkDestinationConnectivity(platformDestinations, ignoreDestinations: ignoreDestinations, connectivityTitle: "Platform", verbose: verbose)
    }
    
    /**
     Checks whether you can get from any node to each exit.
     
     - parameter verbose: Whether or not to print out details about where the discontinuities are, if they exist.
     */
    private func checkExitConnectivity(verbose verbose: Bool) {
        guard let myVenue = venue else {
            return
        }
        
        let platformDestinations = myVenue.platforms.map { $0 as WAYDestination }
        let exitDestinations = myVenue.exits.map { $0 as WAYDestination }
        
        let ignoreDestinations = [platformDestinations, exitDestinations].flatMap { $0 }
        
        checkDestinationConnectivity(exitDestinations, ignoreDestinations: ignoreDestinations, connectivityTitle: "Exit", verbose: verbose)
    }
    
    /**
     Checks whether you can get from any node to each destination.
     
     - parameter destinations:       Array of destinations.
     - parameter ignoreDestinations: Ignore the `entranceNode` of these destinations if they are different from the `exitNode`.
     - parameter connectivityTitle:  `String` to use when describing the connectivity in output.
     - parameter verbose:            Whether or not to print out details about where the discontinuities are, if they exist.
     */
    private func checkDestinationConnectivity(destinations: [WAYDestination], ignoreDestinations: [WAYDestination], connectivityTitle: String, verbose: Bool) {
        guard let myVenue = venue else {
            return
        }
        
        let graph = myVenue.destinationGraph.graph
        var missingEdges = [(Int, Int)]()
        
        var ignoreEntranceIndices = [Int]()
        for destination in ignoreDestinations where destination.entranceNode != destination.exitNode {
            let destinationNode = destination.entranceNode
            
            if let destinationNodeIndex = graph.indexOf(destinationNode) {
                ignoreEntranceIndices.append(destinationNodeIndex)
            }
        }
        
        for destination in destinations {
            let destinationNode = destination.entranceNode
            
            if let destinationNodeIndex = graph.indexOf(destinationNode) {
                for (index, _) in graph.enumerate() {
                    if index != destinationNodeIndex && !ignoreEntranceIndices.contains(index) {
                        let route = bfs(index, to: destinationNodeIndex, graph: graph)
                        
                        if route.isEmpty {
                            missingEdges.append((index, destinationNodeIndex))
                        }
                    }
                }
            }
        }
        
        var newText = ""
        
        let result: String
        if missingEdges.isEmpty {
            result = "PASS"
        } else {
            result = "FAIL"
        }
        
        newText = "\(connectivityTitle) Connectivity: \(result)"
        
        if !missingEdges.isEmpty && verbose {
            for (startIndex, endIndex) in missingEdges {
                let startNode = graph[startIndex]
                let endNode = graph[endIndex]
                
                var verboseText = "  - Missing Path: \(startNode.identifier) to \(endNode.identifier)\n"
                verboseText = verboseText + "      \(startNode.identifier): \(startNode.name)\n"
                verboseText = verboseText + "      \(endNode.identifier): \(endNode.name)"
                
                newText = newText + "\n\n" + verboseText
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.addInformation(newText)
        })
    }
    
    /**
     Checks whether or not there are any edges in the graph that have no instructions.
     
     - parameter destinationGraph: `WAYGraph` representation to check.
     - parameter verbose:          Whether or not to print out details about which edges lack instructions.
     */
    private func checkEdgesWithoutInstructions(destinationGraph: WAYGraph, verbose: Bool) {
        var newText = ""
        
        var edgesWithoutInstructions = [WAYGraphEdge]()
        for edge in destinationGraph.edges {
            if edge.instructions.allInstructions().isEmpty && edge.instructions.startingOnly == nil {
                edgesWithoutInstructions.append(edge)
            }
        }
        
        let result: String
        if edgesWithoutInstructions.isEmpty {
            result = "PASS"
        } else {
            result = "FAIL"
        }
        
        newText = "Edges Without Instructions: \(result)"
        
        if !edgesWithoutInstructions.isEmpty && verbose {
            for edge in edgesWithoutInstructions {
                newText = newText + "\n\n  - No Instructions: \(edge.identifier)"
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { [weak self] in
            self?.addInformation(newText)
        })
    }
    
    
    // MARK: - Control Actions
    
    func actionButtonPressed(sender: UIBarButtonItem) {
        let text = shareableText()
        let printableText = UISimpleTextPrintFormatter(attributedText: text)
        
        let viewController = UIActivityViewController(activityItems: [text, printableText], applicationActivities: nil)
        
        let popoverController = viewController.popoverPresentationController
        popoverController?.barButtonItem = sender
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func verboseSwitchValueChanged(sender: UISwitch) {
        SVProgressHUD.show()
        underlyingView.textView.text = ""
        sender.enabled = false
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { [weak self] in
            self?.checkGraph(verbose: sender.on)
            
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.dismiss()
                sender.enabled = true
            })
        })
    }
    
    
    // MARK: - Text Manipulation
    
    private func shareableText() -> NSAttributedString {
        // Body
        let mutableAttributedString = NSMutableAttributedString(attributedString: underlyingView.textView.attributedText)
        
        // Header
        if let headerText = underlyingView.headerLabel.text {
            let headerAttributedString = NSMutableAttributedString(string: headerText + "\n\n\n")
            headerAttributedString.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2), range: NSRange(location: 0, length: headerAttributedString.length))
            
            mutableAttributedString.insertAttributedString(headerAttributedString, atIndex: 0)
        }
        
        // Title
        if let venueName = venue?.name {
            let venueNameAttributedString = NSMutableAttributedString(string: venueName + "\n\n")
            venueNameAttributedString.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1), range: NSRange(location: 0, length: venueNameAttributedString.length))
            
            mutableAttributedString.insertAttributedString(venueNameAttributedString, atIndex: 0)
        }
        
        return mutableAttributedString
    }
    
    /**
    Appends information to the `UITextView` and highlights key words.
    
    - parameter information: Information to add to the display.
    */
    private func addInformation(information: String) {
        let text: String
        
        if underlyingView.textView.attributedText.length == 0 {
            text = information
        } else {
            text = underlyingView.textView.attributedText.string + "\n\n" + information
        }
        
        // Initialize attributed string
        var mutableAttributedString = NSMutableAttributedString(string: text)
        
        // Highlight any pass or fail
        for passWord in passWords {
            highlightString(passWord, inString: &mutableAttributedString, color: WAYConstants.WAYColors.WayfindrMainColor)
        }
        for failWord in failWords {
            highlightString(failWord, inString: &mutableAttributedString, color: UIColor.redColor())
        }
        
        // Set the font
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), range: NSRange(location: 0, length: mutableAttributedString.length))
        
        // Display the text
        underlyingView.textView.attributedText = mutableAttributedString
    }
    
    /**
     Highlights a substring within a larger `NSMutableAttributedString`.
     
     - parameter highlightText: Substring to highlight within `fullText`.
     - parameter fullText:      `NSMutableAttributedString` in which to highlight instances of `highlightText`.
     - parameter color:         `UIColor` to use for highlighting.
     */
    private func highlightString(highlightText: String, inout inString fullText: NSMutableAttributedString, color: UIColor) {
        if let regex = try? NSRegularExpression(pattern: highlightText, options: []) {
            let ranges = regex.matchesInString(fullText.string, options: [], range: NSRange(location: 0, length: fullText.string.characters.count)).map { $0.range }
            
            for range in ranges {
                fullText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
            }
        }
    }
    
}
