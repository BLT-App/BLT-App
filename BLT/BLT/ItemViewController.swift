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
			let thisToDo = toDoListManager.getToDoItemAt(index: thisIndex)
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
			if (classTxt != "" && titleTxt != "") {
				let targetItem = toDoListManager.getToDoItemAt(index: thisIndex)
                targetItem.className = classTxt
                targetItem.title = titleTxt
                targetItem.description = descTxt
                targetItem.dueDate = datePicker.date
				toDoListManager.placeToDoItemAtIndex(item: targetItem, index: thisIndex)
				globalData.updateCourses(fromList: toDoListManager.list)

				//If Users Have it Set, Sort List By Due Date
				if globalData.wantsListByDate {
					toDoListManager.sortList()
				}
            } else {
                /// TODO: Prompt User To Delete Task
            }
			self.dismiss(animated: true, completion: nil)
			if let thisDelegate = delegate as? ListViewController {
				thisDelegate.update()
			}
		}
	}
}
