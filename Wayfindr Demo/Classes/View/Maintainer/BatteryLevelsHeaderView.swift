//
//  BatteryLevelsHeaderView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 09/12/2015.
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


final class BatteryLevelsHeaderView: BaseView {
    
    
    // MARK: - Properties
    
    let segmentControl = UISegmentedControl(items: nil)
    let borderThickness: CGFloat = 2.0
    
    
    // MARK: - Setup
    
    override func setup() {
        for (index, item) in BatteryLevelFilters.allValues.enumerated() {
            segmentControl.insertSegment(withTitle: item.description, at: index, animated: false)
        }
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = WAYConstants.WAYColors.Maintainer
        addSubview(segmentControl)
        
        addBorder(edges: .bottom, colour: WAYConstants.WAYColors.Border, thickness: borderThickness)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        // Turn off autoresizing mask
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["segmentControl" : segmentControl]
        var metrics = WAYConstants.WAYLayout.metrics
        metrics["QuarterAndBorder"] = WAYConstants.WAYLayout.QuarterMargin + borderThickness
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-QuarterMargin-[segmentControl]-QuarterAndBorder-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraint(NSLayoutConstraint(item: segmentControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
}
