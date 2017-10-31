//
//  DBStructs.swift
//  Wayfindr Demo
//
//  Created by Technosite on 12/9/17.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import UIKit

struct Accesibility {
	var accType: Int
	var name: String
}

struct Beacon {
	var beaconID: Int
	var major: Int
	var minor: Int
	var mac: Int?
	
	init(beaconID: Int, major: Int, minor: Int, mac: Int? = nil) {
		self.beaconID = beaconID
		self.major = major
		self.minor = minor
		self.mac = mac
	}
}

struct BeaconFingerprint {
	var beaconFingerprintID: Int
	var beaconID: Int
	var rssi: Double
}

struct Fingerprint {
	var fingerprintID: Int
	var x: Double
	var y: Double
	var z: Double
}

struct Instruction {
	var instructionID: Int
	var stepID: Int
	var type: Int
	var instruction: String
}

struct InstructionType {
	var typeID: Int
	var type: String
}

struct Link {
	var linkID: Int
	var initNode: Int
	var endNode: Int
	var weight: Double?
	var bidirectional: Int?
	
	init(linkID: Int, initNode: Int, endNode: Int, weight: Double? = nil, bidirectiontal: Int? = nil) {
		self.linkID = linkID
		self.initNode = initNode
		self.endNode = endNode
		self.weight = weight
		self.bidirectional = bidirectiontal
	}
}

struct LinkAccesibility {
	var accType: Int
	var link: Int
}

struct Node {
	var nodeID: Int
	var x: Double
	var y: Double
	var z: Double
	var wpType: Int?
	var name: String?
	var description: String?
	
	init(nodeID: Int, x: Double, y: Double, z: Double, wpType: Int? = nil, name: String? = nil, description: String? = nil) {
		self.nodeID = nodeID
		self.x = x
		self.y = y
		self.z = z
		self.wpType = wpType
		self.name = name
		self.description = description
	}
}

struct Route {
	var routeID: Int
	var name: String
}

struct RouteNode {
	var stepID: Int
	var routeID: Int
	var nodeStartID: Int
	var nodeEndID: Int
	var order: Int
}

struct WPType {
	var wpType: Int
	var name: Int
}
