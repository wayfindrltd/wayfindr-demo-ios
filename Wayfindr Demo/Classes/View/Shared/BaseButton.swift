//
//  BaseButton.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 17/11/2015.
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

import Foundation
import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        
        didSet {
            
            self.updateButtonState()
        }
    }
    
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
        self.setupAccessibility()
        self.setupConstraints()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.setup()
        self.setupAccessibility()
        self.setupConstraints()
    }
    
    
    // MARK: - Setup
    
    // Abstract method. Subclasses should override this method to setup their subviews
    func setup() {
        
        self.setTitleColor(WAYConstants.WAYColors.WayfindrMainColor, for: UIControlState())
        self.adjustsImageWhenHighlighted = false
    }
    
    
    // MARK: - Accessibility
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupAccessibility() {
        
    }
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupAccessibility(_ accessibilityLabel: NSString, accessibilityIdentifier: NSString) {
        
    }
    
    
    // MARK: - Layout - Constraints
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupConstraints() {
        
    }
    
    
    // MARK: - Update State
    
    // Abstract method. Subclasses should override this method to change button according to enabled var
    func updateButtonState() {
        
    }
    
    
}
