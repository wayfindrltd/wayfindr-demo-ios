//
//  XCTestCase+Additions.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
//  Copyright © 2015 ustwo. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func AssertExistsWithWait(element: XCUIElement, file: String = #file, line: UInt = #line) {
        
        let existsPredicate = NSPredicate(format: "exists == true", argumentArray: nil)
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
        waitForExpectationsWithTimeout(10.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 10 seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
        
        waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 10 seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func AssertPredicateWithWait(element: XCUIElement, predicate: String, file: String = #file, line: UInt = #line) {
        
        let existsPredicate = NSPredicate(format: "\(predicate) == true", argumentArray: nil)
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
        waitForExpectationsWithTimeout(10.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func AssertThrow<R, E where E: ErrorType, E: Equatable>(expectedError: E, @autoclosure _ closure: () throws -> R, file: String = #file, line: UInt = #line) -> () {
        do {
            
            try closure()
            
            let message = "Expected error \"\(expectedError)\", " + "but closure succeeded."
            self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            
        } catch let error as E {
            
            if error != expectedError {
                let message = "Catched error is from expected type, " + "but not the expected case."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
            
        } catch {
            
            let message = "Catched error \"\(error)\", " + "but not the expected error " + "\"\(expectedError)\"."
            self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            
        }
    }
    
}
