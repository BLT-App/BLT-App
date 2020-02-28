//
//  Additional Classes.swift
//  BLT
//
//  Created by Jiahua Chen on 11/26/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import UIKit


/// Allows Custom Intesities for Blur Views
class CustomIntensityVisualEffectView: UIVisualEffectView {

	/// Create visual effect view with given effect and its intensity
	/// - Parameters:
	///   - effect: visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	init(effect: UIVisualEffect, intensity: CGFloat) {
		super.init(effect: nil)
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
			self.effect = effect
		}
		animator.fractionComplete = intensity
	}

    
    /// Initializer From Decoder
    ///
    /// - Parameter aDecoder: Decoder
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	/// Animator Object
	private var animator: UIViewPropertyAnimator!

}

/// Overwrites printing to show stack trace of print statement.
public func print(_ items: String..., filename: String = #file, function: String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {

	let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t -> "
	let output = items.map {
		"\($0)"
	}.joined(separator: separator)
	Swift.print(pretty + output, terminator: terminator)

}
