//
//  SettingsFocusPrefSubmenuTableViewController.swift
//
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

/// Focus Submenu Table View Controller.
class SettingsFocusPrefSubmenuTableViewController: UITableViewController {

	/// Switch to toggle showing end button.
	@IBOutlet weak var switchShowEndButton: UISwitch!

	/// Runs when view did load.
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	/// Runs when view will appear (updates from userData).
	override func viewWillAppear(_ animated: Bool) {
		switchShowEndButton.isOn = globalData.includeEndFocusButton
	}

	/// Prepares for segue by updating.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		globalData.includeEndFocusButton = switchShowEndButton.isOn

		globalData.saveUserData()
	}

}
