//
//  Strings.swift
//  GuiadoLasArenas
//
//  Created by Technosite on 5/9/17.
//  Copyright © 2017 Delunion. All rights reserved.
//

import Foundation

struct ConstantsStrings {
	
	// MARK: - Internal GPS View Controller
	
	struct internalGPS {
		static let title = NSLocalizedString("This function is not yet available", comment: "")
	}
	
	// MARK: - Initial View Controller
	
	struct initialVC {
		static let title = NSLocalizedString("Location Engine", comment: "")
		static let button1 = NSLocalizedString("Internal GPS", comment: "")
		static let button2 = NSLocalizedString("Beacon Constellation /Load from a file", comment:"")
		static let button3 = NSLocalizedString("Fingerprinting /Load from file", comment: "")
	}
    
    // MARK: - Instructions
    
    struct instructions {
        static let error = NSLocalizedString("Creo que se ha equivocado. Por favor, de la vuelta para continuar el camino", comment: "")
    }
	
}
