//
//  DBManager.swift
//  Wayfindr Demo
//
//  Created by Technosite on 11/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit
import FMDB

class DBManager: NSObject {
    
    //MARK: - Static Field Names
    
    let tableName_Accesibility = "Accesibility"
    let field_Accesibility_AccType = "Acc_Type"
    let field_Accesibility_Name = "Name"
    
    let tableName_Beacons = "Beacon"
    let field_Beacons_ID = "ID"
    let field_Beacons_Major = "Major"
    let field_Beacons_Minor = "Minor"
    let field_Beacons_MAC = "MAC"
    
    let tableName_BeaconsFingerprints = "Beacons_Fingerprints"
    let field_BeaconsFingerprints_IDFP = "ID_FP"
    let field_BeaconsFingerprints_IDBeacon = "ID_Beacon"
    let field_BeaconsFingerprints_RSSI = "RSSI"
    
    let tableName_Fingerprints = "Fingerprints"
    let field_Fingerprints_ID = "ID"
    let field_Fingerprints_x = "x"
    let field_Fingerprints_y = "y"
    let field_Fingerprints_z = "z"
    
    let tableName_Instructions = "Instructions"
    let field_Instructions_idInstructions = "idInstructions"
    let field_Instructions_idStep = "idStep"
    let field_Instructions_idType = "idType"
    let field_Instructions_Instruction = "Instruction"
    
    let tableName_InstructionsType = "Instructions_type"
    let field_InstructionsType_idType = "idType"
    let field_InstructionsType_Type = "Type"
    
    let tableName_Link = "Link"
    let field_Link_ID = "ID"
    let field_Link_InitNode = "InitNode"
    let field_Link_EndNode = "EndNode"
    let field_Link_Weight = "Weight"
    let field_Link_Bidirectional = "Bidirectional"
    
    let tableName_LinkAccesibility = "Link_Accesibility"
    let field_LinkAccesibility_Acc_Type = "Acc_Type"
    let field_LinkAccesibility_Link = "Link"
    
    let tableName_Node = "Node"
    let field_Node_ID = "ID"
    let field_Node_x = "x"
    let field_Node_y = "y"
    let field_Node_z = "z"
    let field_Node_WPType = "WP_Type"
    let field_Node_Name = "Name"
    let field_Node_Description = "Description"
    
    let tableName_Route = "Route"
    let field_Route_idRoute = "idRoute"
    let field_Route_Name = "Name"
    
    let tableName_RouteNodes = "Route_nodes"
    let field_RouteNodes_idStep = "idStep"
    let field_RouteNodes_idRoute = "idRoute"
    let field_RouteNodes_idNodeStart = "Id_Node_S"
    let field_RouteNodes_idNodeEnd = "Id_Node_E"
    let field_RouteNodes_Order = "OrderPos"
    
    let table_WPType = "WPType"
    let field_WPType_WPType = "WP_Type"
    let field_WPType_Name = "Name"
    
