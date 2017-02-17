//
//  BaseView.swift
//  Wayfindr Tests
//
//  Created by Wayfindr on 10/11/2015.
//  Copyright © 2015 ustwo. All rights reserved.
//

import UIKit

/**
 BaseView acts as a base for common methods
 */
class BaseView: UIView {
    
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setup()
        self.setupAccessibility()
        self.setupConstraints()
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
        
    }
    
    
    // MARK: - Accessibility
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupAccessibility() {
        
    }
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupAccessibility(_ accessibilityLabel: NSString, accessibilityIdentifier: NSString) {
        
    }
    
    // MARK: - Layout
    
    // Abstract method. Subclasses should override this method to add accessibility to their subviews
    func setupConstraints() {
        
    }
}
