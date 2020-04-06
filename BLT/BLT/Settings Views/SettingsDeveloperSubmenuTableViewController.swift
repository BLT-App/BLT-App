//
//  SettingsDeveloperSubmenuTableViewController.swift
//  BLT
//
//  Created by LorentzenN on 3/13/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit

class SettingsDeveloperSubmenuTableViewController: UITableViewController {

    ///Date Picker For Debug Date
    @IBOutlet weak var debugDatePicker: UIDatePicker!
    
    ///Slider to choose rate at which time passes
    @IBOutlet weak var timeWarpSlider: UISlider!
    
    ///Switch For Enabling Debug Date Controls
    @IBOutlet weak var debugDateSwitch: UISwitch!
    
    ///Label For Current TimeWarp Value
    @IBOutlet weak var lblTimeWarp: UILabel!
    
    ///Cell Containing The Date Picker
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    ///Cell Containing The Warp Slider
    @IBOutlet weak var timeWarpCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExistingValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExistingValues()
        if dateManager.isInDebugMode {
            debugDateSwitch.isOn = true
        }
        manageShowingTimeMenus()
    }
    
    func loadExistingValues() {
        debugDatePicker.date = dateManager.date
        timeWarpSlider.value = dateManager.timeMultiplier
        setTimeMultiplierText()
    }
    
    func setTimeMultiplierText() {
        lblTimeWarp.text = "\(Double(Int(timeWarpSlider.value * 10)) / 10.0) x"
    }
    
    func manageShowingTimeMenus() {
        if debugDateSwitch.isOn {
            timeWarpCell.isHidden = false
            datePickerCell.isHidden = false
        } else {
            timeWarpCell.isHidden = true
            datePickerCell.isHidden = true
        }
    }
    
    @IBAction func didSetDateManager(_ sender: UISwitch) {
        manageShowingTimeMenus()
        if !debugDateSwitch.isOn {
            dateManager.isInDebugMode = false
        }
    }
    
    @IBAction func didChangeTimeSpeed(_ sender: UISlider) {
        print("Changed Time Warp")
        if debugDateSwitch.isOn {
            dateManager.timeMultiplier = timeWarpSlider.value
            setTimeMultiplierText()
        }
    }
    
    @IBAction func didChangeDebugDate(_ sender: UIDatePicker) {
        print("Changed Debug Date")
        if debugDateSwitch.isOn {
            dateManager.setDate(to: debugDatePicker.date)
        }
    }
    
    
}
