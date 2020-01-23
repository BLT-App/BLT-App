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
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var sortListSwitch: UISwitch!
    @IBOutlet weak var btnAddClass: UIButton!
    
    @IBOutlet weak var focusModeButton: UISwitch!
    @IBOutlet weak var addClassField: UITextField!
    
    var myToDoList: ToDoList = ToDoList()
    var userData: UserData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.text = userData.firstName
        firstNameField.delegate = self
        lastNameField.text = userData.lastName
        lastNameField.delegate = self
        sortListSwitch.isOn = userData.wantsListByDate
        addClassField.delegate = self
        focusModeButton.isOn = userData.includeEndFocusButton
        
    }
    
    //Tell Text Fields To Close On Hitting Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func firstNameEntered(_ sender: UITextField) {
        userData.firstName = sender.text ?? ""
        userData.saveUserData()
    }
    
    @IBAction func lastNameEntered(_ sender: UITextField) {
        userData.lastName = sender.text ?? ""
        userData.saveUserData()
    }
    
    @IBAction func sortListSwitch(_ sender: UISwitch) {
        userData.wantsListByDate = sender.isOn
        userData.saveUserData()
        
        //Sort If That Is What The User Set
        if userData.wantsListByDate {
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
        userData.addSubject(name: addClassField.text!)
    }
    
    @IBAction func focusModeSwitch(_ sender: UISwitch) {
        userData.includeEndFocusButton = focusModeButton.isOn
        userData.saveUserData()
        print(userData.includeEndFocusButton)
    }
}

protocol SettingsTableViewControllerDelegate: class {
}
