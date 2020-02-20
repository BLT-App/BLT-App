//
//  SettingsListPrefSubmenuTableViewController.swift
//
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

class SettingsListPrefSubmenuTableViewController: UITableViewController {
	@IBOutlet weak var switchSortList: UISwitch!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		switchSortList.isOn = globalData.wantsListByDate
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		globalData.wantsListByDate = switchSortList.isOn

		globalData.saveUserData()
	}

}
