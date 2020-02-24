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
    
    /// Delegate for the FMPopUpView controller.
    weak var delegate: FMPopUpViewControllerDelegate?
    
    /// Variable for formatted time obtained from a date object (probably not useful at this point though).
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
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.popUpView.layer.cornerRadius = 10
        timePicker.datePickerMode = .countDownTimer
        self.showAnimate()
        
    }

    /// Runs when the user presses the exit button in the pop up.
    @IBAction func quitPopUp(_ sender: Any){
        self.removeAnimate()
        delegate?.didChooseCancel()
    }

    /// Runs once the user presses the begin timer button in the pop up.
    @IBAction func beginFocusMode(_ sender: UIButton) {
        self.removeAnimate()
        delegate?.didChooseTime(duration: timePicker.countDownDuration)
    }

    /// Animates the arrival of the pop up.
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    /// Animates the pop up disappearance.
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
        
    }

}

/// Protocol for the FMPopUpViewController delegate.
protocol FMPopUpViewControllerDelegate: class {
    /// The method that runs if the user chooses to exit the pop up.
    func didChooseCancel()
    
    /// The method that runs if the user chooses to start the timer in focus mode.
    func didChooseTime(duration: TimeInterval)
}
