//
//  KeyRoutePathsDetailView.swift
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

final class KeyRoutePathsDetailView: BaseView {
    
    
    // MARK: - Properties
    
    let headerView = KeyRoutePathsDetailHeaderView()
    let bodyView = KeyRoutePathsDetailBodyView()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        headerView.addBorder(edges: [.Bottom], colour: WAYConstants.WAYColors.Border, thickness: 3.0)
        
        addSubview(headerView)
        addSubview(bodyView)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        headerView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["headerView" : headerView, "bodyView" : bodyView]
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[headerView][bodyView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: WAYConstants.WAYLayout.metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[headerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bodyView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
}

final class KeyRoutePathsDetailHeaderView: BaseStackView {
    
    
    // MARK: - Properties
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        subtitleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle2)
        
        titleLabel.text = WAYStrings.CommonStrings.Beacon.uppercaseString
        subtitleLabel.text = WAYStrings.CommonStrings.Minor
        
        titleLabel.textAlignment = .Center
        subtitleLabel.textAlignment = .Center
        
        stackView.alignment = .Center
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
}

final class KeyRoutePathsDetailBodyView: BaseView {
    
    
    // MARK: - Properties
    
    let segmentControl  = UISegmentedControl()
    let textView        = UITextView()
    
    enum RouteDetailOptions: Int {
        case Instructions
        case Paths
    }
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        segmentControl.insertSegmentWithTitle(WAYStrings.KeyRoutePathsDetail.Instructions, atIndex: RouteDetailOptions.Instructions.rawValue, animated: false)
        segmentControl.insertSegmentWithTitle(WAYStrings.KeyRoutePathsDetail.Paths, atIndex: RouteDetailOptions.Paths.rawValue, animated: false)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = WAYConstants.WAYColors.Developer
        addSubview(segmentControl)
        
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.editable = false
        addSubview(textView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        textView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["textView" : textView, "segmentControl" : segmentControl]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-HalfMargin-[segmentControl]-HalfMargin-[textView]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-HalfMargin-[textView]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-HalfMargin-[segmentControl]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
