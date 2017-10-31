//
//  InternalGPSViewController.swift
//  GuiadoLasArenas
//
//  Created by Technosite on 5/9/17.
//  Copyright © 2017 Delunion. All rights reserved.
//

import UIKit

class InternalGPSViewController: UIViewController {
	
	//MARK: - Outlets

	@IBOutlet weak var titleLb: UILabel!
	
	//MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLb.text = ConstantsStrings.internalGPS.title
        applyAccessibility()
    }
    
    //MARK: - Accessibility
    
    func applyAccessibility() {
        titleLb.isAccessibilityElement = true
        if #available(iOS 10.0, *) {
            titleLb.font = UIFont.preferredFont(forTextStyle: .title1)
            titleLb.adjustsFontForContentSizeCategory = true
            
        } else {
            // Fallback on earlier versions
        }
    }

}
