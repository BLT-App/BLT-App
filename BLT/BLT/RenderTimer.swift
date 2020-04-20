//
//  RenderTimer.swift
//  3D Demo
//
//  Created by LorentzenN on 12/3/19.
//  Copyright © 2019 Lorentzen. All rights reserved.
//

import Foundation

/// Class To Handle Running A Method Call To The `WaterView` On An Interval.
class RenderTimer {
    
    /// Timer Object For Handling Multithreading
	var myTimer: Timer

    /// Delegate To Tell To Rerender
	weak var delegate: RenderTimerDelegate?

    /// Initializer
	init() {
		myTimer = Timer()
	}

    /// Starts The Render Timer Sequence
    ///
    /// - Parameter interval:  Number of milliseconds between calls to render
	func runTimer(interval: Double) {
		myTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateVals), userInfo: nil, repeats: true)
	}
    
    /// Function Called From Thread
	@objc func updateVals() {
		delegate?.render()
	}
}

/// A Protocol That Allows An External Class To Have Itself Reminded To ReRender Itself
protocol RenderTimerDelegate: class {
	///Reminds other class to re draw
	func render()
}
