//
//  MainVC.swift
//  Wayfindr Demo
//
//  Created by Technosite on 5/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class MainVC: UIViewController {
	
	//MARK: - Outlets
	
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var internalBt: UIButton!
	@IBOutlet weak var wayfindrBt: UIButton!
	@IBOutlet weak var fingerprintingBt: UIButton!
    
    var dialogMessage: UIAlertController!
    let settingsSegue = "goToSettings"
	
	@IBAction func wayfindr(_ sender: Any) {
		
		
	}
	
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = ConstantsStrings.initialVC.title
        internalBt.setTitle(ConstantsStrings.initialVC.button1, for: .normal)
        wayfindrBt.setTitle(ConstantsStrings.initialVC.button2, for: .normal)
        fingerprintingBt.setTitle(ConstantsStrings.initialVC.button3, for: .normal)
        
        applyAccessibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        titleLbl.text = ConstantsStrings.initialVC.title
        
        titleLbl.font = UIFont.preferredFont(forTextStyle: .headline)
        internalBt.setTitle(ConstantsStrings.initialVC.button1, for: .normal)
        wayfindrBt.setTitle(ConstantsStrings.initialVC.button2, for: .normal)
        fingerprintingBt.setTitle(ConstantsStrings.initialVC.button3, for: .normal)
    }
    
    // MARK: - Database
    
    @IBAction func checkDataBase(_ sender: Any) {
        
        if DBManager.shared.createDatabase() {
            showAlertCreatingDB()
            DispatchQueue.global(qos: .background).async {
                DBManager.shared.insertBeaconsData()
                DBManager.shared.insertFingerprintsData()
                DBManager.shared.insertInstructionsTypeData()
                DBManager.shared.insertLinksData()
                DBManager.shared.insertNodesData()
                DBManager.shared.insertRoutesData()
                
                DispatchQueue.main.async {
                    self.dialogMessage.dismiss(animated: true, completion: nil)
                    self.showAlertDBCreated()
                }
            }
        }
        
    }
    
    // MARK: - Alert
    
    func showAlertCreatingDB() {
        
        dialogMessage = UIAlertController(title: "AVISO", message: "Se está creando la base de datos, por favor espere", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: dialogMessage.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.color = UIColor.black
        
        dialogMessage.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showAlertDBCreated() {
        
        let dialogMessage = UIAlertController(title: "INFO", message: "La base de datos ha sido creada. Puede comenzar la navegación.", preferredStyle: .alert)

        let sendInfo = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Send")
            self.performSegue(withIdentifier: self.settingsSegue, sender: (Any).self)
        })
        
        dialogMessage.addAction(sendInfo)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Accessibility
    
    func applyAccessibility() {
        titleLbl.isAccessibilityElement = true
        internalBt.isAccessibilityElement = true
        wayfindrBt.isAccessibilityElement = true
        fingerprintingBt.isAccessibilityElement = true
        if #available(iOS 10.0, *) {
            titleLbl.font = UIFont.preferredFont(forTextStyle: .body)
            titleLbl.adjustsFontForContentSizeCategory = true
            internalBt.titleLabel?.minimumScaleFactor = 0.01
            internalBt.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            internalBt.titleLabel?.adjustsFontSizeToFitWidth = true
            internalBt.titleLabel?.lineBreakMode = .byClipping
            wayfindrBt.titleLabel?.numberOfLines = 1
            wayfindrBt.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            wayfindrBt.titleLabel?.adjustsFontSizeToFitWidth = true
            wayfindrBt.titleLabel?.lineBreakMode = .byClipping
            wayfindrBt.titleLabel?.baselineAdjustment = .alignCenters
            fingerprintingBt.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            fingerprintingBt.titleLabel?.adjustsFontSizeToFitWidth = true
            fingerprintingBt.titleLabel?.lineBreakMode = .byWordWrapping
        } else {
            // Fallback on earlier versions
        }
    }
}
