//
//  ItemViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 11/18/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit

/// View controller for editing an item.
class ItemViewController: UIViewController {

	/// Delegate view controller.
	var delegate: UIViewController?

	/// Target index selected from list.
	var targetIndex: Int?

	/// Exit button.
	@IBOutlet weak var exitButton: UIButton!

	/// Class name field.
	@IBOutlet weak var classNameField: UITextField!

	/// Assignment field.
	@IBOutlet weak var assignmentField: UITextField!

	/// Description field.
	@IBOutlet weak var descriptionField: UITextView!

	/// Date picker.
	@IBOutlet weak var datePicker: UIDatePicker!

	/// Loads the view.
	override func viewDidLoad() {
		super.viewDidLoad()

		setupButtons()
		// Do any additional setup after loading the view.
	}

	/// Loads the page on appearance.
	override func viewWillAppear(_ animated: Bool) {
		loadPage()
	}

	/// Loads the page by loading in the latest task into the current card.
	func loadPage() {
		if let thisIndex = targetIndex {
			let thisToDo = myToDoList.list[thisIndex]
			classNameField.text = thisToDo.className
			classNameField.backgroundColor = globalData.subjects[thisToDo.className]?.uiColor
			assignmentField.text = thisToDo.title
			descriptionField.text = thisToDo.description
			datePicker.date = thisToDo.dueDate
		}
	}

	/// Sets up visual appearance of buttons.
	func setupButtons() {
		exitButton.layer.cornerRadius = 15.0
		exitButton.layer.shadowColor = UIColor.blue.cgColor
		exitButton.layer.shadowOpacity = 0.2
		exitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
		exitButton.layer.shadowRadius = 5.0
		exitButton.layer.masksToBounds = false
	}

	/// Returns to previous screen.
	@IBAction func backButton(_ sender: UIButton) {
		if let classTxt = classNameField.text, let titleTxt = assignmentField.text, let descTxt = descriptionField.text, let thisIndex = targetIndex {
			// Debug for clearing/resetting entire list.
			if (classTxt != "" && titleTxt != "") {
				myToDoList.list[thisIndex] = ToDoItem(className: classTxt, title: titleTxt, description: descTxt, dueDate: datePicker.date, completed: myToDoList.list[thisIndex].isCompleted())
				myToDoList.storeList()
				globalData.updateCourses(fromList: myToDoList)

				//If Users Have it Set, Sort List By Due Date
				if globalData.wantsListByDate {
					myToDoList.sortList()
				}
			}
			self.dismiss(animated: true, completion: nil)
			if let thisDelegate = delegate as? ListViewController {
				thisDelegate.update()
			}
		}
	}

	/*
	// MARK: - Navigation
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
