//
//  RouteCalculationView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 18/11/2015.
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


final class RouteCalculationView: BaseView {
    
    
    // MARK: - Properties
    
    let calculatingStackView    = UIStackView()
    let calculatingLabel        = UILabel()
    let activityIndicator       = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    let optionsStackView    = UIStackView()
    let instructionsLabel   = UITextView()
    let yesButton           = BorderedButton()
    let skipButton          = BorderedButton()
    
    dynamic var calculating = true {
        didSet {
            calculatingStackView.hidden = !calculating
            optionsStackView.hidden = calculating
            
            calculating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        
        // Calculating
        
        setupStackView(calculatingStackView)
        calculatingStackView.distribution = .FillEqually
        addSubview(calculatingStackView)
        
        activityIndicator.color = WAYConstants.WAYColors.WayfindrMainColor
        calculatingStackView.addArrangedSubview(activityIndicator)
        
        calculatingLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        calculatingLabel.text = WAYStrings.RouteCalculation.CalculatingRoute
        calculatingLabel.textAlignment = .Center
        calculatingLabel.numberOfLines = 0
        calculatingLabel.lineBreakMode = .ByWordWrapping
        calculatingStackView.addArrangedSubview(calculatingLabel)
        
        
        // Options
        
        setupStackView(optionsStackView)
        optionsStackView.distribution = .Fill
        addSubview(optionsStackView)
        
        instructionsLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        instructionsLabel.text = WAYStrings.RouteCalculation.InstructionsQuestion
        instructionsLabel.textAlignment = .Center
        instructionsLabel.editable = false
        instructionsLabel.selectable = false
        optionsStackView.addArrangedSubview(instructionsLabel)
        
        yesButton.setTitle(WAYStrings.RouteCalculation.Yes, forState: .Normal)
        optionsStackView.addArrangedSubview(yesButton)
        
        skipButton.setTitle(WAYStrings.RouteCalculation.SkipPreview, forState: .Normal)
        optionsStackView.addArrangedSubview(skipButton)
        
        calculating = true
    }
    
    private func setupStackView(stackView: UIStackView) {
        stackView.axis = .Vertical
        stackView.spacing = WAYConstants.WAYLayout.DefaultMargin
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        setupStackViewConstraints(calculatingStackView)
        setupStackViewConstraints(optionsStackView)
    }
    
    private func setupStackViewConstraints(stackView: UIStackView) {
        // Turn off autoresizing mask
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["stackView" : stackView]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-DefaultMargin-[stackView]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-DefaultMargin-[stackView]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
