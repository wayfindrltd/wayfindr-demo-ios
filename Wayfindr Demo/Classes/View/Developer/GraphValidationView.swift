//
//  GraphValidationView.swift
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


final class GraphValidationView: BaseStackView {
    
    
    // MARK: - Properties
    
    let headerLabel             = UILabel()
    let textView                = UITextView()
    let verboseLabeledSwitch    = LabeledSwitch()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        stackView.distribution = .fill
        
        headerLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(headerLabel)
        
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        textView.isEditable = false
        textView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        stackView.addArrangedSubview(textView)
        
        verboseLabeledSwitch.textLabel.text = "Verbose"
        stackView.addArrangedSubview(verboseLabeledSwitch)
    }
    
}
