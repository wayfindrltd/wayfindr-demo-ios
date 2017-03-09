//
//  WAYConstants.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 12/11/2015.
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

import Foundation
import CoreGraphics

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit.UIColor
    typealias WAYColor = UIColor
#elseif os(OSX)
    import AppKit.NSColor
    typealias WAYColor = NSColor
#endif


/**
 *  Constants used within the app.
 */
struct WAYConstants {
    
    struct WAYColors {
        static let Background       = WAYColor.white
        static let Border           = WAYColor.black
        static let Developer        = WAYColor(white: 43.0 / 255.0, alpha: 1.0)
        static let Disabled         = WAYColor.gray
        static let Error            = WAYColor.red
        static let Maintainer       = WAYColor(red: 0.0, green: 163.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0)
        static let NavigationText   = WAYColor.white
        static let TextHighlight    = WAYColor.red

        static let WayfindrMainColor    = WAYColor(red: 7.0 / 255.0, green: 24.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    }
    
    struct WAYFilenames {
        static let pingSound    = "dualPing"
        static let arrivalSound = "triPing"
    }
    
    struct WAYLayout {
        static let DefaultMargin: CGFloat = 20.0
        static let HalfMargin = DefaultMargin / 2.0
        static let QuarterMargin = DefaultMargin / 4.0
        static let DoubleMargin = DefaultMargin * 2.0
        
        static let metrics = ["DefaultMargin" : DefaultMargin, "HalfMargin" : HalfMargin, "QuarterMargin" : QuarterMargin, "DoubleMargin" : DoubleMargin]
    }
    
    struct WAYSettings {
        static let showOnlyTransportDestinationsThatRouteToAllExits = false
        
        /// Set this to false if you want to use accuracy
        static let locateNearestBeaconUsingRssi = true
        
        /// Set this to true if you want a strict route where you have go through all beacons in order
        static let strictRouting = false
        
        /// Show or hide a stopwatch on the underlying view in the ActiveRouteViewController
        static let stopwatchEnabled = true
        
        /// Show or hide a red view that covers the screen on every audio instruction
        static let audioFlashEnabled = true
    }
    
    struct WAYSizes {
        static let EstimatedCellHeight: CGFloat = 44.0
        static let TabBarHeight: CGFloat = 64.0
    }
    
    struct WAYSpeech {
        static let preUtteranceDelay: TimeInterval = 0.1
        static let postUtteranceDelay: TimeInterval = 0.1
    }
}
