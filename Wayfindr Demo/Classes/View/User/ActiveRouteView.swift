//
//  ActiveRouteView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
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


/// View displaying the currently active route to the user.
class ActiveRouteView: BaseView {
    
    
    // MARK: - Properties
    
    let textView = UITextView()
    let repeatButton = BorderedButton()
    let timeLabel = UILabel()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        addSubview(textView)
        
        repeatButton.accessibilityLabel = WAYStrings.ActiveRoute.Repeat
        repeatButton.setTitle(WAYStrings.ActiveRoute.Repeat, for: UIControlState())
        repeatButton.isEnabled = false
        addSubview(repeatButton)
        
        timeLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        timeLabel.textAlignment = .center
        addSubview(timeLabel)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing masks
        textView.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup view dictionary
        let views = ["text" : textView, "button" : repeatButton]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-DefaultMargin-[text]-DefaultMargin-[button]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-DefaultMargin-[text]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-DefaultMargin-[button]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Time label constraints
        let timeLabelConstraints = [
            NSLayoutConstraint(item: timeLabel, attribute: .centerX, relatedBy: .equal, toItem: repeatButton, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: timeLabel, attribute: .bottom, relatedBy: .equal, toItem: repeatButton, attribute: .top, multiplier: 1.0, constant: -10.0),
        ]
        
        addConstraints(timeLabelConstraints)
    }
    
}
