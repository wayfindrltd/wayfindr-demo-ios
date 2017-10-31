//
//  SettingsTableViewController.swift
//  Wayfindr Demo
//
//  Created by Technosite on 6/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var startBt: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    let settings = ["Instruction of distance", "Near instructions", "Assignation distance", "Precision", "Route", "Locator",
                    "Scanning time", "K", "Weight", "Max Accuracy", "Min Accuracy", "Smooth"]
    let cellIdentifier = "cellItems"
    let detailTVSegue = "detailSegue"
    let orquestratorSegue = "orquestratorSegue"
    var text: String?
    var properties: [String] = []
    var instructionsDistance: Int = 0
    var nearInstructions: Int = 0
    var assignationDistance: Int = 0
    var precision: Double!
    var route: String = ""
    var locator: Int = 0
    var scanningTime: Int = 0
    var k: Int = 0
    var weight: Int = 0
    var maxAccuracy: Int = 0
    var minAccuracy: Int = 0
    var smooth: Float = 0.0
    var settingsValue: String?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.remembersLastFocusedIndexPath = true
        applyAccessibility()
        
        setUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        checkMinMaxAccuracy(maxAccuracy: UserDefaults.standard.integer(forKey: settings[9]), minAccuracy: UserDefaults.standard.integer(forKey: settings[10]))
        tableView.remembersLastFocusedIndexPath = true
    }
    
    func setUserDefaults() {
        for variable in settings {
            if UserDefaults.standard.object(forKey: variable) == nil {
                switch variable {
                case settings[0]:
                    UserDefaults.standard.set("8", forKey: settings[0])
                case settings[1]:
                    UserDefaults.standard.set("4", forKey: settings[1])
                case settings[2]:
                    UserDefaults.standard.set("3", forKey: settings[2])
                case settings[3]:
                    UserDefaults.standard.set("1.0", forKey: settings[3])
                case settings[4]:
                    UserDefaults.standard.set("Morado", forKey: settings[4])
                case settings[5]:
                    UserDefaults.standard.set("0.5", forKey: settings[5])
                case settings[6]:
                    UserDefaults.standard.set("4", forKey: settings[6])
                case settings[7]:
                    UserDefaults.standard.set("3", forKey: settings[7])
                case settings[8]:
                    UserDefaults.standard.set("5", forKey: settings[8])
                case settings[9]:
                    UserDefaults.standard.set("-1", forKey: settings[9])
                case settings[10]:
                    UserDefaults.standard.set("-1", forKey: settings[10])
                case settings[11]:
                    UserDefaults.standard.set("0.1", forKey: settings[11])
                default:
                    print("ERROR: Can't set UserDefaults")
                }
            }
        }
    }
    
    func checkMinMaxAccuracy(maxAccuracy: Int, minAccuracy: Int) {
        if maxAccuracy < minAccuracy {
            let dialogMessage = UIAlertController(title: "ERROR", message: "Max Accuracy must be greater than Min Accuracy", preferredStyle: .alert)
            
            let goToMax = UIAlertAction(title: "Fix Max", style: .default, handler: { (action) -> Void in
                print("Max button tapped")
                self.setUpSettingsDetailViewController(caseNumber: 9)
                self.performSegue(withIdentifier: self.detailTVSegue, sender: 9)
            })
        
            let goToMin = UIAlertAction(title: "Fix Min", style: .default) { (action) -> Void in
                print("Min button tapped")
                self.setUpSettingsDetailViewController(caseNumber: 10)
                self.performSegue(withIdentifier: self.detailTVSegue, sender: 10)
            }
            dialogMessage.addAction(goToMax)
            dialogMessage.addAction(goToMin)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        cell.detailTextLabel?.text = UserDefaults.standard.object(forKey: settings[indexPath.row]) as? String
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        applyCellAccessibility(cell: cell)
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setUpSettingsDetailViewController(caseNumber: indexPath.row)
        self.performSegue(withIdentifier: detailTVSegue, sender: indexPath)
    }
    
    func setUpSettingsDetailViewController (caseNumber: Int) {
        
        text = settings[caseNumber]
        
        switch caseNumber {
        case 0:
            properties = ["6", "8", "10"]
        case 1:
            properties = fillArray(firstIndex: 3, lastIndex: 10)
        case 2:
            properties = fillArray(firstIndex: 0, lastIndex: 6)
        case 3:
            properties = ["0.0", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0"]
        case 4:
            properties = ["Morado", "Rojo", "Naranja", "Verde_0", "Verde_1", "Verde_2"]
        case 5:
            properties = ["0.5", "1", "2", "5", "10", "15"]
        case 6:
            properties = fillArray(firstIndex: 2, lastIndex: 5)
        case 7:
            properties = fillArray(firstIndex: 1, lastIndex: 10)
        case 8:
            properties = fillArray(firstIndex: 1, lastIndex: 10)
        case 9:
            properties = ["-1", "0", "10", "20", "30", "40", "50"]
        case 10:
            properties = ["-1", "0", "10", "20", "30", "40", "50"]
        case 11:
            properties = ["0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8","0.9", "1.0",]
        default:
            text = "Default"
            properties = ["default"]
        }
        
    }
    
    func fillArray (firstIndex: Int, lastIndex: Int) -> [String] {
        var arrayNumbers = [String]()
        
        for i in firstIndex ... lastIndex {
            let number = String(i)
            arrayNumbers.append(number)
        }
        
        return arrayNumbers
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == detailTVSegue {
            let controller = segue.destination as! SettingsDetailViewController
            controller.titleView = text!
            controller.settingsDetail = properties
        }
        
        if segue.identifier == orquestratorSegue {
            if #available(iOS 10.0, *) {
                let controller = segue.destination as! OrquestratorViewController
                controller.routeID = getRouteID(nameRoute: UserDefaults.standard.string(forKey: settings[4])!)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    func getRouteID(nameRoute: String) -> Int {
        var routeID: Int
        
        switch nameRoute {
        case "Morado":
            routeID = 1
        case "Rojo":
            routeID = 2
        case "Naranja":
            routeID = 3
        case "Verde_0":
            routeID = 4
        case "Verde_1":
            routeID = 5
        case "Verde_2":
            routeID = 6
        default:
            routeID = 1
        }
        
        return routeID
    }
    
    // MARK: - Accessibility
    
    func applyAccessibility(){
        startBt.isAccessibilityElement = true
        if #available(iOS 10.0, *) {
            startBt.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            startBt.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func applyCellAccessibility(cell: UITableViewCell) {
        
        cell.isAccessibilityElement = true
        if #available(iOS 10.0, *) {
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            
            cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
            
            cell.accessibilityTraits = UIAccessibilityTraitButton
        }
    }
    
}
