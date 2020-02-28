//
//  FMPopUpViewController.swift
//  BLT
//
//  Created by Student on 2/6/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

/// View controller for the pop up in focus mode. This popup prompts the user to input a time to focus for.
class FMPopUpViewController: UIViewController {

    /// Outlet for the pop up view.
	@IBOutlet weak var popUpView: UIView!
    
    /// Outlet for the timePicker in the pop up.
	@IBOutlet weak var timePicker: UIDatePicker!
    
    /// Button to begin timer.
    @IBOutlet weak var beginTimer: UIButton!
    
    /// Button to exit focus mode.
    @IBOutlet weak var exitButton: UIButton!
    
    /// Delegate for the FMPopUpView controller.
	weak var delegate: FMPopUpViewControllerDelegate?

  /// Formatted string of time.
	var formattedTime: String {
		get {
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			return formatter.string(from: timePicker.date)
		}
	}

    /// Runs if the view loads.
	override func viewDidLoad() {
		super.viewDidLoad()
        setupButtons()
        let blurView = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .dark), intensity: 0.3)
        blurView.frame = self.view.frame
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
		self.popUpView.layer.cornerRadius = 20
        addShadow(view: popUpView, color: UIColor.gray.cgColor, opacity: 0.5, radius: 10, offset: CGSize(width: 0, height: 5))
		timePicker.datePickerMode = .countDownTimer
		self.showAnimate()

	}
    
    /// Sets up UI for buttons.
    func setupButtons() {
        beginTimer.layer.cornerRadius = 15.0
        beginTimer.layer.shadowColor = UIColor.blue.cgColor
        beginTimer.layer.shadowOpacity = 0.1
        beginTimer.layer.shadowOffset = CGSize(width: 0, height: 0)
        beginTimer.layer.shadowRadius = 5.0
        beginTimer.layer.masksToBounds = false
        
        exitButton.layer.cornerRadius = 15.0
        exitButton.layer.shadowColor = UIColor.red.cgColor
        exitButton.layer.shadowOpacity = 0.1
        exitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        exitButton.layer.shadowRadius = 5.0
        exitButton.layer.masksToBounds = false
    }

	/// Runs when the user presses the exit button in the pop up.
	@IBAction func quitPopUp(_ sender: Any) {
		self.removeAnimate()
		delegate?.didChooseCancel()
	}

	/// Runs once the user presses the begin timer button in the pop up.
	@IBAction func beginFocusMode(_ sender: UIButton) {
		self.removeAnimate()
		delegate?.didChooseTime(duration: timePicker.countDownDuration)
	}

	/// Animates the arrival of the pop up.
	func showAnimate() {
		self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
		self.view.alpha = 0.0;
		UIView.animate(withDuration: 0.25, animations: {
			self.view.alpha = 1.0
			self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		});
	}

	/// Animates the pop up dissapearance.
	func removeAnimate() {
		UIView.animate(withDuration: 0.25, animations: {
			self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
			self.view.alpha = 0.0;
		}, completion: { (finished: Bool) in
			if (finished) {
				self.view.removeFromSuperview()
			}
		});

	}
    
    /**
     Creates shadows for a view.
     - parameters:
     - view: The view to add a shadow to.
     - color: The color of the shadow.
     - opacity: The opacity of the shadow.
     - radius: The radius of the shadow.
     - offset: The offset of the shadow.
     */
    func addShadow(view: UIView, color: CGColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
}
/// Protocol for the FMPopUpViewController delegate.
protocol FMPopUpViewControllerDelegate: class {
    /// The method that runs if the user chooses to exit the pop up.
	func didChooseCancel()
    
    /// The method that runs if the user chooses to start the timer in focus mode.
	func didChooseTime(duration: TimeInterval)
}
