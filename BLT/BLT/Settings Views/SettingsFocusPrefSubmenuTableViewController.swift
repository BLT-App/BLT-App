//
//  SettingsFocusPrefSubmenuTableViewController.swift
//
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

class SettingsFocusPrefSubmenuTableViewController: UITableViewController {

	@IBOutlet weak var switchShowEndButton: UISwitch!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		switchShowEndButton.isOn = globalData.includeEndFocusButton
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		globalData.includeEndFocusButton = switchShowEndButton.isOn

		globalData.saveUserData()
	}

}
