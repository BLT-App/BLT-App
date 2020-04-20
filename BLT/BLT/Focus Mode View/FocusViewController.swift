//
//  SettingsViewController.swift
//  BLT
//
//  Created by LorentzenN on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import LBConfettiView
import VerticalCardSwiper
import RetroProgress
import RealmSwift

/// The ViewController that controls the Focus View.
class FocusViewController: UIViewController, FocusTimerDelegate, FMPopUpViewControllerDelegate {

	/// The ToDoItem of the current task.
	var currentTask: ToDoItem?
  
	/// Current index of the task displayed
	var currentTaskNum: Int = 0

	/// Timer that handles the countdown
	var myTimer: FocusTimer = FocusTimer(countdownTime: 0)

    /// the popup object that will be displayed
	var popup: FMPopUpViewController = FMPopUpViewController()
    
    /// List Used For Temporary Reordering of ToDoItems
    var focusModeList: [ToDoItem] = []
    
    /// Used For Singleton Pattern For Changeover Check
    var isRunningChangeoverCheck: Bool = false
    
    /// the button to end focus mode
    @IBOutlet weak var endFocusModeButton: UIBarButtonItem!
    
    /// displays the timer
	@IBOutlet weak var timerDisplay: UILabel!

    /// A container to position the progress view
    @IBOutlet weak var progressContainer: UIView!
    
    /// Progress bar.
    var progressView: ProgressView = ProgressView(frame: CGRect.zero)

    /// Points counter in the navigation bar.
    @IBOutlet weak var pointsCounterBar: UIBarButtonItem!
    
    /// Card views.
    @IBOutlet weak var verticalCardSwiper: VerticalCardSwiper!
    
    /// Prompts for completion.
    @IBOutlet weak var completePrompt: UILabel!
    
    /// confetti view
	var confettiView: ConfettiView?

    /// variable for whether or not to leave the focus view
	var leaveView: Bool = false
    
    /// Time the last item started being studied
    var lastItemStartTime: Date = dateManager.date

    /// To run when the view did finish loading.
	override func viewDidLoad() {
		super.viewDidLoad()
        
        verticalCardSwiper.delegate = self
        verticalCardSwiper.datasource = self
        verticalCardSwiper.cardSpacing = 200
        verticalCardSwiper.isStackOnBottom = false
        verticalCardSwiper.stackedCardsCount = 1
        verticalCardSwiper.sideInset = 50
        
        // register cardcell for storyboard use
        verticalCardSwiper.register(nib: UINib(nibName: "FocusCard", bundle: nil), forCellWithReuseIdentifier: "FocusCell")
        
		let confV = ConfettiView(frame: self.view.bounds)
		confV.style = .star
		confV.intensity = 0.7
		self.view.addSubview(confV)
		confettiView = confV

		myTimer = FocusTimer(countdownTime: 0.0)
		myTimer.delegate = self
        
        // *** Setup Progress Bar
        progressView = ProgressView(frame: progressContainer.frame)
        progressView.numberOfSteps = 0
        progressView.progressInset = .zero
        progressView.layer.cornerRadius = 15
        setCurrentProgressColor()
        self.view.addSubview(progressView)
        
        setupCompletePrompt()

//        itemView.layer.cornerRadius = 20.0
        progressView.layer.shadowOpacity = 0.2
        progressView.layer.shadowOffset = CGSize(width: 0, height: 4)
        progressView.layer.shadowRadius = 5.0
        progressView.layer.masksToBounds = false
        
        stylizeEndFocusModeButton()
        stylizePointsCounterBar()
        
        self.currentTask = getCurrentTask()
	}
    
    func getCurrentTask() -> ToDoItem? {
        if let index = verticalCardSwiper.focussedCardIndex {
            return focusModeList[index]
        }
        return nil
    }
    
