//
//  SubtitledDetailTableViewCell.swift
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


final class SubtitledDetailTableViewCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    let mainTextLabel       = UILabel()
    let subtitleTextLabel   = UILabel()
    let rightValueLabel     = UILabel()
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
        setupConstraints()
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        mainTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        mainTextLabel.textColor = UIColor.blackColor()
        mainTextLabel.textAlignment = .Left
        contentView.addSubview(mainTextLabel)
        
        subtitleTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        subtitleTextLabel.textColor = UIColor.blackColor()
        subtitleTextLabel.textAlignment = .Left
        contentView.addSubview(subtitleTextLabel)
        
        rightValueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        rightValueLabel.textColor = WAYConstants.WAYColors.WayfindrMainColor
        rightValueLabel.textAlignment = .Right
        contentView.addSubview(rightValueLabel)
    }
    
    
    // MARK: - Layout
    
    private func setupConstraints() {
        // Turn off autoresizing mask
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        rightValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["mainTextLabel" : mainTextLabel, "subtitleTextLabel" : subtitleTextLabel, "rightValueLabel" : rightValueLabel]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-QuarterMargin-[mainTextLabel][subtitleTextLabel]-QuarterMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: rightValueLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // Horizontal Constraints
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-HalfMargin-[mainTextLabel]-(>=HalfMargin)-[rightValueLabel]-HalfMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-HalfMargin-[subtitleTextLabel]-(>=HalfMargin)-[rightValueLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
