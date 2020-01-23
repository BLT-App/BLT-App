//
//  RenderTimer.swift
//  3D Demo
//
//  Created by LorentzenN on 12/3/19.
//  Copyright © 2019 Lorentzen. All rights reserved.
//

import Foundation
class RenderTimer {
    var myTimer: Timer
    
    weak var delegate: RenderTimerDelegate?
    
    init() {
        myTimer = Timer()
    }
    
    func runTimer(interval: Double) {
        myTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateVals), userInfo: nil, repeats: true)
    }
    
    @objc func updateVals() {
        delegate?.render()
    }
}

protocol RenderTimerDelegate: class {
    ///Reminds other class to re draw
    func render()
}
