//
//  SettingsViewController.swift
//  BLT
//
//  Created by LorentzenN on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit

/// The ViewController that controls the Focus View.
class FocusViewController: UIViewController, FocusTimerDelegate {

    /// The ToDoItem of the current task.
    var currentTask: ToDoItem = ToDoItem(className: "", title: "", description: "", dueDate: Date(), completed: true)
    /// Current index of the task displayed
    var currentTaskNum: Int = 0
    /// Timer that handles the countdown
    var myTimer: FocusTimer = FocusTimer(1, 00)

    @IBOutlet weak var lblCurrentTask: UILabel!
    
    @IBOutlet weak var lblCurrentTaskDesc: UILabel!
    
    @IBOutlet weak var btnCompleteTask: UIButton!
    
    @IBOutlet weak var endFocusModeButton: UIButton!
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet weak var classLabel: InsetLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        
        myTimer = FocusTimer(1, 00)
        myTimer.delegate = self
        
        setupClassLabel()
        
        itemView.layer.cornerRadius = 20.0
        itemView.layer.shadowColor = UIColor.gray.cgColor
        itemView.layer.shadowOpacity = 0.2
        itemView.layer.shadowOffset = CGSize(width: 0, height: 4)
        itemView.layer.shadowRadius = 5.0
        itemView.layer.masksToBounds = false
    }
    
    func setupClassLabel() {
        classLabel.sizeThatFits(CGSize(width: classLabel.frame.size.width, height: 30))
        classLabel.layer.cornerRadius = 15.0
        classLabel.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideTabBar()
        print("view has appeared")
        print(userData.includeEndFocusButton)
//        if includeEndButton{
//            endFocusModeButton.isEnabled = false
//            endFocusModeButton.isHidden = true
//            print("isEnabled: ", endFocusModeButton.isEnabled)
//        }
//
//        else{
//            endFocusModeButton.isEnabled = true
//            endFocusModeButton.isHidden = false
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrentTask()
        
        if (!userData.includeEndFocusButton && myToDoList.list.count > 0) {
            endFocusModeButton.isEnabled = false
            endFocusModeButton.isHidden = true
        } else {
            endFocusModeButton.isEnabled = true
            endFocusModeButton.isHidden = false
        }
        
        myTimer.mins = 1
        myTimer.secs = 00
        myTimer.runTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myTimer.stopRunning()
    }
    
    /// Stylizes buttons with curves.
    func setupButtons() {
        // Sets up curves
        btnCompleteTask.layer.cornerRadius = 25.0
        btnCompleteTask.layer.shadowColor = UIColor.blue.cgColor
        btnCompleteTask.layer.shadowOpacity = 0.2
        btnCompleteTask.layer.shadowOffset = CGSize(width: 0, height: 0)
        btnCompleteTask.layer.shadowRadius = 5.0
        btnCompleteTask.layer.masksToBounds = false
        
        endFocusModeButton.layer.cornerRadius = 18.0
        endFocusModeButton.layer.shadowColor = UIColor.red.cgColor
        endFocusModeButton.layer.shadowOpacity = 0.2
        endFocusModeButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        endFocusModeButton.layer.shadowRadius = 5.0
        endFocusModeButton.layer.masksToBounds = false

    }
    
    /// Hides the Tab Bar controller.
    func hideTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        let height = (frame?.size.height)!
        frame?.origin.y = self.view.frame.size.height + height
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
    }

    /// Shows the Tab Bar controller.
    func showTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        let height = (frame?.size.height)!
        frame?.origin.y = self.view.frame.size.height - height
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
    }
    
    /// Sets the current task to the first task in the to-do list.
    func setCurrentTask() {
        var notFoundNextItem: Bool = true
        if(myToDoList.list.count > 0) {
            for itemNum in 0 ..< myToDoList.list.count {
                if (notFoundNextItem) {
                    if !(myToDoList.list[itemNum].completed) {
                        currentTaskNum = itemNum
                        notFoundNextItem = false
                    }
                }
            }
            if !notFoundNextItem {
                currentTask = myToDoList.list[currentTaskNum]
                lblCurrentTask.text = currentTask.title
                lblCurrentTaskDesc.text = currentTask.description
                classLabel.text = currentTask.className
                classLabel.backgroundColor = userData.subjects[currentTask.className]?.uiColor
                lblCurrentTaskDesc.isHidden = false
                classLabel.isHidden = false
                btnCompleteTask.isEnabled = true
                btnCompleteTask.isHidden = false
                
            } else {
                lblCurrentTask.text = "No Items Left To Do"
                lblCurrentTaskDesc.isHidden = true
                classLabel.isHidden = true
                btnCompleteTask.isEnabled = false
                btnCompleteTask.isHidden = true
                endFocusModeButton.isEnabled = true
                endFocusModeButton.isHidden = false
            }
        } else {
            lblCurrentTask.text = "No Items In Todo List"
            lblCurrentTaskDesc.isHidden = true
            classLabel.isHidden = true
            btnCompleteTask.isEnabled = false
            btnCompleteTask.isHidden = true
            endFocusModeButton.isEnabled = true
            endFocusModeButton.isHidden = false
        }
    }
    
    ///Runs when the timer has updated its own values
    func valsUpdated(_ timerReadout: String) {
        timerDisplay.text = timerReadout
    }
    
    ///Runs when the timer has hit zero
    func timerEnded() {
        print("timerEnded called")
        
            endFocusModeButton.isEnabled = true
            endFocusModeButton.isHidden = false

    }
    
    /// Pressing on complete task that queues the next task.
    @IBAction func completeTaskPress(_ sender: UIButton) {
        myToDoList.list[currentTaskNum].completed = true
        myToDoList.list.remove(at: currentTaskNum)
        setCurrentTask()
    }
    
    /// Ending focus mode brings user back to the list view.
    @IBAction func endFocusModeHit(_ sender: UIButton) {
        showTabBar()
        self.tabBarController?.selectedIndex = 0
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
