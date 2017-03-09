//
//  AudioEngine.swift
//  Wayfindr Demo
//
//  Created by Wayfindr on 14/12/2015.
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

import UIKit
import AVFoundation


/// Audio enging for playing instructions.
final class AudioEngine: NSObject {
    
    
    // MARK: - Properties
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    
    /// Font to use for displaying instructions.
    fileprivate let instructionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    
    /// Ping sound to play at the beginning of instructions to get user's attention.
    fileprivate var pingSound: AVAudioPlayer?
    /// Ping sound to play when arriving at the destination to get user's attention.
    fileprivate var arrivalSound: AVAudioPlayer?

    /// Speech synthesizer to read aloud instructions using text-to-speech.
    fileprivate let speechSynthesizer = AVSpeechSynthesizer()
    /// Voice to use for `speechSynthesizer`.
    fileprivate let voice = AVSpeechSynthesisVoice(language: "en-GB")
    
    /// The currently playing (or most recently played) instruction.
    fileprivate(set) var currentInstruction: String?
    /// Instruction that will be played after `delayTimer` has fired.
    fileprivate var upcomingInstruction: String?
    /// Timer to delay the playing of `upcomingInstruction`.
    fileprivate var delayTimer: Timer?
    
    /// Text view to display instructions during playback.
    weak var textView: UITextView?
    /// Repeat button to disable during playback and re-enable afterwards.
    weak var repeatButton: UIButton?
    
    fileprivate(set) var valid = true
    
    
    // MARK: - Initializers
    
    /**
    Initializes an `AudioEngine`.
    */
    override init() {
        super.init()
        
        setupNotificationPlayers()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.interruptSpokenAudioAndMixWithOthers)
            try audioSession.setActive(true)
        } catch {
            valid = false
        }
        
        speechSynthesizer.delegate = self
    }


    fileprivate func setupNotificationPlayers() {
        if let pingURL = Bundle.main.url(forResource: WAYConstants.WAYFilenames.pingSound, withExtension: "mp3") {
            pingSound = try? AVAudioPlayer(contentsOf: pingURL)
        }

        if let pingURL = Bundle.main.url(forResource: WAYConstants.WAYFilenames.arrivalSound, withExtension: "mp3") {
            arrivalSound = try? AVAudioPlayer(contentsOf: pingURL)
        }
    }


    // MARK: - Playback
    
    /**
    Stops any playback.
    */
    func stopPlayback() {
        delayTimer?.invalidate()
        upcomingInstruction = nil
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        // Reset the text to remove any highlighting
        if let myCurrentInstruction = currentInstruction {
            displayInstruction(myCurrentInstruction)
        }
    }
    
    /**
     Notifies the user and plays an instruction string.
     
     - parameter instruction: String to read aloud to the user.
     */
    func playInstruction(_ instruction: String) {
        pingSound?.play()
        doPlayInstruction(instruction)
    }
    
    /**
     Plays an instruction after a time delay. Automatically removes an other upcomming instructions currently in the queue.
     
     - parameter instruction:   String to read aloud to the user.
     - parameter delayInterval: Time delay in seconds.
     */
    func playInstruction(_ instruction: String, delayInterval: TimeInterval) {
        delayTimer?.invalidate()
        
        upcomingInstruction = instruction
        let timer = Timer.scheduledTimer(timeInterval: delayInterval, target: self, selector: #selector(AudioEngine.delayTimerFired), userInfo: nil, repeats: false)
        
        delayTimer = timer
    }

    /**
     Notifies the user with the arrival sound and plays an instruction string.

     - parameter instruction: String to read aloud to the user.
     */
    func playArrivalInstruction(_ instruction: String) {
        arrivalSound?.play()
        doPlayInstruction(instruction)
    }

    /**
     Plays an instruction.
     
     - parameter instruction: String to read aloud to the user.
     */
    fileprivate func doPlayInstruction(_ instruction: String) {
        // Create and configure utterance from string
        let utterance = AVSpeechUtterance(string: instruction)
        utterance.voice = voice
        utterance.preUtteranceDelay = WAYConstants.WAYSpeech.preUtteranceDelay
        utterance.postUtteranceDelay = WAYConstants.WAYSpeech.postUtteranceDelay
        
        // Play utterance
        speechSynthesizer.speak(utterance)
        
        // Save instruction for later
        currentInstruction = instruction
        
        if WAYConstants.WAYSettings.audioFlashEnabled {
            
            showInstructionOverlay(delay: 0)
        }
    }
    
    // MARK: - Timer
    
    /**
    Plays `upcommingInstruction` after the `delayTimer` has fired.
    */
    func delayTimerFired() {
        guard let myUpcomingInstruction = upcomingInstruction else {
            return
        }
        
        playInstruction(myUpcomingInstruction)
    }
    
    private func showInstructionOverlay(delay: TimeInterval) {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.red
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            UIApplication.shared.keyWindow?.addSubview(view)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 1.0) {
            
            view.removeFromSuperview()
        }
    }
}


// MARK: - AVSpeechSynthesizerDelegate

extension AudioEngine: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Highlight the characters that are about to be spoken.
        
        displayInstruction(utterance.speechString, highlightRange: characterRange)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        displayInstruction(utterance.speechString)
        repeatButton?.isEnabled = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        displayInstruction(utterance.speechString)
        repeatButton?.isEnabled = true
    }
    
    /**
     Displays the instruction in `textView`.
     
     - parameter instruction:    Instruction `String` to display.
     - parameter highlightRange: Range of characters in `instruction` to highlight, if any. Default value is nil.
     */
    func displayInstruction(_ instruction: String, highlightRange: NSRange? = nil) {
        // Initialize the string
        let mutableAttributedString = NSMutableAttributedString(string: instruction)
        
        // Highlight a set of characters, if needed.
        if let myHighlightRange = highlightRange {
            mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: WAYConstants.WAYColors.TextHighlight, range: myHighlightRange)
        }
        
        // Set the font
        mutableAttributedString.addAttribute(NSFontAttributeName, value: instructionFont, range: NSRange(location: 0, length: mutableAttributedString.length))
        
        // Set the text alignment
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        mutableAttributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: mutableAttributedString.length))
        
        // Update the display
        textView?.attributedText = mutableAttributedString
    }
    
}
