//
//  FMPopUpViewController.swift
//  BLT
//
//  Created by Student on 2/6/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

class FMPopUpViewController: UIViewController {


	@IBOutlet weak var popUpView: UIView!
	@IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var beginTimer: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
	weak var delegate: FMPopUpViewControllerDelegate?

	var formattedTime: String {
		get {
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			return formatter.string(from: timePicker.date)
		}
	}

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

	// runs when the user presses the exit button in the pop up
	@IBAction func quitPopUp(_ sender: Any) {
		self.removeAnimate()
		delegate?.didChooseCancel()
	}

	// runs once the user presses the begin timer button in the pop up
	@IBAction func beginFocusMode(_ sender: UIButton) {
		self.removeAnimate()
		delegate?.didChooseTime(duration: timePicker.countDownDuration)
	}

	//animates the arrival of the pop up
	func showAnimate() {
		self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
		self.view.alpha = 0.0;
		UIView.animate(withDuration: 0.25, animations: {
			self.view.alpha = 1.0
			self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		});
	}

	// animates the pop up dissapearance
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

protocol FMPopUpViewControllerDelegate: class {
	func didChooseCancel()
	func didChooseTime(duration: TimeInterval)
}
