//
//  NewItemViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import DropDown
import RealmSwift

/// View Controller for creating a new item.
class NewItemViewController: UIViewController, UITextFieldDelegate {

	/// Text field with drop down add on
	@IBOutlet weak var classText: UITextField!

	/// Text field for the title of the ToDoItem
	@IBOutlet weak var titleText: UITextField!

	/// Text view for the description of the ToDoitem
    @IBOutlet weak var descText: UITextView!
    
	/// Date picker for the due date.
	@IBOutlet weak var datePicker: UIDatePicker!

	/// Variable used for obtaining value in drop down menu.
	var selected: String = ""

	/// Exiting button.
	@IBOutlet weak var exitButton: UIButton!

    @IBOutlet weak var addButton: UIButton!
    
    /// Dropdown item.
	var dropDown: DropDown = DropDown()

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    /// View did load function. Sets up rounded views.
	override func viewDidLoad() {
		super.viewDidLoad()
        
        setupCard()
		// Do any additional setup after loading the view.
		exitButton.layer.cornerRadius = 15.0
		exitButton.layer.shadowColor = UIColor.blue.cgColor
		exitButton.layer.shadowOpacity = 0.2
		exitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
		exitButton.layer.shadowRadius = 5.0
		exitButton.layer.masksToBounds = false
        
        addButton.layer.cornerRadius = 25.0
        addButton.layer.shadowColor = UIColor.blue.cgColor
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addButton.layer.shadowRadius = 5.0
        addButton.layer.masksToBounds = false
		titleText.delegate = self
		globalData.retrieveUserData()

		// Loads DropDown
		dropDown.anchorView = classText
		dropDown.dataSource = globalData.subjectList
		dropDown.direction = .bottom
		dropDown.cellNib = UINib(nibName: "SubjectCell", bundle: nil)

		dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			guard let cell = cell as? SubjectCell else {
				return
			}

			// Setup your custom UI components
			if let color = globalData.subjects[item] {
				cell.subjectLabel.backgroundColor = color.uiColor
			}
			cell.subjectLabel.sizeThatFits(CGSize(width: cell.subjectLabel.frame.size.width, height: 30))
			cell.subjectLabel.layer.cornerRadius = 11.0
			cell.subjectLabel.clipsToBounds = true
		}

		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			self.classText.text = item
			self.updateClassText()
		}
		dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)

		DropDown.appearance().textColor = .white
		DropDown.appearance().backgroundColor = UIColor.white
		DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
		DropDown.appearance().cornerRadius = 15
        
        datePicker.date = dateManager.date + 1.day.timeInterval
	}

	/// Exits the modal view/screen.
	@IBAction func exitButton(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}

	/// Checks if the titles are correct, then adds it to the list.
	@IBAction func addButton(_ sender: UIButton) {
		if let classTxt = classText.text, let titleTxt = titleText.text, let descTxt = descText.text {
			// Debug for clearing/resetting entire list.
			if classText.text != "" && titleTxt != "" && descTxt != "" {
                let newToDo = ToDoItem(className: classTxt, title: titleTxt, description: descTxt, dueDate: datePicker.date)
                
                let realm = realmManager.realm
                if realm.isInWriteTransaction {
                    realm.add(newToDo)
                } else {
                    do {
                        try realm.write {
                            realm.add(newToDo)
                        }
                    } catch {
                        print(error)
                    }
                }

				//If Users Have it Set, Sort List By Due Date
				if globalData.wantsListByDate {
					//myToDoList.sortList()
                    ///TODO: Fix Not Being Able To Rearrange
				}
			}
			globalData.updateCourses(fromList: myToDoList)
			self.dismiss(animated: true, completion: nil)
		}
	}

	/// Shows dropdown.
	@IBAction func showDropDown(_ sender: Any) {
		updateDropDown()
		dropDown.show()
	}

	/// Hides dropdown.
	@IBAction func hideDropDown(_ sender: Any) {
		dropDown.hide()
	}

	/// Marks subject has changed;.
	@IBAction func subjectChanged(_ sender: UITextField) {
		updateDropDown()
		updateClassText()
	}

	/// Updates dropdown view from values starting with.
	func updateDropDown() {
		dropDown.dataSource = valuesStartingWith(classText.text ?? "", fromArray: globalData.subjectList)
		dropDown.reloadAllComponents()
		dropDown.show()
	}

	/// Updates class text and color.
	func updateClassText() {
		let currentClass = classText.text ?? ""
		if let color = globalData.subjects[currentClass] {
			classText.backgroundColor = color.uiColor
			classText.textColor = .white
		} else {
			classText.backgroundColor = .white
			classText.textColor = .black
		}
	}

	/// Returns a filtered list of strings.
	/// - Parameters:
	///   - prefix: The string of the prefix.
	///   - list: The String array to filter from.
	/// - Returns: The String array that is filtered to contain **prefix**.
	func valuesStartingWith(_ prefix: String, fromArray list: [String]) -> [String] {
		var returnList: [String] = []
		for testItem in list {
			if prefix == "" || testItem.contains(prefix) {
				returnList.append(testItem)
			}
		}
		return returnList
	}

	/// Tell Text Fields To Close On Hitting Enter
	/// - Parameter textField:
	/// - Returns:
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.titleText {
			self.descText.becomeFirstResponder()
		} else {
			self.view.endEditing(true)
		}
		return false
	}

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
 */
}

/// Extension that contains the graphical functions.
extension NewItemViewController {
    func setupCard() {
        roundContainerView(cornerRadius: 20, view: containerView, shadowView: shadowView)
        addShadow(view: shadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
    }
    
    /**
     Creates a rounded container view.
     - parameters:
     - cornerRadius: The corner radius of the rounded container.
     - view: The UIView to round.
     - shadowView: The accompanying shadowView of the main view to round.
     */
    func roundContainerView(cornerRadius: Double, view: UIView, shadowView: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        shadowView.layer.cornerRadius = CGFloat(cornerRadius)
        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    /**
     Creates shadows for a view.
     - parameters:
     - view: The view to add a shadow to.
     - color: The color of the shadow.
     - opacity: The opacity of the shadow.
     - radius: The radius of the shadow.
     - offset: The offset of the shadow.
     */
    func addShadow(view: UIView, color: CGColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = color
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
}
