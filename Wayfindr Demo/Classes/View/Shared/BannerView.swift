//
//  BannerView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 30/11/2015.
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


final class BannerView: BaseView {
    
    
    // MARK: - Properties
    
    let textLabel = UILabel()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        backgroundColor = WAYConstants.WAYColors.WayfindrMainColor
        
        textLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textAlignment = .center
        textLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        textLabel.textColor = WAYConstants.WAYColors.NavigationText
        addSubview(textLabel)
    }
    
    
    // MARK: - Accessibility
    
    override func setupAccessibility() {
        super.setupAccessibility()
        
        accessibilityIdentifier = WAYAccessibilityIdentifier.Banner.BannerView
        
        textLabel.accessibilityIdentifier = WAYAccessibilityIdentifier.Banner.TextLabel
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["textLabel" : textLabel]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-HalfMargin-[textLabel]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[textLabel]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