    ///Sets Style Of End Focus Mode Button
    func stylizeEndFocusModeButton() {
        endFocusModeButton.tintColor = .red
        endFocusModeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 18, weight: .semibold)], for: .normal)
        endFocusModeButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 18, weight: .semibold)], for: .selected)
    }
    
    ///Sets Style Of Counter Bar
    func stylizePointsCounterBar() {
        pointsCounterBar.tintColor = .black
        pointsCounterBar.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 18, weight: .semibold)], for: .normal)
        pointsCounterBar.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 18, weight: .semibold)], for: .selected)
    }
    
	/// Runs when view did load all subviews (to load colors)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCurrentProgressColor()
    }

	/// Changes progress bar color.
	/// - Parameter color: Color to change color to.
    func changeProgressColor(color: UIColor) {
        progressView.layer.borderColor = color.cgColor
        progressView.trackColor = UIColor.white
        progressView.progressColor = color
        progressView.layer.shadowColor = color.cgColor
    }

    /// Sets progress bar color based on the current card.
    func setCurrentProgressColor() {
        if let index = verticalCardSwiper.focussedCardIndex {
            let className = myToDoList.uncompletedList[index].className
            if let color = globalData.subjects[className]?.uiColor {
                changeProgressColor(color: color)
            }
            
        }
    }

    /// Sets up the label that displays completion prompting.
	func setupCompletePrompt() {
        completePrompt.layer.cornerRadius = 25.0
        completePrompt.layer.shadowOpacity = 0.2
        completePrompt.layer.shadowOffset = CGSize(width: 0, height: 4)
        completePrompt.layer.shadowRadius = 5.0
        completePrompt.layer.shadowColor = UIColor.gray.cgColor
        completePrompt.layer.masksToBounds = false
        completePrompt.clipsToBounds = true
        completePrompt.alpha = 0.0
	}

    /// Runs if the view appears.
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		hideTabBar()
		print("view has appeared")
		print(globalData.includeEndFocusButton)
        
        self.updatePointsCounter(myToDoList.points)
    
		if let temp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as? FMPopUpViewController {
			self.popup = temp
		}
		self.addChild(popup)
		popup.view.frame = self.view.frame
        self.view.addSubview(popup.view)
        self.view.bringSubviewToFront(popup.view)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
		popup.didMove(toParent: self)
		popup.delegate = self
		
	}

    /// Runs if the view will appear.
	override func viewWillAppear(_ animated: Bool) {
        focusModeList = []
        for item in myToDoList.uncompletedList {
            focusModeList.append(item)
        }
        
        verticalCardSwiper.reloadData()
        if verticalCardSwiper.scrollToCard(at: 0, animated: false) {
            print("Going Back To 0")
        }
    
		if !globalData.includeEndFocusButton && myToDoList.uncompletedList.count > 0 {
			endFocusModeButton.isEnabled = false
		} else {
			endFocusModeButton.isEnabled = true
		}
    progressView.progress = 1.0
	}
    
    /// Runs when the view will disappear.
	override func viewWillDisappear(_ animated: Bool) {
		myTimer.stopRunning()
        let realm = realmManager.realm
        do {
            try realm.write {
                currentTask?.stoppedStudyingInFocusMode(duration: dateManager.date.timeIntervalSince(lastItemStartTime))
            }
        } catch {
            print("Exception Occurred")
        }
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
  
	/**
     Runs when the timer has updated its own values
     - Parameters:
        - timerReadout: the string that the timer prints when it updates
    */
	func valsUpdated(_ timerReadout: String) {
		timerDisplay.text = timerReadout
		let timeLeft = myTimer.cdt
		print("valsUpdated called ")
		print(timeLeft)
		print("totalSecs: ", myTimer.totalSecs)
	}

	/// Runs when the timer has hit zero
	func timerEnded() {
		print("timerEnded called")
        
		endFocusModeButton.isEnabled = true

	}

    /// Ending focus mode brings user back to the list view.
    @IBAction func endFocusModeHit(_ sender: UIBarButtonItem) {
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
        // Also shows the navigation bar for simplicity.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
		print("Chose A Time")
		myTimer.cdt = duration
		myTimer.totalSecs = myTimer.cdt
		myTimer.runTimer()
        progressView.animateProgress(to: 0.0, duration: myTimer.totalSecs / Double(dateManager.timeMultiplier))
        currentTask = getCurrentTask()
        let realm = realmManager.realm
        do {
            try realm.write {
                currentTask?.startedStudyingInFocusMode()
            }
        } catch {
            print("Exception Occurred")
        }
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
		pointsCounterBar.title = "\(points) ⭐"
	}
}

