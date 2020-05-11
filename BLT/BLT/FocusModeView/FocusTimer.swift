//
//  FocusTimer.swift
//  BLT
//
//  Created by LorentzenN on 11/20/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

public var timerActive: Bool = false
/// Handles The Countdown Of `FocusViewController`
class FocusTimer {
	/// Timer object for running the thread
	var myTimer: Timer = Timer()
    
	/// Number of mins on the timer.
	var mins: Int {
		return Int(cdt / 60)
	}

	/// Number of seconds on the timer.
	var secs: Int {
		return Int(cdt) % 60
	}
    
  ///Current Number Of Seconds To Timer End
	var cdt: TimeInterval

	///String to send to the focus mode screen for display
	var description: String = ""

	/// total number of seconds initially.
	var totalSecs: TimeInterval

    /// Reference To The Storyboard With The Countdown.
	weak var delegate: FocusTimerDelegate?
    
    //var isTimerActive: Bool
    
    /// Initializes A New FocusTimer.
    /// - Parameter countdownTime: Number Of Seconds To Run The Timer For
	init(countdownTime: TimeInterval) {
        //self.isTimerActive = false
		self.cdt = countdownTime
		self.totalSecs = countdownTime
		print(totalSecs)
	}

	/// Starts the timer.
	func runTimer() {
        timerActive = true
        //isTimerActive = true
		myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateVals)), userInfo: nil, repeats: true)
	}

	/// Sets the string representation.
	func stringMe() {
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

	/// Stops running the timer and notifies delegate.
	func stopRunning() {
        timerActive = false
        //self.isTimerActive = false
		myTimer.invalidate()
		delegate?.timerEnded()
	}
    
    

	/// Updates the values for minutes and seconds.
	@objc func updateVals() {
		if cdt > 0 {
			cdt -= TimeInterval(1.0 * dateManager.timeMultiplier)
		} else {
			stopRunning()
		}
		stringMe()
	}
}

/// Protocol For Storyboards That Have A FocusTimer
protocol FocusTimerDelegate: class {
	/// Passes the readout for the timer for display on the screen.
	func valsUpdated(_ timerReadout: String)
	/// Runs when the timer has ended.
	func timerEnded()
}
