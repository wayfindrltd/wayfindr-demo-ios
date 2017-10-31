//
//  OrquestratorViewController.swift
//  Wayfindr Demo
//
//  Created by Technosite on 11/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import CoreLocation
import MessageUI
import FingerprintSearch


@available(iOS 10.0, *)
class OrquestratorViewController: UIViewController, ITBeepconsLocatorDelegate, ITBeepconsManagerDelegate, UNUserNotificationCenterDelegate, MFMailComposeViewControllerDelegate {
	
	//MARK: - Outlets
	
	@IBOutlet weak var instructionsLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var stopBt: UIButton!
	
	
	//MARK: - Variables
	
	var instructionsDistance = UserDefaults.standard.integer(forKey: "Instruction of distance")
	var nearInstructions = UserDefaults.standard.integer(forKey: "Near instructions")
	var assignationDistance: Int = UserDefaults.standard.integer(forKey: "Assignation distance")
	var precision = UserDefaults.standard.double(forKey: "Precision")
	var route = UserDefaults.standard.object(forKey: "Route") as! String!
    var routeID: Int!
	var locator = UserDefaults.standard.double(forKey: "Locator")
	var scanningTime = UserDefaults.standard.integer(forKey: "Scanning time")
	var k = UserDefaults.standard.integer(forKey: "K")
	var weight = UserDefaults.standard.integer(forKey: "Weight")
	var maxAccuracy = UserDefaults.standard.integer(forKey: "Max Accuracy")
	var minAccuracy = UserDefaults.standard.integer(forKey: "Min Accuracy")
    var smooth = UserDefaults.standard.float(forKey: "Smooth")
    let width = DBManager.shared.loadBeacons().count + 3
    let height = DBManager.shared.loadFingerprints().count
	
	var timer: Timer!
    let initialNode = Node(nodeID: 0, x: 0, y: 0, z: 0)
	var stopThread = false
    var index = -1
    var currentFingerprint = Fingerprint(fingerprintID: -1, x: 0, y: 0, z: 0)
    var obtainedFingerprint: Fingerprint?
    var currentNode: Node!
    var endNode: Node!
    var nodes: [Node]!
    var finalNodeID: Int = 0
    var eucledianDistance: Double = 0.0
    var angle: Double = 0.0
    var flagRecalculated = false
    var previousNode: Node?
    var orquestrator: Orquestrator?
    var instructionsText: String?
    var instructionGenerator: InstructionGenerator?
    var instructionGenerated: String?
    var instructionDistance = false
    var nearInstruction = false
    var locali: Locali?
    var arrayFingerprints = [[Float]]()
	
	var beepconsLocator:ITBeepconsLocator?
	var beepconsManager:ITBeepconsManager?
	var startLocation = false
	var arrayBeepcons = [ITFoundedBeepcon]()
    var newArrayBeepcon = [beepcons]()
	
	let center = UNUserNotificationCenter.current()
	let locationManager = CLLocationManager()
    let mail = MFMailComposeViewController()
    let log = Log()
	
	//MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAccessibility()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
		
		UNUserNotificationCenter.current().delegate = self
        
