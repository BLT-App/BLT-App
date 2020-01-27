//
//  SettingsUserProfileSubmenuViewController.swift
//  
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

class SettingsUserProfileSubmenuTableViewController: UITableViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    //These Are Just Placeholders for Now
    @IBOutlet weak var txtSchoolName: UITextField!
    @IBOutlet weak var txtSchoolCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Loads Existing Data
        if let firstName: String = globalData.firstName {
            txtFirstName.text = firstName
        }
        else
        {
            print("Couldn't Load First Name")
        }
        
        if let lastName: String = globalData.lastName {
            txtLastName.text = lastName
        }
        else
        {
            print("Couldn't Load Last Name")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let firstName: String = txtFirstName.text {
            globalData.firstName = firstName
        }
        if let lastName: String = txtLastName.text {
            globalData.lastName = lastName
        }
        
        globalData.saveUserData()
    }
    
}
