//
//  NewItemViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import DropDown

class NewItemViewController: UIViewController, UITextFieldDelegate {

    /// textfield with drop down add on
    @IBOutlet weak var classText: UITextField!
    
    /// Text field for the title of the ToDoItem
    @IBOutlet weak var titleText: UITextField!
    
    /// Text field for the description of the ToDoitem
    @IBOutlet weak var descText: UITextField!
    
    /// Date picker for the due date.
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // variable used for obtaining value in drop down menu
    var selected: String = ""
    
    /// Exiting button.
    @IBOutlet weak var exitButton: UIButton!
    
    var dropDown: DropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        exitButton.layer.cornerRadius = 15.0
        exitButton.layer.shadowColor = UIColor.blue.cgColor
        exitButton.layer.shadowOpacity = 0.2
        exitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        exitButton.layer.shadowRadius = 5.0
        exitButton.layer.masksToBounds = false
        titleText.delegate = self
        descText.delegate = self
        
        // Loads DropDown
        dropDown.anchorView = classText
        dropDown.dataSource = userData.subjectList
        dropDown.direction = .bottom
        dropDown.cellNib = UINib(nibName: "SubjectCell", bundle: nil)
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SubjectCell else { return }
            
            // Setup your custom UI components
            if let color = userData.subjects[item] {
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
    }

    /// Exits the modal view/screen. 
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Checks if the titles are correct, then adds it to the list.
    // let classTxt = classText.text
    @IBAction func addButton(_ sender: UIButton) {
        if let classTxt = classText.text, let titleTxt = titleText.text, let descTxt = descText.text {
            // Debug for clearing/resetting entire list.
            if (titleTxt == "clear_entire_list") {
                myToDoList.list = []
                myToDoList.storeList()
            } else if (classText.text != "" && titleTxt != "" && descTxt != "") {
                let newToDo = ToDoItem(className: classTxt, title: titleTxt, description: descTxt, dueDate: datePicker.date, completed: false)
                myToDoList.list.insert(newToDo, at: 0)
                myToDoList.storeList()
                
                //If Users Have it Set, Sort List By Due Date
                if userData.wantsListByDate {
                    myToDoList.sortList()
                }
            }
            userData.updateCourses(fromList: myToDoList)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func showDropDown(_ sender: Any) {
        updateDropDown()
        dropDown.show()
    }
    
    @IBAction func hideDropDown(_ sender: Any) {
        dropDown.hide()
    }
    
    @IBAction func subjectChanged(_ sender: UITextField) {
        updateDropDown()
        updateClassText()
    }
    
    func updateDropDown() {
        dropDown.dataSource = valuesStartingWith(classText.text ?? "", fromArray: userData.subjectList)
        dropDown.reloadAllComponents()
        dropDown.show()
    }
    
    func updateClassText() {
        let currentClass = classText.text ?? ""
        if let color = userData.subjects[currentClass] {
            classText.backgroundColor = color.uiColor
            classText.textColor = .white
        } else {
            classText.backgroundColor = .white
            classText.textColor = .black
        }
    }
    
    func valuesStartingWith(_ prefix: String, fromArray list: [String]) -> [String] {
        var returnList: [String] = []
        for testItem in list {
            if prefix == "" || testItem.contains(prefix) {
                returnList.append(testItem)
            }
        }
        return returnList
    }
    
    //Tell Text Fields To Close On Hitting Enter
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
