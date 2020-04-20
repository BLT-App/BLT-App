//
//  SettingsNotifPrefSubmenuTableViewController.swift
//
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

/// Notification preferences table view controller.
class SettingsNotifPrefSubmenuTableViewController: UITableViewController {
    
    @IBOutlet weak var notifText: UILabel!
    
    @IBOutlet weak var notifSlider: UISlider!

    var notifNum: Int = 0;
    
    /// RUns when view did load.
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
        notifText.text = "every week"
        self.notifSlider.value = 0.6
        notifNum = 7
	}
    
    @IBAction func sliderValChanged(_ sender: Any) {
        var sliderVal = Double(10.0 * self.notifSlider.value)
        let sliderMax = 10.0
        
        if(sliderVal < sliderMax / 4 && sliderVal >= 0){
            notifText.text = "everyday"
            self.notifNum = 1
            
        }
        
        else if(sliderVal >= sliderMax / 4 && sliderVal < sliderMax / 2){
            notifText.text = "every 3 days"
            self.notifNum = 3
        }
        
        else if(sliderVal >= sliderMax / 2 && sliderVal < (3 * sliderMax) / 4){
            notifText.text = "every week"
            self.notifNum = 7
        }
        
        else{
            notifText.text = "every fortnight"
            self.notifNum = 14
        }
        
        
        
    }
}
