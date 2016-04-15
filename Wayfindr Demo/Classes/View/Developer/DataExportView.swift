//
//  DataExportView.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 08/01/2016.
//  Copyright © 2016 Wayfindr.org Limited. All rights reserved.
//

import UIKit


final class DataExportView: BaseStackView {
    
    
    // MARK: - Properties
    
    let headerLabel = UILabel()
    
    let nodesButton     = BorderedButton()
    let edgesButton     = BorderedButton()
    let platformsButton = BorderedButton()
    let exitsButton     = BorderedButton()
    
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        headerLabel.lineBreakMode = .ByWordWrapping
        headerLabel.numberOfLines = 0
        headerLabel.text = "What data would you like to export?"
        stackView.addArrangedSubview(headerLabel)
        
        nodesButton.setTitle("Nodes", forState: .Normal)
        stackView.addArrangedSubview(nodesButton)
        
        edgesButton.setTitle("Edges", forState: .Normal)
        stackView.addArrangedSubview(edgesButton)
        
        platformsButton.setTitle("Platforms", forState: .Normal)
        stackView.addArrangedSubview(platformsButton)
        
        exitsButton.setTitle("Exits", forState: .Normal)
        stackView.addArrangedSubview(exitsButton)
    }
    
}
