//
//  UIView+Borders.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/11/2015.
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

extension UIView {

    /**
     Creates borders and adds them as subviews to the view.
     
     - parameter edges:     Edges on which to create a border.
     - parameter colour:    Color to tint the border. Default is white.
     - parameter thickness: Thickness of the border. Default is 1.
     
     - seealso: Taken from http://stackoverflow.com/questions/17355280/how-to-add-a-border-just-on-the-top-side-of-a-uiview
     
     - returns: Border views that have been added as subviews.
     */
    @discardableResult func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                    options: [],
                    metrics: ["thickness": thickness],
                    views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                    options: [],
                    metrics: nil,
                    views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
}