		setUpInitialValues()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(locator), target: self, selector: #selector(OrquestratorViewController.searchLocation),userInfo: nil, repeats: false)
    }
	
	override func viewWillDisappear(_ animated : Bool) {
		super.viewWillDisappear(animated)
		
		if self.isMovingFromParentViewController {
			stopScanInterval()
			stopThread = true
            NotificationCenter.default.removeObserver(self)
		}
	}
	
	// MARK: - Main Function
    
    func setUpInitialValues() {
        routeID = getRouteID(nameRoute: route!)
        currentNode = DBManager.shared.loadStartNode(routeID: routeID, order: 1)
        endNode	= DBManager.shared.loadEndNode(routeID: routeID, startNodeID: (currentNode.nodeID))
        finalNodeID = DBManager.shared.loadEndNodeFromRoute(routeID: routeID)
        nodes = DBManager.shared.loadNodesByRoute(route: routeID)
        
        instructionGenerator = InstructionGenerator(previousNode: initialNode, currentNode: currentNode, destinationNode: endNode,
                                                    eucledianDistance: eucledianDistance, flagRecalculated: false, nearInstruction: false,
                                                    instructionDistance: false, fingerprint: currentFingerprint, routeID: routeID, angle: angle)
        
        if beepconsLocator == nil {
            beepconsLocator = ITBeepconsLocator(delegate: self)
        }
        
        if beepconsManager == nil {
            beepconsManager = ITBeepconsManager(delegate: self)
        }
        
        instructionsLabel.text = instructionGenerator?.generateInstruction()
        subTitleLabel.text = "Ruta: \(route!)"

        
        locali = Locali(width: self.width, height: self.height, last_finger: 1, smooth: self.smooth, mayor: 1019, k: self.k, m: 1, numero_datos: self.arrayBeepcons.count)
        
        arrayFingerprints = (locali?.create2DArray(height: self.height, width: self.width))!
        
        log.deleteLog()
    }
	
    func searchLocation() {
		if stopThread != true {
            scanBeepcons()
		}
	}
    
    func obtainInstruction(newFingerprintID: Int) {
        self.index += 1
        self.calculateRoute(newFingerprintID: newFingerprintID)
        if self.orquestrator?.currentNode != nil {
            self.generateInstruction()
            if self.orquestrator?.currentNode?.nodeID == self.finalNodeID {
                self.stopThread = true
                _ = Timer.scheduledTimer(timeInterval: TimeInterval(2.0), target: self, selector: #selector(OrquestratorViewController.showEndAlertToSendLog),userInfo: nil, repeats: false)
            }
        } else {
            self.setNewValues(orquestrator: self.orquestrator!)
        }
        
        if instructionsText == ConstantsStrings.instructions.error {
            let router = Router(currentFingerprint: (instructionGenerator?.fingerprint)!,
                                newFingerprint: obtainedFingerprint!,
                                currentNode: (instructionGenerator?.currentNode)!,
                                destinationNode: (instructionGenerator?.destinationNode)!,
                                nodes: nodes,
                                routeID: routeID,
                                currentEucledianDistance: eucledianDistance)
            if router.checkifNodeExist(checkedNode: currentNode) {
                self.instructionsText = "You are in route again"
            }
        }
        
        if UIApplication.shared.applicationState == .active {
            if self.instructionsText != "" && self.instructionsText != self.instructionsLabel.text && self.instructionsText != nil {
                self.instructionsLabel.text = self.instructionsText
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.instructionsText)
            }
        }
        if UIApplication.shared.applicationState == .background {
            if self.instructionsText != "" && self.instructionsText != self.instructionsLabel.text && self.instructionsText != nil {
                self.sendNotification(index: self.index)
            }
        }
        
        if self.stopThread != true {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.locator), target: self, selector: #selector(OrquestratorViewController.searchLocation),userInfo: nil, repeats: false)
        }
    }
    
    func searchBeepcons() {
        scanBeepcons()
    }
    
    func searchFingerprint() -> Int {
        let newFingerprintID = self.locali?.main_locali(width: width, height: height, last_finger: currentFingerprint.fingerprintID, smooth: self.smooth, mayor: 1019, k: self.k, m: 1, finger_print: self.arrayFingerprints, numero_datos: self.newArrayBeepcon.count, beepcons_data: self.newArrayBeepcon)
        
        return newFingerprintID!
    }
    
    func calculateRoute(newFingerprintID: Int) {
        
        obtainedFingerprint = DBManager.shared.loadFingerprintByID(ID: newFingerprintID)
        var router = Router(currentFingerprint: (instructionGenerator?.fingerprint)!,
                            newFingerprint: obtainedFingerprint!,
                            currentNode: (instructionGenerator?.currentNode)!,
                            destinationNode: (instructionGenerator?.destinationNode)!,
                            nodes: nodes,
                            routeID: routeID,
                            currentEucledianDistance: eucledianDistance)
        
        orquestrator = router.checkFingerprint()
    }
    
    func generateInstruction() {
        currentFingerprint = obtainedFingerprint!
        previousNode = instructionGenerator?.currentNode
        currentNode = orquestrator?.currentNode!
        endNode = orquestrator?.destinationNode!
        eucledianDistance = (orquestrator?.eucledianDistance)!
        flagRecalculated = (orquestrator?.flagRecalculated)!
        angle = (orquestrator?.angle)!
        
        instructionGenerator = InstructionGenerator(previousNode: previousNode!, currentNode: currentNode, destinationNode: endNode,
                                                    eucledianDistance: eucledianDistance, flagRecalculated: (orquestrator?.flagRecalculated)!, nearInstruction: nearInstruction,
                                                    instructionDistance: instructionDistance, fingerprint: obtainedFingerprint!, routeID: routeID, angle: angle)
        
        instructionsText = instructionGenerator?.generateInstruction()
        if instructionsText == nil {
            instructionsText = instructionsLabel.text
        }
        
        instructionDistance = (instructionGenerator?.getInstructionDistance())!
        nearInstruction = (instructionGenerator?.getNearInstruction())!
    }
    
    func setNewValues(orquestrator: Orquestrator) {
        currentFingerprint = obtainedFingerprint!
        currentNode = instructionGenerator?.currentNode
        endNode = instructionGenerator?.destinationNode
        eucledianDistance = orquestrator.eucledianDistance
        flagRecalculated = orquestrator.flagRecalculated
        instructionsText = instructionsLabel.text!
    }
    
    func sendNotification(index: Int){
        let content = UNMutableNotificationContent()
        content.body = self.instructionsText!
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let identifier = "Notificacion_\(index)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        self.center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("NO HA ENVIADO LA NOTIFICACION")
            }
        })
    }
    
    func setLabelText() {
        self.instructionsLabel.text = "MIRA TÚ QUÉ BIEN"
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
	
	// MARK: - IBActions
	
	@IBAction func stopRoute(_ sender: Any) {
		stopThread = true
		stopScanInterval()
        
        self.showAlertToSendLog()
	}
	
	// MARK: - ITBeepconsLocatorDelegate
	
	public func itBeepconsLocatorDidStartLocating(_ thislocator: Any!, withRegionIdentifier identifier: String!) {
		
		
	}
	public func itBeepconsLocatorDidExitRegion(_ thislocator: Any!, withRegionIdentifier identifier: String!) {
        
	}
	public func itBeepconsLocatorDidAuthorizationChanged(_ thislocator: Any!) {
		
	}
	public func itBeepconsLocatorDidEnterRegion(_ thislocator: Any!, withRegionIdentifier identifier: String!) {

    }
	public func itBeepconsLocatorDidFailedStartLocating(_ thislocator: Any!, withRegionIdentifier identifier: String!, error: Error!) {
		
	}
	public func itBeepconsLocatorDidStopLocating(_ thislocator: Any!, withRegionIdentifier identifier: String!) {
		
	}
	public func itBeepconsLocatorDidStopReporting(_ thislocator: Any!, withRegionIdentifier identifier: String!) {
		
	}
	public func itBeepconsLocatorDidFailedStartReporting(_ thislocator: Any!, withRegionIdentifier identifier: String!, error: Error!) {
		
	}
	public func itBeepconsLocatorDidStartReporting(_ thislocator: Any!, withRegionIdentifier identifier: String!) {
		
	}
	public func itBeepconsLocatorDidGetRegionStatusInformation(_ thislocator: Any!, withRegionIdentifier identifier: String!, status Status: Int32) {
		
	}
	public func itBeepconsLocatorReportingBeepcon(asIbeacon thislocator: Any!, withRegionIdentifier identifier: String!, major hiident: UInt32, minor loident: UInt32, rssi: Int32, accuracy Accuracy: Double, proximity: Int32) {
        var beepcon: beepcons?
        beepcon = beepcons(RSSI: Float(rssi), minor: Int(loident), mayor: Int(hiident), ACC: Float(Accuracy))
        newArrayBeepcon.append(beepcon!)
	}
    
    // MARK: - ITBeepconsManagerDelegate
    
    public func itBeepconsManagerDidStartScanning(_ thismanager: Any!) {
        
    }
    
    public func itBeepconsManagerDidStopScanning(_ thismanager: Any!) {
        
    }
    
    public func itBeepconsManagerReportingProgressMessage(_ thismanager: Any!, withMessage ProgressMessage: String!) {
        print("Progress Message: \(ProgressMessage)")
    }
	
	// MARK: - Beepcons
	
    func scanBeepcons(){
        if startLocation == false {
            if beepconsLocator != nil {
                if (beepconsManager?.statusAllowsScanning)! {
                    newArrayBeepcon.removeAll()
                    beepconsManager?.startScanningForPeripherals(withReport: true)
                    beepconsLocator?.startReportingBeepcons(withHiId: nil, lowId: nil, regionIdentifier: "ALLBEEPCONS")
                    startLocation = true
                    _ = Timer.scheduledTimer(timeInterval: TimeInterval(scanningTime), target: self, selector: #selector(OrquestratorViewController.stopScanInterval), userInfo: nil, repeats: false)
                }
            } else {
                showAlertBluetooth()
            }
        }
    }
    
    func stopScanInterval(){
        beepconsLocator?.stopReportingBeepcons(withRegionIdentifier: "ALLBEEPCONS")
        beepconsManager?.stopScanningForPeripherals()
        fillBeepconArray()
        startLocation = false
    }
    
    func fillBeepconArray() {
        if stopThread != true {
            if newArrayBeepcon.count > 0 {
                let fingerprintID = self.searchFingerprint()
                self.obtainInstruction(newFingerprintID: fingerprintID)
            } else {
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(locator), target: self, selector: #selector(OrquestratorViewController.searchLocation),userInfo: nil, repeats: false)
            }
        }
    }
	
	func stopLocalizacion(){
		if startLocation {
			beepconsLocator?.stopLocatingBeepcons(withRegionIdentifier: nil)
		}
	}
	
	// MARK: - Notification Delegate
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
	                            willPresent notification: UNNotification,
	                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert,.sound])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
	                            didReceive response: UNNotificationResponse,
	                            withCompletionHandler completionHandler: @escaping () -> Void) {
		
		switch response.actionIdentifier {
		case UNNotificationDismissActionIdentifier:
			print("Dismiss Action")
		case UNNotificationDefaultActionIdentifier:
			print("Default")
		default:
			print("Unknown action")
		}
		completionHandler()
	}
    
    // MARK: - Accessibility
    
    func applyAccessibility() {
        instructionsLabel.isAccessibilityElement = true
        subTitleLabel.isAccessibilityElement = true
        stopBt.isAccessibilityElement = true
        
        if #available(iOS 10.0, *) {
            instructionsLabel.font = UIFont.preferredFont(forTextStyle: .title1)
            instructionsLabel.adjustsFontForContentSizeCategory = true
            subTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
            subTitleLabel.adjustsFontForContentSizeCategory = true
            stopBt.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            stopBt.titleLabel?.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // MARK: - Alerts
    
    func showAlertToSendLog() {
        
        let dialogMessage = UIAlertController(title: "INFO", message: "Por favor envía la información de tu ruta para mejorar la experiencia", preferredStyle: .alert)

        let sendInfo = UIAlertAction(title: "Enviar", style: .default, handler: { (action) -> Void in
            self.sendEmailButtonTapped()
        })
        dialogMessage.addAction(sendInfo)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func showEndAlertToSendLog() {
        
        let dialogMessage = UIAlertController(title: "FIN DE LA RUTA", message: instructionsText! + "\n \n" + "Tu ruta ha finalizado. Por favor, envíe la información de su ruta para mejorar la experiencia.", preferredStyle: .alert)

        let sendInfo = UIAlertAction(title: "Enviar", style: .default, handler: { (action) -> Void in
            self.sendEmailButtonTapped()
            _ = self.navigationController?.popViewController(animated: true)
        })
        dialogMessage.addAction(sendInfo)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func showAlertBluetooth() {
        
        let dialogMessage = UIAlertController(title: "AVISO", message: "El Bluetooth de su dispositivo no está disponible. Por favor, compruébelo para poder comenzar a escanear beepcons", preferredStyle: .alert)

        let sendInfo = UIAlertAction(title: "Enviar", style: .default, handler: { (action) -> Void in
            self.sendEmailButtonTapped()
            _ = self.navigationController?.popViewController(animated: true)
        })
        dialogMessage.addAction(sendInfo)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Mail
    
    func sendEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let body = log.getLog()
            
            mail.mailComposeDelegate = self
            
            mail.setToRecipients(["xx@ilunion.com"])
            mail.setSubject("Route Info")
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "E-Mail No Enviado", message: "Su dispositivo no puede enviar e-mail. Por favor, compruebe la configuración de su e-mail y vuelva a intentarlo.", preferredStyle: .alert)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.string(from: date)
        
        return formatter.string(from: date)
    }
	
}

// MARK: - CLLocationManagerDelegate

@available(iOS 10.0, *)
extension OrquestratorViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
}
