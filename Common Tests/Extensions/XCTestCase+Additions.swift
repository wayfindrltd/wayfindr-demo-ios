//
//  XCTestCase+Additions.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 16/11/2015.
//  Copyright © 2015 ustwo. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func AssertExistsWithWait(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        
        let existsPredicate = NSPredicate(format: "exists == true", argumentArray: nil)
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 10.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 10 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 20.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 10 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func AssertPredicateWithWait(_ element: XCUIElement, predicate: String, file: String = #file, line: UInt = #line) {
        
        let existsPredicate = NSPredicate(format: "\(predicate) == true", argumentArray: nil)
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 10.0) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func AssertThrow<R, E>(_ expectedError: E, _ closure: @autoclosure () throws -> R, file: String = #file, line: UInt = #line) -> () where E: Error, E: Equatable {
        do {
            
            try closure()
            
            let message = "Expected error \"\(expectedError)\", " + "but closure succeeded."
            self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            
        } catch let error as E {
            
            if error != expectedError {
                let message = "Catched error is from expected type, " + "but not the expected case."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
            
        } catch {
            
            let message = "Catched error \"\(error)\", " + "but not the expected error " + "\"\(expectedError)\"."
            self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            
        }
    }
    
}
