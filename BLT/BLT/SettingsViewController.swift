//
//  SettingsViewController.swift
//  BLT
//
//  Created by NLorentzen on 11/11/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsTableViewControllerDelegate {
    
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnList: UIButton!
    
    var settingsTable: SettingsTableViewController?
    var currentMenu: String = "profile"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMenu = "profile"
        settingsTable = self.children[0] as? SettingsTableViewController
        settingsTable?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentMenu = "profile"
    }
    
    func loadMenu() {
        
    }
    
    func loadProfileMenu() {
        btnProfile.isSelected = true
        print("Profile Menu Set")
    }
    
    func loadListMenu() {
        btnList.isSelected = true
        print("List Menu Set")
    }
    
    @IBAction func profileChosen(_ sender: UIButton) {
        currentMenu = "profile"
    }
    @IBAction func listChosen(_ sender: UIButton) {
        currentMenu = "list"
    }
}