    //MARK: - Variables
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "LasArenas.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        database = FMDatabase(path: pathToDatabase!)
    }
    
    //MARK: - Create DB
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) && database != nil {
            // Open the database.
            if database.open() {
                let createAccesibilityTable = "CREATE TABLE \(tableName_Accesibility) (\(field_Accesibility_AccType) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Accesibility_Name) VARCHAR)"
                let createBeaconsTable = "CREATE TABLE \(tableName_Beacons) (\(field_Beacons_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Beacons_Major) INTEGER, \(field_Beacons_Minor) INTEGER, \(field_Beacons_MAC) VARCHAR)"
                let createBeaconFingerprintsTable = "CREATE TABLE \(tableName_BeaconsFingerprints) (\(field_BeaconsFingerprints_IDFP) INTEGER REFERENCES Fingerprints (\(field_Fingerprints_ID)), \(field_BeaconsFingerprints_IDBeacon) INTEGER REFERENCES Beacons (\(field_Beacons_ID)), \(field_BeaconsFingerprints_RSSI) DOUBLE)"
                let createFingerprintsTable = "CREATE TABLE \(tableName_Fingerprints) (\(field_Fingerprints_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Fingerprints_x) DOUBLE, \(field_Fingerprints_y) DOUBLE, \(field_Fingerprints_z) DOUBLE)"
                let createInstructionsTable = "CREATE TABLE \(tableName_Instructions) (\(field_Instructions_idInstructions) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Instructions_idStep) INTEGER REFERENCES Route_nodes (\(field_RouteNodes_idStep)), \(field_Instructions_idType) INTEGER REFERENCES Instructions_type (\(field_Instructions_idType)), \(field_Instructions_Instruction) VARCHAR)"
                let createInstructionsTypeTable = "CREATE TABLE \(tableName_InstructionsType) (\(field_InstructionsType_idType) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_InstructionsType_Type) VARCHAR)"
                let createLinkTable = "CREATE TABLE \(tableName_Link) (\(field_Link_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Link_InitNode) INTEGER REFERENCES Node (\(field_Node_ID)), \(field_Link_EndNode) INTEGER REFERENCES Node (\(field_Node_ID)), \(field_Link_Weight) DOUBLE, \(field_Link_Bidirectional) SMALLINT)"
                let createLinkAccesibilityTable = "CREATE TABLE \(tableName_LinkAccesibility) (\(field_LinkAccesibility_Acc_Type) INTEGER REFERENCES Accesibility (\(field_Accesibility_AccType)), \(field_LinkAccesibility_Link) INTEGER REFERENCES Link (\(field_Link_ID)))"
                let createNodeTable = "CREATE TABLE \(tableName_Node) (\(field_Node_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Node_x) DOUBLE, \(field_Node_y) DOUBLE, \(field_Node_z) DOUBLE, \(field_Node_WPType) INTEGER REFERENCES WPType (\(field_WPType_WPType)), \(field_Node_Name) VARCHAR, \(field_Node_Description) VARCHAR)"
                let createRouteTable = "CREATE TABLE \(tableName_Route) (\(field_Route_idRoute) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_Route_Name) VARCHAR)"
                let createRouteNodesTable = "CREATE TABLE \(tableName_RouteNodes) (\(field_RouteNodes_idStep) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_RouteNodes_idRoute) INTEGER REFERENCES Route (\(field_Route_idRoute)), \(field_RouteNodes_idNodeStart) INTEGER REFERENCES \(tableName_Node) (\(field_Node_ID)), \(field_RouteNodes_idNodeEnd) INTEGER REFERENCES \(tableName_Node) (\(field_Node_ID)), \(field_RouteNodes_Order) INTEGER)"
                let createWPTypeTable = "CREATE TABLE \(table_WPType) (\(field_WPType_WPType) INTEGER PRIMARY KEY AUTOINCREMENT, \(field_WPType_Name) VARCHAR)"
                
                do {
                    try database.executeUpdate(createAccesibilityTable, values: nil)
                    try database.executeUpdate(createBeaconsTable, values: nil)
                    try database.executeUpdate(createBeaconFingerprintsTable, values: nil)
                    try database.executeUpdate(createFingerprintsTable, values: nil)
                    try database.executeUpdate(createInstructionsTable, values: nil)
                    try database.executeUpdate(createInstructionsTypeTable, values: nil)
                    try database.executeUpdate(createLinkTable, values: nil)
                    try database.executeUpdate(createLinkAccesibilityTable, values: nil)
                    try database.executeUpdate(createNodeTable, values: nil)
                    try database.executeUpdate(createRouteTable, values: nil)
                    try database.executeUpdate(createRouteNodesTable, values: nil)
                    try database.executeUpdate(createWPTypeTable, values: nil)
                    
                    created = true
                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                }
            }
            else {
                print("Could not open the database.")
            }
        }
        return created
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func deleteDatabase() {
        if database != nil {
            if database.open() {
                let query = "drop database \(databaseFileName);"
                database.executeStatements(query)
                print("Drop DB")
            }
        }
    }
    
    // MARK: - Beacons
    
    func insertBeaconsData() {
        if openDatabase() {
            if let pathToBeaconsFile = Bundle.main.path(forResource: "Beacons", ofType: "txt") {
                do {
                    let beaconsFileContents = try String(contentsOfFile: pathToBeaconsFile)
                    let beaconsData = beaconsFileContents.components(separatedBy: "\n")
                    
                    var query = ""
                    for beacon in beaconsData {
                        let beaconsParts = beacon.components(separatedBy: "|")
                        
                        if beaconsParts.count == 3 {
                            let beaconID = beaconsParts[0]
                            let major = beaconsParts[1]
                            let minor = beaconsParts[2]
                            
                            query += "insert into \(tableName_Beacons) (\(field_Beacons_ID), \(field_Beacons_Major), \(field_Beacons_Minor)) values ('\(beaconID)', '\(major)', '\(minor)');"
                        }
                    }
                    if !database.executeStatements(query) {
                        print("BEACONS: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    func loadBeacons() -> [Beacon]! {
        var beacons: [Beacon]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Beacons) order by \(field_Beacons_ID) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let beacon = Beacon(beaconID: Int(results.int(forColumn: field_Beacons_ID)),
                                        major: Int(results.int(forColumn: field_Beacons_Major)),
                                        minor: Int(results.int(forColumn: field_Beacons_Minor)))
                    
                    if beacons == nil {
                        beacons = [Beacon]()
                    }
                    
                    beacons.append(beacon)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return beacons
    }
    
    // MARK: - BeaconsFingerprints
    
    func loadBeaconsFingerprints() -> [BeaconFingerprint]! {
        var beaconsFingerprints: [BeaconFingerprint]!
        
        if openDatabase() {
            let query = "select * from \(tableName_BeaconsFingerprints) order by \(field_BeaconsFingerprints_IDFP) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let beaconFingerprint = BeaconFingerprint(beaconFingerprintID: Int(results.int(forColumn: field_BeaconsFingerprints_IDFP)),
                                                              beaconID: Int(results.int(forColumn: field_BeaconsFingerprints_IDBeacon)),
                                                              rssi: Double(results.int(forColumn: field_BeaconsFingerprints_RSSI)))
                    
                    if beaconsFingerprints == nil {
                        beaconsFingerprints = [BeaconFingerprint]()
                    }
                    
                    beaconsFingerprints.append(beaconFingerprint)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return beaconsFingerprints
    }
    
    // MARK: - Fingerprints
    
    func insertFingerprintsData() {
        if openDatabase() {
            if let pathToFingerprintsFile = Bundle.main.path(forResource: "Fingerprints", ofType: "txt") {
                do {
                    let fingerprintsFileContents = try String(contentsOfFile: pathToFingerprintsFile)
                    
                    let fingerprintsData = fingerprintsFileContents.components(separatedBy: "\n")
                    
                    var queryFingerprint = ""
                    var queryBeaconsFingerprints = ""
                    for fingerprint in fingerprintsData {
                        if fingerprint != "" {
                            let fingerprintParts = fingerprint.components(separatedBy: "|")
                            
                            if fingerprintParts.count == 120 {
                                
                                let fingerprintID = fingerprintParts[0]
                                let x = fingerprintParts[2]
                                let y = fingerprintParts[1]
                                let z = 0
                                
                                queryFingerprint += "insert into \(tableName_Fingerprints) (\(field_Fingerprints_ID), \(field_Fingerprints_x), \(field_Fingerprints_y), \(field_Fingerprints_z)) values ('\(fingerprintID)', '\(x)', '\(y)', '\(z)');"
                                
                                /*var beaconID = 0
                                for index in 3 ..< fingerprintParts.count{
                                    beaconID += 1
                                    let rssi = fingerprintParts[index]
                                    
                                    queryBeaconsFingerprints += "insert into \(tableName_BeaconsFingerprints) (\(field_BeaconsFingerprints_IDFP), \(field_BeaconsFingerprints_IDBeacon), \(field_BeaconsFingerprints_RSSI)) values ('\(fingerprintID)', '\(beaconID)', '\(rssi)');"
                                }*/
                            }
                        }
                    }
                    
                    if !database.executeStatements(queryFingerprint) || !database.executeStatements(queryBeaconsFingerprints) {
                        print("FINGERPRINTS: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    func loadFingerprints() -> [Fingerprint]! {
        var fingerprints: [Fingerprint]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Fingerprints) order by \(field_Fingerprints_ID) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let fingerprint = Fingerprint(fingerprintID: Int(results.int(forColumn: field_Fingerprints_ID)),
                                                  x: Double(results.double(forColumn: field_Fingerprints_x)),
                                                  y: Double(results.double(forColumn: field_Fingerprints_y)),
                                                  z: Double(results.double(forColumn: field_Fingerprints_z)))
                    
                    if fingerprints == nil {
                        fingerprints = [Fingerprint]()
                    }
                    
                    fingerprints.append(fingerprint)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return fingerprints
    }
    
    func loadFingerprintByID (ID: Int) -> Fingerprint {
        var fingerprint: Fingerprint?
        
        if openDatabase() {
            let query = "select * from \(tableName_Fingerprints) where \(field_Fingerprints_ID)=?"
            
            do {
                let results = try database.executeQuery(query, values: [ID])
                
                while results.next() {
                    fingerprint = Fingerprint(fingerprintID: Int(results.int(forColumn: field_Fingerprints_ID)),
                                              x: Double(results.double(forColumn: field_Fingerprints_x)),
                                              y: Double(results.double(forColumn: field_Fingerprints_y)),
                                              z: Double(results.double(forColumn: field_Fingerprints_z)))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return fingerprint!
    }
    
    // MARK: - Instructions
    
    func loadInstructions() -> [Instruction]! {
        var instructions: [Instruction]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Instructions) order by \(field_Instructions_idStep) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let instruction = Instruction(instructionID: Int(results.int(forColumn: field_Instructions_idInstructions)),
                                                  stepID: Int(results.int(forColumn: field_Instructions_idStep)),
                                                  type: Int(results.int(forColumn: field_Instructions_idType)),
                                                  instruction: results.string(forColumn: field_Instructions_Instruction)!)
                    
                    if instructions == nil {
                        instructions = [Instruction]()
                    }
                    
                    instructions.append(instruction)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return instructions
    }
    
    func loadInstruction(startNodeID: Int, endNodeId: Int, routeID: Int, Type: Int) -> String? {
        var stepID: String?
        var instruction: String?
        
        if openDatabase() {
            let query = "select \(field_RouteNodes_idStep) from \(tableName_RouteNodes) where \(field_RouteNodes_idNodeStart)=? and \(field_RouteNodes_idNodeEnd)=? and \(field_Route_idRoute)=?"
            
            do {
                let results = try database.executeQuery(query, values: [startNodeID, endNodeId, routeID])
                
                while results.next() {
                    stepID = results.string(forColumn: field_RouteNodes_idStep)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            let queryInstruction = "select \(field_Instructions_Instruction) from \(tableName_Instructions) where \(field_Instructions_idStep)=? and \(field_Instructions_idType)=?"
            
            do {
                let results = try database.executeQuery(queryInstruction, values: [stepID, Type])
                
                while results.next() {
                    instruction = results.string(forColumn: field_Instructions_Instruction)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return instruction
    }
    
    
    // MARK: - InstructionsType
    
    func insertInstructionsTypeData() {
        if openDatabase() {
            if let pathToInstructionsFile = Bundle.main.path(forResource: "InstructionsType", ofType: "txt") {
                do {
                    let instructionsFileContents = try String(contentsOfFile: pathToInstructionsFile)
                    
                    let instructionsData = instructionsFileContents.components(separatedBy: "\n")
                    
                    var query = ""
                    for instruction in instructionsData {
                        let instructionParts = instruction.components(separatedBy: "|")
                        
                        if instructionParts.count == 2 {
                            let idType = instructionParts[0]
                            let type = instructionParts[1]
                            
                            query += "insert into \(tableName_InstructionsType) (\(field_InstructionsType_idType), \(field_InstructionsType_Type)) values ('\(idType)', '\(type)');"
                        }
                    }
                    
                    if !database.executeStatements(query) {
                        print("INSTRUCTIONS: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    // MARK: - Links
    
    func insertLinksData() {
        if openDatabase() {
            if let pathToLinksFile = Bundle.main.path(forResource: "Links", ofType: "txt") {
                do {
                    let linksFileContents = try String(contentsOfFile: pathToLinksFile)
                    
                    let linksData = linksFileContents.components(separatedBy: "\n")
                    
                    var query = ""
                    for link in linksData {
                        let linksParts = link.components(separatedBy: "|")
                        
                        if linksParts.count == 3 {
                            let linkID = linksParts[0]
                            let initNode = linksParts[1]
                            let endNode = linksParts[2]
                            
                            query += "insert into \(tableName_Link) (\(field_Link_ID), \(field_Link_InitNode), \(field_Link_EndNode)) values ('\(linkID)', '\(initNode)', '\(endNode)');"
                        }
                    }
                    
                    if !database.executeStatements(query) {
                        print("LINKS: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    func loadLinks() -> [Link]! {
        var links: [Link]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Link) order by \(field_Link_ID) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let link = Link(linkID: Int(results.int(forColumn: field_Link_ID)),
                                    initNode: Int(results.int(forColumn: field_Link_InitNode)),
                                    endNode: Int(results.int(forColumn: field_Link_EndNode)))
                    
                    if links == nil {
                        links = [Link]()
                    }
                    
                    links.append(link)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return links
    }
    
    // MARK: - Nodes
    
    func insertNodesData() {
        if openDatabase() {
            if let pathToNodesFile = Bundle.main.path(forResource: "Nodes", ofType: "txt") {
                do {
                    let nodesFileContents = try String(contentsOfFile: pathToNodesFile)
                    
                    let nodesData = nodesFileContents.components(separatedBy: "\n")
                    var query = ""
                    for node in nodesData {
                        let nodesParts = node.components(separatedBy: "|")
                        
                        if nodesParts.count == 4 {
                            let nodeID = nodesParts[0]
                            let x = nodesParts[1]
                            let y = nodesParts[2]
                            let z = nodesParts[3]
                            
                            query += "insert into \(tableName_Node) (\(field_Node_ID), \(field_Node_x), \(field_Node_y), \(field_Node_z)) values ('\(nodeID)', '\(x)', '\(y)', '\(z)');"
                        }
                    }
                    
                    if !database.executeStatements(query) {
                        print("NODES: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    func loadNodes() -> [Node]! {
        var nodes: [Node]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Node) order by \(field_Node_ID) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let node = Node(nodeID: Int(results.int(forColumn: field_Node_ID)),
                                    x: Double(results.double(forColumn: field_Node_x)),
                                    y: Double(results.double(forColumn: field_Node_y)),
                                    z: Double(results.double(forColumn: field_Node_z)))
                    
                    
                    if nodes == nil {
                        nodes = [Node]()
                    }
                    
                    nodes.append(node)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return nodes
    }
    
    func loadNodesByRoute(route: Int) -> [Node]! {
        var nodes: [Node]!
        var nodeIDs = Set<String>()
        
        if openDatabase() {
            let query = "select * from \(tableName_RouteNodes) where \(field_RouteNodes_idRoute)=? order by \(field_RouteNodes_Order) asc"
            
            do {
                print("LOAD NODES BY ROUTE QUERY in: \(database)")
                let results = try database.executeQuery(query, values: [route])
                
                while results.next() {
                    let nodeStartID = results.string(forColumn: field_RouteNodes_idNodeStart)
                    let nodeEndID = results.string(forColumn: field_RouteNodes_idNodeEnd)
                    
                    nodeIDs.insert(nodeStartID!)
                    nodeIDs.insert(nodeEndID!)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            for nodeID in nodeIDs {
                
                let queryNodes = "select * from \(tableName_Node) where \(field_Node_ID)=?"
                
                do {
                    let results = try database.executeQuery(queryNodes, values: [nodeID])
                    
                    while results.next() {
                        let node = Node(nodeID: Int(results.int(forColumn: field_Node_ID)),
                                        x: Double(results.double(forColumn: field_Node_x)),
                                        y: Double(results.double(forColumn: field_Node_y)),
                                        z: Double(results.double(forColumn: field_Node_z)))
                        
                        
                        if nodes == nil {
                            nodes = [Node]()
                        }
                        
                        nodes.append(node)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
            
            database.close()
        }
        
        return nodes
    }
    
    
    
    func loadStartNode(routeID: Int, order: Int) -> Node {
        var node: Node!
        
        if openDatabase() {
            let query = "select \(field_RouteNodes_idNodeStart) from \(tableName_RouteNodes) where \(field_RouteNodes_idRoute)=? and \(field_RouteNodes_Order)=?"
            var nodeID = ""
            
            do {
                let results = try database.executeQuery(query, values: [routeID, order])
                
                while results.next() {
                    nodeID = results.string(forColumn: field_RouteNodes_idNodeStart)!
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            let queryNode = "select * from \(tableName_Node) where \(field_Node_ID)=?"
            
            do {
                let resultsNode = try database.executeQuery(queryNode, values: [nodeID])
                
                while resultsNode.next() {
                    node = Node(nodeID: Int(resultsNode.int(forColumn: field_Node_ID)),
                                x: Double(resultsNode.double(forColumn: field_Node_x)),
                                y: Double(resultsNode.double(forColumn: field_Node_y)),
                                z: Double(resultsNode.double(forColumn: field_Node_z)))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return node
    }
    
    func loadEndNode(routeID: Int, startNodeID: Int) -> Node {
        var node: Node?
        var nodeID = ""
        
        if openDatabase() {
            let query = "select \(field_RouteNodes_idNodeEnd) from \(tableName_RouteNodes) where \(field_RouteNodes_idRoute)=? and \(field_RouteNodes_idNodeStart)=?"
            
            do {
                let results = try database.executeQuery(query, values: [routeID, startNodeID])
                
                while results.next() {
                    nodeID = results.string(forColumn: field_RouteNodes_idNodeEnd)!
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            let queryNode = "select * from \(tableName_Node) where \(field_Node_ID)=?"
            
            do {
                print(database)
                let resultsNode = try database.executeQuery(queryNode, values: [nodeID])
                
                while resultsNode.next() {
                    node = Node(nodeID: Int(resultsNode.int(forColumn: field_Node_ID)),
                                x: Double(resultsNode.double(forColumn: field_Node_x)),
                                y: Double(resultsNode.double(forColumn: field_Node_y)),
                                z: Double(resultsNode.double(forColumn: field_Node_z)))
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            if node == nil {
                let queryNode = "select * from \(tableName_Node) where \(field_Node_ID)=?"
                
                do {
                    print(database)
                    let resultsNode = try database.executeQuery(queryNode, values: [startNodeID])
                    
                    while resultsNode.next() {
                        node = Node(nodeID: Int(resultsNode.int(forColumn: field_Node_ID)),
                                    x: Double(resultsNode.double(forColumn: field_Node_x)),
                                    y: Double(resultsNode.double(forColumn: field_Node_y)),
                                    z: Double(resultsNode.double(forColumn: field_Node_z)))
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
        return node!
    }
    
    func loadEndNodeFromRoute(routeID: Int) -> Int {
        var nodeID: Int?
        
        if openDatabase() {
            let query = "select \(field_RouteNodes_idNodeEnd) from \(tableName_RouteNodes) where \(field_RouteNodes_idRoute)=? order by \(field_RouteNodes_idStep) asc"
            
            do {
                let results = try database.executeQuery(query, values: [routeID])
                
                while results.next() {
                    nodeID = Int(results.string(forColumn: field_RouteNodes_idNodeEnd)!)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return nodeID!
    }
    
    // MARK: - Routes
    
    func insertRoutesData() {
        if openDatabase() {
            if let pathToRoutesFile = Bundle.main.path(forResource: "Routes", ofType: "txt") {
                do {
                    let routesFileContents = try String(contentsOfFile: pathToRoutesFile)
                    
                    let routesData = routesFileContents.components(separatedBy: "\n")
                    
                    var queryRoute = ""
                    var queryRouteNodes = ""
                    var queryStart = ""
                    var queryDistance = ""
                    var queryNear = ""
                    var routeIDAux = "0"
                    for route in routesData {
                        if route != "" {
                            let routesParts = route.components(separatedBy: "|")
                            
                            if routesParts.count == 9 {
                                
                                let routeID = routesParts[0]
                                let name = routesParts[1]
                                
                                if routeID != routeIDAux {
                                    queryRoute += "insert into \(tableName_Route) (\(field_Route_idRoute), \(field_Route_Name)) values ('\(routeID)', '\(name)');"
                                    routeIDAux = routeID
                                }
                                
                                let stepID = routesParts[2]
                                let nodeStartID = routesParts[3]
                                let nodeEndID = routesParts[4]
                                let order = routesParts[5]
                                
                                queryRouteNodes += "insert into \(tableName_RouteNodes) (\(field_RouteNodes_idStep), \(field_RouteNodes_idRoute), \(field_RouteNodes_idNodeStart), \(field_RouteNodes_idNodeEnd), \(field_RouteNodes_Order)) values ('\(stepID)', '\(routeID)', '\(nodeStartID)', '\(nodeEndID)', '\(order)');"
                                
                                let startInstruction = routesParts[6]
                                let distanceInstruction = routesParts[7]
                                let nearInstruction = routesParts[8]
                                
                                if startInstruction != "" {
                                    queryStart += "insert into \(tableName_Instructions) (\(field_Instructions_idStep), \(field_Instructions_idType), \(field_Instructions_Instruction)) values ('\(routesParts[2])', '0', '\(startInstruction)');"
                                }
                                if distanceInstruction != "" {
                                    queryDistance += "insert into \(tableName_Instructions) (\(field_Instructions_idStep), \(field_Instructions_idType), \(field_Instructions_Instruction)) values ('\(routesParts[2])', '1', '\(distanceInstruction)');"
                                }
                                if nearInstruction != "" {
                                    queryNear += "insert into \(tableName_Instructions) (\(field_Instructions_idStep), \(field_Instructions_idType), \(field_Instructions_Instruction)) values ('\(routesParts[2])', '2', '\(nearInstruction)');"
                                }
                                
                            }
                        }
                    }
                    
                    if !database.executeStatements(queryRoute) || !database.executeStatements(queryRouteNodes) || !database.executeStatements(queryStart) || !database.executeStatements(queryDistance) || database.executeStatements(queryNear) {
                        print("ROUTES: Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
        
    }
    
    func loadRoutes() -> [Route]! {
        var routes: [Route]!
        
        if openDatabase() {
            let query = "select * from \(tableName_Route) order by \(field_Route_idRoute) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let route = Route(routeID: Int(results.int(forColumn: field_Route_idRoute)),
                                      name: results.string(forColumn: field_Route_Name)!)
                    
                    if routes == nil {
                        routes = [Route]()
                    }
                    
                    routes.append(route)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return routes
    }
    
    // MARK: - RouteNode
    
    func loadRoutesNodes() -> [RouteNode]! {
        var routesNodes: [RouteNode]!
        
        if openDatabase() {
            let query = "select * from \(tableName_RouteNodes) order by \(field_RouteNodes_idRoute) asc"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let routeNode = RouteNode(stepID: Int(results.int(forColumn: field_RouteNodes_idStep)),
                                              routeID: Int(results.int(forColumn: field_RouteNodes_idRoute)),
                                              nodeStartID: Int(results.int(forColumn: field_RouteNodes_idNodeStart)),
                                              nodeEndID: Int(results.int(forColumn: field_RouteNodes_idNodeEnd)),
                                              order: Int(results.int(forColumn: field_RouteNodes_Order)))
                    
                    if routesNodes == nil {
                        routesNodes = [RouteNode]()
                    }
                    
                    routesNodes.append(routeNode)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return routesNodes
    }
}
