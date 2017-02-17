//
//  BaseViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 11/11/2015.
//  Copyright © 2015 ustwo. All rights reserved.
//

import UIKit


/// Generic base view controller that automatically loads the underlying `BaseView` of type `T`.
class BaseViewController<T : BaseView>: UIViewController {
    
    
    // MARK: - Properties
    
    var underlyingView: T {
        if let myView = view as? T {
            return myView
        }
        
        let newView = T()
        view = newView
        return newView
    }
    
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = T()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAccessibility()
    }
    
    
    // MARK: - Setup
    
    // Abstract method. Subclasses should override this method to setup their view.
    func setupView() {
    
    }
    
    // Abstract method. Subclasses should override this method to add accessibility.
    func setupAccessibility() {
        
    }

}
