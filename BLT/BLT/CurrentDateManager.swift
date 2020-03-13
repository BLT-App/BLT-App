//
//  CurrentDateManager.swift
//  BLT
//
//  Created by LorentzenN on 3/4/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import Datez

var dateManager: CurrentDateManager = CurrentDateManager()

class CurrentDateManager {
    
    ///Date The App Gets
    var date: Date {
        if isInDebugMode && debugDate != Date() {
            return debugDate
        } else {
            return Date()
        }
    }
    
    ///Boolean of whether or not to use the debug date
    var isInDebugMode = false {
        didSet {
            if isInDebugMode {
                runTimer()
            } else {
                timer.invalidate()
            }
        }
    }
    
    ///Debug Date
    private var debugDate: Date = Date()
    
    /// Timer For Incementing Debug Date
    private var timer = Timer()
    
    /// Sets The Debug Date
    ///
    /// - Parameter to: Date To Set The Debug Date To
    func setDate(to: Date) {
        debugDate = to
    }
    
    
    /// Adds The Specified Amount Of Time To The Debug Date
    ///
    /// - Parameter _interval: Amount of time to add
    func addTimeIntervalToDate(_interval: TimeInterval) {
        debugDate += _interval
    }
    
    /// Begins Incrementing The Date
    ///
    /// - Parameter interval:  Number of milliseconds between calls to render
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1000, target: self, selector: #selector(incrementDate), userInfo: nil, repeats: true)
    }
    
    /// Adds One Second To The Debug Date
    @objc func incrementDate() {
        debugDate += 1.seconds.timeInterval
        
        if !isInDebugMode {
            timer.invalidate()
        }
    }
    
}
