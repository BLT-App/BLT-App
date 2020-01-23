//
//  FocusTimer.swift
//  BLT
//
//  Created by LorentzenN on 11/20/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

class FocusTimer {
    ///Timer object for running the thread
    var myTimer: Timer
    ///Number of mins on the timer
    var mins: Int
    ///Number of seconds on the timer
    var secs: Int
    ///String to send to the focus mode screen for display
    var description: String
    
    weak var delegate: FocusTimerDelegate?
    
    init(_ mins: Int, _ secs: Int) {
        self.mins = mins
        self.secs = secs
        myTimer = Timer()
        description = ""
    }
    
    ///Starts the timer
    func runTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateVals)), userInfo: nil, repeats: true)
    }
    
    ///Sets the string representation
    func stringMe(){
        if mins > 0 {
            if secs > 9 {
                description = "\(mins):\(secs)"
            } else {
                description = "\(mins):0\(secs)"
            }
        } else if secs > 30 {
            description = "\(secs)"
        } else {
            description = "Timer Ended!"
        }
    }
    
    ///Stops running the timer and notifies delegate
    func stopRunning() {
        myTimer.invalidate()
        delegate?.timerEnded()
    }
    
    ///Updates the values for minutes and seconds
    @objc func updateVals() {
        if secs != 0 {
            secs = secs - 1
        } else {
            if mins != 0 {
                mins = mins - 1
                secs = 59
            }
            if mins == 0 && secs == 0 {
                stopRunning()
            } else {
                secs = 59
            }
        }
        stringMe()
        delegate?.valsUpdated(description)
    }
}

protocol FocusTimerDelegate : class {
    ///Passes the readout for the timer for display on the screen
    func valsUpdated(_ timerReadout: String)
    ///Runs when the timer has ended
    func timerEnded()
}
