//
//  CurrentDateManager.swift
//  BLT
//
//  Created by LorentzenN on 3/4/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import Datez


/// Global Date Manager Variable For Accessing The Date
var dateManager: CurrentDateManager = CurrentDateManager()

/// A Debugger Helping Class That Allows For Time Manipulation Within The App
class CurrentDateManager {
    
    /// Date The App Gets
    var date: Date {
        if isInDebugMode {
            return debugDate
        } else {
            return Date()
        }
    }
    
    /// Boolean of whether or not to use the debug date
    var isInDebugMode = false {
        didSet {
            if isInDebugMode {
                runTimer()
            } else {
                timer.invalidate()
            }
        }
    }
    
    /// Debug Date
    private var debugDate: Date = Date()
    
    /// Time Speed Multiplier For Debug Date
    var timeMultiplier: Float = 1.0 {
        didSet {
            if timeMultiplier != 1.0 {
                isInDebugMode = true
            }
        }
    }
    
    /// Timer For Incementing Debug Date
    private var timer = Timer()
    
    init() {
        print("Date Manager Created")
        timer.invalidate()
    }
    
    /// Sets The Debug Date
    ///
    /// - Parameter to: Date To Set The Debug Date To
    func setDate(to: Date) {
        debugDate = to
        isInDebugMode = true
    }
    
    
    /// Adds The Specified Amount Of Time To The Debug Date
    ///
    /// - Parameter _interval: Amount of time to add
    func addTimeIntervalToDate(_ interval: TimeInterval) {
        debugDate += interval
        isInDebugMode = true
    }
    
    /// Begins Incrementing The Date
    ///
    /// - Parameter interval:  Number of milliseconds between calls to render
    func runTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementDate), userInfo: nil, repeats: true)
        }
    }
    
    /// Simulates Time Flow To The Debug Date
    @objc func incrementDate() {
        debugDate += Int(1 * timeMultiplier).seconds.timeInterval
    }
    
}
