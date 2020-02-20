//
//  FMPopUpViewController.swift
//  BLT
//
//  Created by Student on 2/6/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

/// view controller for the pop up in focus mode
class FMPopUpViewController: UIViewController {
  
    /// outlet for the pop up view
    @IBOutlet weak var popUpView: UIView!
    
    /// outlet for the timePicker in the pop up
    @IBOutlet weak var timePicker: UIDatePicker!
    
    /// delegate for the FMpopupview controller
    weak var delegate: FMPopUpViewControllerDelegate?
    
    /// variable for formatted time obtained from a date object (probably not useful at this point though)
    var formattedTime: String {
        get {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: timePicker.date)
        }
    }
    
    /// runs if the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.popUpView.layer.cornerRadius = 10
        timePicker.datePickerMode = .countDownTimer
        self.showAnimate()
        
    }
    /// runs when the user presses the exit button in the pop up
    @IBAction func quitPopUp(_ sender: Any){
        self.removeAnimate()
        delegate?.didChooseCancel()
    }
    /// runs once the user presses the begin timer button in the pop up
    @IBAction func beginFocusMode(_ sender: UIButton) {
        self.removeAnimate()
        delegate?.didChooseTime(duration: timePicker.countDownDuration)
    }
    ///animates the arrival of the pop up
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    /// animates the pop up dissapearance
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

/// protocol for the FMpopupviewcontroller delegate
protocol FMPopUpViewControllerDelegate: class {
    /// the method that runs if the user chooses to exit the pop up
    func didChooseCancel()
    
    /// the method that runs if the user chooses to start the timer in focus mode
    func didChooseTime(duration: TimeInterval)
}
