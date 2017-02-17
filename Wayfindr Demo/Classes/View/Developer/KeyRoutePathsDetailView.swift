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
        
        headerView.addBorder(edges: [.bottom], colour: WAYConstants.WAYColors.Border, thickness: 3.0)
        
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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView][bodyView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: WAYConstants.WAYLayout.metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bodyView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
}

final class KeyRoutePathsDetailHeaderView: BaseStackView {
    
    
    // MARK: - Properties
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
        
        titleLabel.text = WAYStrings.CommonStrings.Beacon.uppercased()
        subtitleLabel.text = WAYStrings.CommonStrings.Minor
        
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
        
        stackView.alignment = .center
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
}

final class KeyRoutePathsDetailBodyView: BaseView {
    
    
    // MARK: - Properties
    
    let segmentControl  = UISegmentedControl()
    let textView        = UITextView()
    
    enum RouteDetailOptions: Int {
        case instructions
        case paths
    }
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        segmentControl.insertSegment(withTitle: WAYStrings.KeyRoutePathsDetail.Instructions, at: RouteDetailOptions.instructions.rawValue, animated: false)
        segmentControl.insertSegment(withTitle: WAYStrings.KeyRoutePathsDetail.Paths, at: RouteDetailOptions.paths.rawValue, animated: false)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = WAYConstants.WAYColors.Developer
        addSubview(segmentControl)
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.isEditable = false
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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-HalfMargin-[segmentControl]-HalfMargin-[textView]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[textView]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[segmentControl]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
