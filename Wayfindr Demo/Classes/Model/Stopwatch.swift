//
//  Stopwatch.swift
//  Wayfindr Demo
//
//  Created by Axel Lundbäck on 08/03/2017.
//  Copyright © 2017 Wayfindr.org Limited. All rights reserved.
//

import Foundation

class Stopwatch: NSObject {
    
    private var clock: Timer?
    private var seconds = 0
    
    weak var delegate: StopwatchDelegate?
    
    func countUp() {
        
        seconds += 1
        
        if let delegate = delegate {
            
            delegate.stopwatch(stopwatch: self, timeDidUpdate: constructedTimeString)
        }
    }
    
    func start() {
        
        clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
    }
    
    func stop() {
        
        clock?.invalidate()
        clock = .none
    }
    
    private var constructedTimeString: String {
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
        return "\(timeText(from: h)):\(timeText(from: m)):\(timeText(from: s))"
    }
    
    private func timeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

protocol StopwatchDelegate: class {
    
    func stopwatch(stopwatch: Stopwatch, timeDidUpdate timeText: String)
}
