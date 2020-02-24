//
//  SettingsViewController.swift
//  BLT
//
//  Created by LorentzenN on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import LBConfettiView

/// The ViewController that controls the Focus View.
class FocusViewController: UIViewController, FocusTimerDelegate, FMPopUpViewControllerDelegate {

	/// The ToDoItem of the current task.
	var currentTask: ToDoItem = ToDoItem(className: "", title: "", description: "", dueDate: Date(), completed: true)

	/// Current index of the task displayed
	var currentTaskNum: Int = 0

	/// Timer that handles the countdown
	var myTimer: FocusTimer = FocusTimer(countdownTime: 0)

    /// the popup object that will be displayed
	var popup: FMPopUpViewController = FMPopUpViewController()
    
    /// the label for the current task
	@IBOutlet weak var lblCurrentTask: UILabel!

    /// the label for the current task description
	@IBOutlet weak var lblCurrentTaskDesc: UILabel!
    
    /// the button to complete a task
	@IBOutlet weak var btnCompleteTask: UIButton!
    
    /// the button to end focus mode
	@IBOutlet weak var endFocusModeButton: UIButton!
    
    /// displays the timer
	@IBOutlet weak var timerDisplay: UILabel!

    /// the view that the items are viewed in
	@IBOutlet weak var itemView: UIView!
    
    /// the label that displays class
	@IBOutlet weak var classLabel: InsetLabel!

    /// the progress bar used as a timer
	@IBOutlet weak var progressTimer: UIProgressView!

    /// the label that displays points
	@IBOutlet weak var pointsCounter: UILabel!

    /// confetti view
	var confettiView: ConfettiView?

    /// variable for whether or not to leave the focus view
	var leaveView: Bool = false

    /// To run when the view did finish loading.
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButtons()

		let confV = ConfettiView(frame: self.view.bounds)
		confV.style = .star
		confV.intensity = 0.7
		self.view.addSubview(confV)
		confettiView = confV

		myTimer = FocusTimer(countdownTime: 0.0)
		myTimer.delegate = self
		progressTimer.transform = progressTimer.transform.scaledBy(x: 1, y: 10)
		progressTimer.layer.cornerRadius = 20
		progressTimer.clipsToBounds = true
		setupClassLabel()

		itemView.layer.cornerRadius = 20.0
		itemView.layer.shadowColor = UIColor.gray.cgColor
		itemView.layer.shadowOpacity = 0.2
		itemView.layer.shadowOffset = CGSize(width: 0, height: 4)
		itemView.layer.shadowRadius = 5.0
		itemView.layer.masksToBounds = false
	}

    /// Sets up the label that displays class.
	func setupClassLabel() {
		classLabel.sizeThatFits(CGSize(width: classLabel.frame.size.width, height: 30))
		classLabel.layer.cornerRadius = 15.0
		classLabel.clipsToBounds = true
	}

    /// Runs if the view appears.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		hideTabBar()
		print("view has appeared")
		print(globalData.includeEndFocusButton)
    
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
    
		if let temp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as? FMPopUpViewController {
			self.popup = temp
		}
		self.addChild(popup)
		popup.view.frame = self.view.frame
		self.view.addSubview(popup.view)
		popup.didMove(toParent: self)
		popup.delegate = self

		//performSegue(withIdentifier: "Popup", sender: nil)
	}

    /// Runs if the view will appear.
	override func viewWillAppear(_ animated: Bool) {
		setCurrentTask()

		if (!globalData.includeEndFocusButton && myToDoList.list.count > 0) {
			endFocusModeButton.isEnabled = false
			endFocusModeButton.isHidden = true
		} else {
			endFocusModeButton.isEnabled = true
			endFocusModeButton.isHidden = false
		}
		progressTimer.setProgress(1, animated: false)
		//myTimer.mins = 2
		//myTimer.secs = 00
		//myTimer.runTimer()
	}
    
    /// Runs when the view will disappear.
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
		if (myToDoList.list.count > 0) {
			for itemNum in 0..<myToDoList.list.count {
				if (notFoundNextItem) {
					if !(myToDoList.list[itemNum].isCompleted()) {
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
				classLabel.backgroundColor = globalData.subjects[currentTask.className]?.uiColor
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

	/**
     Runs when the timer has updated its own values
     - Parameters:
        - timerReadout: the string that the timer prints when it updates
    */
	func valsUpdated(_ timerReadout: String) {
		timerDisplay.text = timerReadout
		var timeLeft = myTimer.cdt

		progressTimer.setProgress(Float(timeLeft / myTimer.totalSecs), animated: false)
		print("valsUpdated called ")
		print(timeLeft)
		print("totalSecs: ", myTimer.totalSecs)
	}

	/// Runs when the timer has hit zero
	func timerEnded() {
		print("timerEnded called")

		endFocusModeButton.isEnabled = true
		endFocusModeButton.isHidden = false

	}

	/// Pressing on complete task that queues the next task.
	@IBAction func completeTaskPress(_ sender: UIButton) {
		if let confettiView = self.confettiView {
			confettiView.start()
		}
		myToDoList.list[currentTaskNum].completeTask(mark: .markedCompletedInFocusMode)
		myToDoList.list.remove(at: currentTaskNum)
		setCurrentTask()
		let seconds = 1.0
		let oldPoints = myToDoList.points
		myToDoList.points += 10
		self.incrementPoints(oldPoints: oldPoints)
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			if let confettiView = self.confettiView {
				confettiView.stop()
			}
		}
	}

	/// Ending focus mode brings user back to the list view.
	@IBAction func endFocusModeHit(_ sender: UIButton) {
		showTabBar()
		self.tabBarController?.selectedIndex = 0
	}

    /// runs when the user exits the pop up
	func didChooseCancel() {
		print("Called Did Choose Cancel In Focus Mode")
		showTabBar()
		self.tabBarController?.selectedIndex = 0
	}

    /**
     updates values for timer and starts the timer in focus mode
     - Parameters:
        - duration: the amount of time that the timer is to be set to
    */
	func didChooseTime(duration: TimeInterval) {
		print("Chose A Time")
		myTimer.cdt = duration
		myTimer.totalSecs = myTimer.cdt
		myTimer.runTimer()

	}

	/// Animates a point incrementation with the pointCounter
	func incrementPoints(oldPoints: Int) {
		let newValue = myToDoList.points
		let diff = newValue - oldPoints
		let deltaT: Double = 1.0 / Double(diff)
		for inc in 1...diff {
			let seconds = Double(inc) * deltaT
			let currentPoints = oldPoints + inc
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.updatePointsCounter(currentPoints)
			}
		}
	}

	/// Updates the point counter.
	func updatePointsCounter(_ points: Int) {
		pointsCounter.text = "\(points) ⭐"
	}
}
