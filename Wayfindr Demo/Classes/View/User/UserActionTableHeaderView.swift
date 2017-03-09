//
//  UserActionTableViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 24/07/2016.
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

class UserActionTableHeaderView: UIView {

    // MARK: Instance properties

    var text: String? {
        set {
            tableHeaderLabel?.text = newValue
        }
        get {
            return tableHeaderLabel?.text
        }
    }

    private var tableHeaderLabel: UILabel?


    // MARK: Object life cycle

    init() {
        super.init(frame: CGRect.zero)

        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }


    // MARK: Private helper methods - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        setupLabel()
    }


    private func setupLabel() {
        let tableHeaderLabel = UILabel()
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.font = UIFont.systemFont(ofSize: 12)

        addSubview(tableHeaderLabel)

        let top = tableHeaderLabel.topAnchor.constraint(equalTo: topAnchor)
        top.constant = 15
        top.isActive = true

        let bottom = tableHeaderLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.constant = -5
        bottom.isActive = true

        let leading = tableHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.constant = 15
        leading.isActive = true

        let trailing = tableHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.constant = 10
        trailing.isActive = true


        self.tableHeaderLabel = tableHeaderLabel
    }

}
