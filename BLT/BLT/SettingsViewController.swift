//
//  SettingsViewController.swift
//  
//
//  Created by LorentzenN on 1/24/20.
//

import UIKit

class SettingsViewController: UITableViewController {

    var targetSubmenu : Submenu = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    @IBAction func GoUserInfo(_ sender: Any) {
        goToSubmenu(.UserInfo)

    }
    @IBAction func goListPref(_ sender: Any) {
        goToSubmenu(.ListPref)

    }
    @IBAction func goFocusPref(_ sender: Any) {
        goToSubmenu(.FocusPref)

    }
    @IBAction func goNotifPref(_ sender: Any) {
        goToSubmenu(.NotifPref)
    }
    
    enum Submenu : Int8 {
        case none = 0
        case UserInfo = 1
        case ListPref = 2
        case FocusPref = 3
        case NotifPref = 4
    }
    
    func goToSubmenu(_ menu : Submenu) {
        targetSubmenu = menu
        performSegue(withIdentifier: "settingsGoToSubmenu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        targetSubmenu = .none
    }
    
}

