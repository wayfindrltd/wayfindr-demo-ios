//
//  LabeledSwitch.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 10/12/2015.
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


class LabeledSwitch: BaseView {
    
    
    // MARK: - Properties
    
    let textLabel       = UILabel()
    let switchControl   = UISwitch()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        textLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        addSubview(textLabel)
        
        addSubview(switchControl)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["textLabel" : textLabel, "switchControl" : switchControl]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-HalfMargin-[textLabel]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraint(NSLayoutConstraint(item: switchControl, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textLabel]-HalfMargin-[switchControl]-(>=QuarterMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
