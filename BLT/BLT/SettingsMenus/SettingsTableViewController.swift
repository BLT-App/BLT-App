//
//  SettingsTableViewController.swift
//  BLT
//
//  Created by LorentzenN on 11/17/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit

//var includeEndButton: Bool = true

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    weak var delegate : SettingsTableViewControllerDelegate?
    
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var sortListSwitch: UISwitch!
    @IBOutlet weak var btnAddClass: UIButton!
    
    @IBOutlet weak var focusModeButton: UISwitch!
    @IBOutlet weak var addClassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.text = globalData.firstName
        firstNameField.delegate = self
        lastNameField.text = globalData.lastName
        lastNameField.delegate = self
        sortListSwitch.isOn = globalData.wantsListByDate
        addClassField.delegate = self
        focusModeButton.isOn = globalData.includeEndFocusButton
        
    }
    
    //Tell Text Fields To Close On Hitting Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func firstNameEntered(_ sender: UITextField) {
        globalData.firstName = sender.text ?? ""
        globalData.saveUserData()
    }
    
    @IBAction func lastNameEntered(_ sender: UITextField) {
        globalData.lastName = sender.text ?? ""
        globalData.saveUserData()
    }
    
    @IBAction func sortListSwitch(_ sender: UISwitch) {
        globalData.wantsListByDate = sender.isOn
        globalData.saveUserData()
        
        //Sort If That Is What The User Set
        if globalData.wantsListByDate {
            myToDoList.sortList()
        }
    }
    
    @IBAction func newClassEntered(_ sender: UITextField) {
        if sender.text != "" {
            btnAddClass.isHidden = false
            btnAddClass.isEnabled = true
        } else {
            btnAddClass.isHidden = true
            btnAddClass.isEnabled = false
        }
    }
    @IBAction func addClassHit(_ sender: UIButton) {
        globalData.addSubject(name: addClassField.text!)
    }
    
    
    @IBAction func focusModeSwitch(_ sender: UISwitch) {
        globalData.includeEndFocusButton = focusModeButton.isOn
        globalData.saveUserData()
        print(globalData.includeEndFocusButton)
    }
}

protocol SettingsTableViewControllerDelegate : class {
}
