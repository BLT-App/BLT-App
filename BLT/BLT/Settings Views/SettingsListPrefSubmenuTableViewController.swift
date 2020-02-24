//
//  SettingsListPrefSubmenuTableViewController.swift
//
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

/// List preferences table view controller.
class SettingsListPrefSubmenuTableViewController: UITableViewController {
	/// Switch for sorting.
	@IBOutlet weak var switchSortList: UISwitch!

	/// Runs when view loaded.
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	/// Runs when view appeared.
	override func viewWillAppear(_ animated: Bool) {
		switchSortList.isOn = globalData.wantsListByDate
	}

	/// Prepares for segue by saving.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		globalData.wantsListByDate = switchSortList.isOn

		globalData.saveUserData()
	}

}