extension FocusViewController: VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
	/// Number of cards to show in list.
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return focusModeList.count
    }

	/// Returns the CardCell of the current item.
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "FocusCell", for: index) as? FocusCardCell {
            cardCell.setupCard(fromItem: focusModeList[index])
            return cardCell
        }
        return CardCell()
    }

	/// Called when the VerticalCardSwiper has been scrolled.
    ///
    /// - Parameter verticalCardSwiperView:
    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        if let item = currentTask {
            changeoverCheckStart(oldItem: item)
        }
        
        if let index = verticalCardSwiper.focussedCardIndex {
            if let color = globalData.subjects[focusModeList[index].className]?.uiColor {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.changeProgressColor(color: color)
                    }, completion: { (_) in
                        
                    })
                }
            }
        }
    }

	/// Called when a card has been dragged.
    ///
    /// - Parameters:
    ///   - card:
    ///   - index:
    ///   - swipeDirection:
    func didDragCard(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        switch swipeDirection {
        case .Right:
            dragCardRight()
        case .None:
            dragCardNeutral()
        case .Left:
            dragCardLeft()
        default:
            return
        }
    }

	/// Called when swiping is cancelled.
    func didCancelSwipe(card: CardCell, index: Int) {
        dragCardNeutral()
    }

	/// Called when card is dragged to the right.
    func dragCardRight() {
        self.completePrompt.isHidden = false
        completePrompt.text = "Complete"
        completePrompt.backgroundColor = UIColor.blue
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.completePrompt.alpha = 0.8
            }, completion: { (_) in
                
            })
        }
    }

	/// Called when card is dragged to the left.
    func dragCardLeft() {
        self.completePrompt.isHidden = false
        completePrompt.text = "Do Later"
        completePrompt.backgroundColor = UIColor.lightGray
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.completePrompt.alpha = 0.8
            }, completion: { (_) in
                
            })
        }
    }

	/// Called when card is at a neutral position.
    func dragCardNeutral() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.completePrompt.alpha = 0.0
            }, completion: { (_) in
                self.completePrompt.isHidden = true
            })
        }
    }

	/// Called when card will be swiped away.
    ///
    /// - Parameters:
    ///   - card: Card being swiped
    ///   - index: Index of card being swiped
    ///   - swipeDirection: Direction of swipe
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        if index < focusModeList.count {
			switch swipeDirection {
			case .Left:
                let task = focusModeList[index]
                focusModeList.append(task)
                verticalCardSwiper.insertCards(at: [focusModeList.count - 1])
                focusModeList.remove(at: index)
                changeoverCheckStart(oldItem: task)
			default:
				completeTask(index: index)
			}
        }
    }

	/// Called when a card has been swiped away.
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        dragCardNeutral()
        setCurrentProgressColor()
    }

	/// Called when a task is completed
	/// - Parameter index: Index of completed card.
    func completeTask(index: Int) {
        let task = focusModeList.remove(at: index)
        let realm = realmManager.realm
        currentTask = getCurrentTask()
        if realm.isInWriteTransaction {
            task.completeTaskInFocusMode(duration: dateManager.date.timeIntervalSince(lastItemStartTime))
            currentTask?.startedStudyingInFocusMode()
        } else {
            do {
                try realm.write {
                    task.completeTaskInFocusMode(duration: dateManager.date.timeIntervalSince(dateManager.date))
                    currentTask?.startedStudyingInFocusMode()
                }
            } catch {
                print("Exception Occurred")
            }
        }
        lastItemStartTime = dateManager.date
        
        if let confettiView = self.confettiView {
            confettiView.start()
        }
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
    
    func changeoverCheckStart(oldItem: ToDoItem) {
        if !isRunningChangeoverCheck {
            isRunningChangeoverCheck = true
            let oldToDo = oldItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if oldToDo.identifier != self.getCurrentTask()?.identifier {
                    let realm = realmManager.realm
                    if realm.isInWriteTransaction {
                        oldToDo.stoppedStudyingInFocusMode(duration: dateManager.date.timeIntervalSince(self.lastItemStartTime))
                        self.currentTask = self.getCurrentTask()
                        self.currentTask?.startedStudyingInFocusMode()
                    } else {
                        do {
                            try realm.write {
                                oldToDo.stoppedStudyingInFocusMode(duration: dateManager.date.timeIntervalSince(self.lastItemStartTime))
                                self.currentTask = self.getCurrentTask()
                                self.currentTask?.startedStudyingInFocusMode()
                            }
                        } catch {
                            print("Unexpected Failure")
                        }
                    }
                    self.lastItemStartTime = dateManager.date
                }
                self.isRunningChangeoverCheck = false
            }
        }
    }
}
