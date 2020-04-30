//
//  SettingsTableViewController.swift
//  
//
//  Created by LorentzenN on 1/24/20.
//

import UIKit

/// Settings table view controller. Controls the settings view.
class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var bugReportButton: UIButton!
    
    /// Runs when view did load.
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	/// Prepares for segue.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	}

	/// Unwinding to root view controller.
	@IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
		//print("Unwind to Root View Controller")
	}
    
    @IBAction func bugReportTouched(_ sender: UIButton) {
        if let url = URL(string: "https://forms.gle/u1trNa8YpKNF6wnR8") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
