//
//  SettingsUserProfileSubmenuViewController.swift
//  
//
//  Created by LorentzenN on 1/26/20.
//

import UIKit

/// User Profile submenu table view controller.
class SettingsUserProfileSubmenuTableViewController: UITableViewController {

	/// Text Field for first name.
	@IBOutlet weak var txtFirstName: UITextField!

	/// Text field for last name.
	@IBOutlet weak var txtLastName: UITextField!

	/// Text field for school name (placeholder).
	@IBOutlet weak var txtSchoolName: UITextField!

	/// Text field for school code (placeholder).
	@IBOutlet weak var txtSchoolCode: UITextField!

	/// Runs when view did finish loading.
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	/// Runs when view appeared.
	override func viewWillAppear(_ animated: Bool) {
		//Loads Existing Data
		if let firstName: String = globalData.firstName {
			txtFirstName.text = firstName
		} else {
			print("Couldn't Load First Name")
		}

		if let lastName: String = globalData.lastName {
			txtLastName.text = lastName
		} else {
			print("Couldn't Load Last Name")
		}
	}

	/// Prepares for rewind by saving data.
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
