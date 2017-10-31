//
//  SettingsDetailViewController.swift
//  Wayfindr Demo
//
//  Created by Technosite on 7/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
	//MARK: - Variables
	
	var titleView: String?
	let cellIdentifier: String = "detailCell"
	var settingsDetail: [String]!
	var currentIndexPath: IndexPath!

	//MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		self.navigationItem.title = titleView
		let currentValue = UserDefaults.standard.object(forKey: titleView!)
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
		return settingsDetail.count
	}
 
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
		cell.textLabel?.text = settingsDetail?[indexPath.row]
        
        applyAccessibility(cell: cell)
		let value = UserDefaults.standard.object(forKey: titleView!) as! String
		if value == settingsDetail?[indexPath.row] {
			cell.accessoryType = .checkmark
			currentIndexPath = indexPath
		} else {
			cell.accessoryType = .none
		}
		
		return cell
		
	}
	
	// MARK : - UITableViewDataDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath)
		if currentIndexPath != indexPath {
			cell?.accessoryType = .checkmark
			let oldcell = tableView.cellForRow(at: currentIndexPath)
			oldcell?.accessoryType = .none
			
			UserDefaults.standard.removeObject(forKey: titleView!)
			let value = cell?.textLabel?.text!
			UserDefaults.standard.setValue(value, forKey: titleView!)
			currentIndexPath = indexPath
		}
	}
    
    // MARK : - Accessibility
    
    func applyAccessibility(cell: UITableViewCell) {
        
        cell.isAccessibilityElement = true
        if #available(iOS 10.0, *) {
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.textLabel?.adjustsFontForContentSizeCategory = true
        }
    }

}
