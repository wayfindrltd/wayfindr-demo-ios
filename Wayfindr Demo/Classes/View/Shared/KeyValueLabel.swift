//
//  KeyValueLabel.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 13/11/2015.
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

final class KeyValueLabel: BaseView {
    
    
    // MARK: - Properties
    
    let keyLabel = UILabel()
    let valueLabel = UILabel()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        keyLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        valueLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .byWordWrapping
        
        addSubview(keyLabel)
        addSubview(valueLabel)
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Turn off autoresizing mask
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["key" : keyLabel, "value" : valueLabel]
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[key][value]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[key]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[value]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
}
