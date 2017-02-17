//
//  BorderedButton.swift
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

import UIKit

final class BorderedButton: BaseButton {
    
    
    // MARK: - Properties
    fileprivate(set) var mainColor  = WAYConstants.WAYColors.WayfindrMainColor
    fileprivate let disabledColor   = WAYConstants.WAYColors.Disabled
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.borderColor = mainColor.cgColor
            } else {
                layer.borderColor = disabledColor.cgColor
            }
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            mainColor = tintColor
            
            if isEnabled {
                layer.borderColor = tintColor.cgColor
            }
            
            setTitleColor(tintColor, for: UIControlState())
        }
    }
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        setTitleColor(mainColor, for: UIControlState())
        setTitleColor(disabledColor, for: .disabled)
        
        titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        layer.borderWidth = 2.0
        layer.borderColor = mainColor.cgColor
        layer.cornerRadius = 5.0
        
        let edgeSpacing: CGFloat = WAYConstants.WAYLayout.HalfMargin
        contentEdgeInsets = UIEdgeInsets(top: edgeSpacing, left: edgeSpacing, bottom: edgeSpacing, right: edgeSpacing)
    }
    
}
