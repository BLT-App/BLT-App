//
//  ItemViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 11/18/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var delegate: UIViewController?
    var targetIndex: Int?
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var assignmentField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPage()
    }
    
    func loadPage() {
        print(myToDoList.list.count)
        if let thisIndex = targetIndex {
            let thisToDo = myToDoList.list[thisIndex]
            classNameField.text = thisToDo.className
            classNameField.backgroundColor = userData.subjects[thisToDo.className]?.uiColor
            assignmentField.text = thisToDo.title
            descriptionField.text = thisToDo.description
            datePicker.date = thisToDo.dueDate
        }
    }
    
    func setupButtons() {
        exitButton.layer.cornerRadius = 15.0
        exitButton.layer.shadowColor = UIColor.blue.cgColor
        exitButton.layer.shadowOpacity = 0.2
        exitButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        exitButton.layer.shadowRadius = 5.0
        exitButton.layer.masksToBounds = false
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if let classTxt = classNameField.text, let titleTxt = assignmentField.text, let descTxt = descriptionField.text, let thisIndex = targetIndex {
            // Debug for clearing/resetting entire list.
            if (classTxt != "" && titleTxt != "") {
                myToDoList.list[thisIndex] = ToDoItem(className: classTxt, title: titleTxt, description: descTxt, dueDate: datePicker.date, completed: myToDoList.list[thisIndex].completed)
                myToDoList.storeList()
                userData.updateCourses(fromList: myToDoList)
                
                //If Users Have it Set, Sort List By Due Date
                if userData.wantsListByDate {
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
