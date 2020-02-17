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
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.popUpView.layer.cornerRadius = 10
        timePicker.datePickerMode = .countDownTimer
        self.showAnimate()
        
    }
    // runs when the user presses the exit button in the pop up
    @IBAction func quitPopUp(_ sender: Any){
        self.removeAnimate()
        delegate?.didChooseCancel()
    }
    // runs once the user presses the begin timer button in the pop up
    @IBAction func beginFocusMode(_ sender: UIButton) {
        self.removeAnimate()
        delegate?.didChooseTime(duration: timePicker.countDownDuration)
    }
    //animates the arrival of the pop up
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    // animates the pop up dissapearance
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

protocol FMPopUpViewControllerDelegate: class {
    func didChooseCancel()
    func didChooseTime(duration: TimeInterval)
}
