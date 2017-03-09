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
    let activityIndicator       = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let optionsStackView    = UIStackView()
    let instructionsLabel   = UITextView()
    let yesButton           = BorderedButton()
    let skipButton          = BorderedButton()
    
    dynamic var calculating = true {
        didSet {
            calculatingStackView.isHidden = !calculating
            optionsStackView.isHidden = calculating
            
            calculating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()

            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil)
        }
    }
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()


        // Calculating
        
        setupStackView(calculatingStackView)
        calculatingStackView.distribution = .fillEqually
        addSubview(calculatingStackView)
        
        activityIndicator.color = WAYConstants.WAYColors.WayfindrMainColor
        calculatingStackView.addArrangedSubview(activityIndicator)
        
        calculatingLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        calculatingLabel.text = WAYStrings.RouteCalculation.CalculatingRoute
        calculatingLabel.textAlignment = .center
        calculatingLabel.numberOfLines = 0
        calculatingLabel.lineBreakMode = .byWordWrapping
        calculatingStackView.addArrangedSubview(calculatingLabel)
        
        
        // Options
        
        setupStackView(optionsStackView)
        optionsStackView.distribution = .fill
        addSubview(optionsStackView)
        
        instructionsLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        instructionsLabel.text = WAYStrings.RouteCalculation.InstructionsQuestion
        instructionsLabel.accessibilityTraits = UIAccessibilityTraitStaticText
        instructionsLabel.textAlignment = .center
        instructionsLabel.isEditable = false
        instructionsLabel.isSelectable = false

        optionsStackView.addArrangedSubview(instructionsLabel)
        
        yesButton.setTitle(WAYStrings.RouteCalculation.Yes, for: UIControlState())
        optionsStackView.addArrangedSubview(yesButton)
        
        skipButton.setTitle(WAYStrings.RouteCalculation.SkipPreview, for: UIControlState())
        optionsStackView.addArrangedSubview(skipButton)
        
        calculating = true
    }
    
    fileprivate func setupStackView(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.spacing = WAYConstants.WAYLayout.DefaultMargin
    }
    
    
    // MARK: - Layout
    
    override func setupConstraints() {
        super.setupConstraints()
        
        setupStackViewConstraints(calculatingStackView)
        setupStackViewConstraints(optionsStackView)
    }
    
    fileprivate func setupStackViewConstraints(_ stackView: UIStackView) {
        // Turn off autoresizing mask
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // View Dictionary
        let views = ["stackView" : stackView]
        let metrics = WAYConstants.WAYLayout.metrics
        
        // Vertical Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-DefaultMargin-[stackView]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        // Horizontal Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-DefaultMargin-[stackView]-DefaultMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
}
