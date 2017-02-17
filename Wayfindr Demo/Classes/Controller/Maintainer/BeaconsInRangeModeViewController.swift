//
//  BeaconsInRangeModeSelectionViewController.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 15/12/2015.
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


/// Allows user to choose whether to look for a specific beacon or show the nearest beacon when using the `BeaconInRangeViewController`.
final class BeaconsInRangeModeViewController: BaseViewController<BeaconsInRangeModeView> {
    
    
    // MARK: - Properties
    
    /// Interface for interacting with beacons.
    fileprivate var interface: BeaconInterface
    
    
    // MARK: - Initializers
    
    /**
    Initializes a `BeaconsInRangeModeViewController`.
    
    - parameter interface: `BeaconInterface` for use in searching for nearby beacons.
    */
    init(interface: BeaconInterface) {
        self.interface = interface
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        underlyingView.mainView.specificButton.addTarget(self, action: #selector(BeaconsInRangeModeViewController.specificButtonPressed(_:)), for: .touchUpInside)
        underlyingView.mainView.anyButton.addTarget(self, action: #selector(BeaconsInRangeModeViewController.anyButtonPressed(_:)), for: .touchUpInside)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: WAYStrings.BeaconsInRangeMode.ModeWord, style: .plain, target: nil, action: nil)
        
        title = WAYStrings.BeaconsInRangeMode.SelectMode
    }
    
    
    // MARK: - Control Actions
    
    func specificButtonPressed(_ sender: UIButton) {
        let viewController = BeaconsInRangeSearchTableViewController(interface: interface)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func anyButtonPressed(_ sender: UIButton) {
        let viewController = BeaconsInRangeViewController(interface: interface)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
