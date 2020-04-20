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
	weak var delegate: UIViewController?

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
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
	/// Loads the view.
	override func viewDidLoad() {
		super.viewDidLoad()

		setupButtons()
        
        setupCard()
		// Do any additional setup after loading the view.
	}

	/// Loads the page on appearance.
	override func viewWillAppear(_ animated: Bool) {
		loadPage()
	}

	/// Loads the page by loading in the latest task into the current card.
	func loadPage() {
		if let thisIndex = targetIndex {
            let thisToDo = myToDoList.uncompletedList[thisIndex]
            classNameField.text = thisToDo.className
            classNameField.backgroundColor = globalData.subjects[thisToDo.className]?.uiColor
            assignmentField.text = thisToDo.title
            descriptionField.text = thisToDo.assignmentDescription
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
			if classTxt != "" && titleTxt != "" {
                
                let realm = realmManager.realm
                do {
                    try realm.write {
                        let targetItem = myToDoList.uncompletedList[thisIndex]
                        targetItem.className = classTxt
                        targetItem.title = titleTxt
                        targetItem.assignmentDescription = descTxt
                        targetItem.dueDate = datePicker.date
                    }
                } catch {
                    print("Exception Occurred")
                }
                
				globalData.updateCourses(fromList: myToDoList)
                
				//If Users Have it Set, Sort List By Due Date
				if globalData.wantsListByDate {
					//myToDoList.sortList()
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

/// Extension that contains the graphical functions.
extension ItemViewController {
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
