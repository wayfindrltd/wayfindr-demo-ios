//
//  BeaconsInRangeModeSelectionView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 15/12/2015.
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


final class BeaconsInRangeModeView: BaseStackView {
    
    
    // MARK: - Properties
    
    let mainView    = BeaconsInRangeModeMainView()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        addSubview(mainView)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["mainView" : mainView]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraint(NSLayoutConstraint(item: mainView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[mainView]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}


final class BeaconsInRangeModeMainView: BaseStackView {
    
    
    // MARK: - Properties
    
    let descriptionLabel    = UILabel()
    let specificButton      = BorderedButton()
    let anyButton           = BorderedButton()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        stackView.distribution = .equalCentering
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = WAYStrings.BeaconsInRangeMode.Instructions
        addSubview(descriptionLabel)
        
        specificButton.setTitle(WAYStrings.BeaconsInRangeMode.SpecificBeacon, for: UIControlState())
        specificButton.tintColor = WAYConstants.WAYColors.Maintainer
        addSubview(specificButton)
        
        anyButton.setTitle(WAYStrings.BeaconsInRangeMode.AnyBeacon, for: UIControlState())
        anyButton.tintColor = WAYConstants.WAYColors.Maintainer
        addSubview(anyButton)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        specificButton.translatesAutoresizingMaskIntoConstraints = false
        anyButton.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["descriptionLabel" : descriptionLabel, "specificButton" : specificButton, "anyButton" : anyButton]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-HalfMargin-[descriptionLabel]-DoubleMargin-[specificButton]-HalfMargin-[anyButton]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[descriptionLabel]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[specificButton]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-HalfMargin-[anyButton]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
