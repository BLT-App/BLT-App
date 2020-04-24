//
//  ListViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import SwiftReorder
import UserNotifications
import LBConfettiView
import gooey_cell

/// Main view controller of the to do list.
class ListViewController: UIViewController {
	/// Tableview of the To Do cards.
	@IBOutlet weak var tableView: UITableView!

	/// Background waterview.
	@IBOutlet weak var waterView: UIView!

	/// Container view for the top card. Allows for visual effects.
	@IBOutlet weak var tableContainerView: UIView!

	/// View to contain shadows for main summary card (top card on the screen).
	@IBOutlet weak var shadowView: UIView!

	/// Add task button (round blue plus).
	@IBOutlet weak var addButton: UIButton!

	/// Label that shows the number of assignments left.
	@IBOutlet weak var assignmentsLeftLabel: UILabel!

	/// Point counter.
	@IBOutlet weak var pointsCounter: UILabel!

	/// IndexPath of item to be deleted (for storage).
	var deleteListIndexPath: IndexPath?

	/// UIView of Confetti.
	var confettiView: ConfettiView?

	/// Selected index (for segues).
	var selectedIndex: Int = -1

	/// The water/waves view.
	var waves: WaterView = WaterView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    ///Enum Specifying Last Action Done For Shake-To-Undo To Work
    enum LastActions {
        ///No Action Has Been Taken This Session
        case none
        ///An Item Was Deleted Last
        case deletedItem
        ///And Item Was Completed Last
        case completedItem
    }
    
    ///Holds The Last Action Taken By The User
    var lastAction: LastActions = .none

	/// View did load function.
	override func viewDidLoad() {
		super.viewDidLoad()
        
		createWave()

		let confV = ConfettiView(frame: self.view.bounds)
		confV.style = .star
		confV.intensity = 0.7
		self.view.addSubview(confV)
		confettiView = confV

		// Programmatically sets up rounded views.
		roundContainerView(cornerRadius: 40, view: tableContainerView, shadowView: shadowView)
		addShadow(view: shadowView, color: UIColor.gray.cgColor, opacity: 0.2, radius: 10, offset: CGSize(width: 0, height: 5))
		addShadow(view: addButton, color: UIColor.blue.cgColor, opacity: 0.1, radius: 5, offset: .zero)

		tableView.reorder.delegate = self

		globalData.updateCourses(fromList: myToDoList)
		update()

		print("Currently \(realmManager.realm.objects(DatabaseEvent.self).count) in log")
	}
    
    override func viewDidLayoutSubviews() {
        if UserDefaults.standard.object(forKey: "HasOnboarded") == nil {
            UserDefaults.standard.set(true, forKey: "HasOnboarded")
            performSegue(withIdentifier: "showOnboarding", sender: self)
        }
    }

    /**
     allows the viewcontroller to respond to touch events
     - Returns: true
    */
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    /**
     runs whenever a motion occurs, brings back a recently
     - Parameters:
     - motion: the type of motion that occurs
     - with event: the type of event
    */
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion  == .motionShake {
            print("shook")
            
            if lastAction == .none {
                /// TODO: Create A Popup Message About Shake-To-Undo
                print("No Actions Taken This Session")
                return
            } else if lastAction == .completedItem {
                /**
                if let itemToRestore: ToDoItem = myToDoList.completedList.popLast() {
                    itemToRestore.undoCompleteTask()
                    myToDoList.uncompletedList.append(itemToRestore)
                    insertNewTask()
                    update()
                } else {
                    print("Error Occurred")
                }
                */
            } else if lastAction == .deletedItem {
                /**
                if let itemToRestore: ToDoItem = myToDoList.deletedList.popLast() {
                    itemToRestore.undoDeleteTask()
                    myToDoList.uncompletedList.append(itemToRestore)
                    insertNewTask()
                    update()
                } else {
                    print("Error Occurred")
                }
                */
            }
        }
    }
    
	/// View did appear function. (If a new task is added then put the task into the tableView. )
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if myToDoList.uncompletedList.count > tableView.numberOfRows(inSection: 0) {
			insertNewTask()
		}
	}

	/// View will appear function. (updates screen)
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		update()
	}

	/// Updates screen.
	func update() {
		if globalData.wantsListByDate {
			//myToDoList.sortList()
			tableView.reorder.delegate = nil
		} else {
			tableView.reorder.delegate = self
		}
		updateText()
		tableView.reloadData()
	}

	/// Updates text on the page.
	func updateText() {
		let pluralSingularAssignment = (myToDoList.uncompletedList.count == 1) ? "assignment" : "assignments"
		assignmentsLeftLabel.text = "\(myToDoList.uncompletedList.count) \(pluralSingularAssignment) left."
		updatePointsCounter(myToDoList.points)
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

	/// Sets up wave view in the background.
	func createWave() {
		waves = WaterView(frame: waterView.frame)
		waves.numberOfWaves = 8
		waves.amplitude = self.view.frame.height / 40.0
		waterView.addSubview(waves)
	}

	/**
	 Creates a rounded container view.
	 - parameters:
		- cornerRadius: The corner radius of the rounded container.
		- view: The UIView to round.
		- shadowView: The accompanying shadowView of the main view to round.
	 */
	func roundContainerView(cornerRadius: Double, view: UIView, shadowView: UIView) {
		let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = view.bounds
		maskLayer.path = path.cgPath
		view.layer.mask = maskLayer

		shadowView.layer.cornerRadius = CGFloat(cornerRadius)
		shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
	}

	/// Updates and animates the insertion of a new task.
	func insertNewTask() {
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.beginUpdates()
		tableView.insertRows(at: [indexPath], with: .right)
		tableView.endUpdates()
	}

	/// Prepares for going into a specific item view.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "itemViewSegue" {
			if let destination = segue.destination as? ItemViewController {
				destination.delegate = self
				if selectedIndex != -1 {
					destination.targetIndex = selectedIndex
				}
			}
		}
	}
}

/// Conforms to Table View classes.
extension ListViewController: UITableViewDataSource, UITableViewDelegate, TableViewReorderDelegate {

	/// Returns the number of rows in table view.
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myToDoList.uncompletedList.count
	}

	/// Returns the cell with correct content in table view.
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let spacer = tableView.reorder.spacerCell(for: indexPath) {
			return spacer
		}

		let toDoItem = myToDoList.uncompletedList[indexPath.row]
		var cell: ToDoTableViewCell = ToDoTableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		if let tempcell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell {
			cell = tempcell
		}

		cell.setItem(item: toDoItem)
        cell.gooeyCellDelegate = self
        
		return cell
	}

	/// Selected row at path.
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedIndex = indexPath.row
		performSegue(withIdentifier: "itemViewSegue", sender: self)
	}

	/// Reordered item.
	func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		//let movedItem = myToDoList.uncompletedList[sourceIndexPath.row]
		//myToDoList.uncompletedList.remove(at: sourceIndexPath.row)
		//myToDoList.uncompletedList.insert(movedItem, at: destinationIndexPath.row)
        print("Disabled Reordering For Database Migration")
	}
    
    /// Creates Confetti On The Screen
    ///
    /// - Parameter seconds: Number of Seconds Confetti Should Appear For
    func createConfetti(seconds: Double) {
        if let confettiView = self.confettiView {
            confettiView.start()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if let confettiView = self.confettiView {
                confettiView.stop()
            }
        }
    }
    
    /// Completes The Item At The Specified Index
    ///
    /// - Parameter index: Index of Item
    func completeItemAt(index: IndexPath) {
        let item = myToDoList.uncompletedList[index.row]
        let realm = realmManager.realm
        do {
            try realm.write {
                item.completeTaskInListView()
            }
        } catch {
            print("Exception Occurred")
        }
        createConfetti(seconds: 1.0)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [index], with: .right)
        self.tableView.endUpdates()
        self.updateText()
        let oldPoints = myToDoList.points
        myToDoList.points += 10
        self.incrementPoints(oldPoints: oldPoints)
        self.lastAction = .completedItem
    }

	/**
	 Prompts a confirmation for a deletion of a ToDoItem.
	 - parameters:
		- itemToDelete: The ToDoItem that is going to be deleted.
	 */
    func confirmDelete(_ itemToDelete: ToDoItem, index: IndexPath) {
        deleteListIndexPath = index
        let alertMessage = "Are you sure you want to delete the item \(itemToDelete.title)?"
		let alert = UIAlertController(title: "Delete To-Do Item", message: alertMessage, preferredStyle: .actionSheet)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)

		alert.addAction(deleteAction)
		alert.addAction(cancelAction)

		self.present(alert, animated: true, completion: nil)
	}
    
    /// Handles Deletion Of An Item
	func handleDeleteItem(alertAction: UIAlertAction!) {
		if let indexPath = deleteListIndexPath {
            let deletedItem = myToDoList.uncompletedList[indexPath.row]
            let realm = realmManager.realm
            do {
                try realm.write {
                    deletedItem.markDeleted()
                }
            } catch {
                print("Exception Occurred")
            }
			tableView.beginUpdates()
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.endUpdates()
            tableView.reloadData()
			deleteListIndexPath = nil
			updateText()
            lastAction = .deletedItem
		}
	}
	
    /// Cancels the deletion of an item.
	func cancelDeleteItem(alertAction: UIAlertAction!) {
		deleteListIndexPath = nil
	}

	/// Animates a point incrementation with the pointCounter
	func incrementPoints(oldPoints: Int) {
		let newValue = myToDoList.points
		let diff = newValue - oldPoints
		let deltaT: Double = 1.0 / Double(diff)
        
        if diff < 0 {
            let newDiff = abs(diff)
            for inc in 1...newDiff {
                let seconds = Double(inc) * deltaT
                let currentPoints = oldPoints - inc
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.updatePointsCounter(currentPoints)
                }
            }
        } else {
            for inc in 1...diff {
                let seconds = Double(inc) * deltaT
                let currentPoints = oldPoints + inc
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.updatePointsCounter(currentPoints)
                }
            }
        }
	}

	/// Updates the point counter.
	func updatePointsCounter(_ points: Int) {
		pointsCounter.text = "\(points) ⭐"
	}
}

extension ListViewController: GooeyCellDelegate {
    
    func gooeyCellActionConfig(for cell: UITableViewCell, direction: GooeyEffect.Direction) -> GooeyEffectTableViewCell.ActionConfig? {
        let color: UIColor
        if let toDoCell = cell as? ToDoTableViewCell {
            color = toDoCell.classLabel.backgroundColor ?? #colorLiteral(red: 0.02649694125, green: 0.3554508787, blue: 0.4980392157, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.02649694125, green: 0.3554508787, blue: 0.4980392157, alpha: 1)
        }
        
        //let image = direction == .toLeft ? #imageLiteral(resourceName: "image_cross") : #imageLiteral(resourceName: "image_mark")
        //let isCellDeletingAction = direction == .toLeft
        
        let effectConfig = GooeyEffect.Config(color: color, image: nil)
        
        let actionConfig = GooeyEffectTableViewCell.ActionConfig(effectConfig: effectConfig,
                                                                 isCellDeletingAction: false)
        return actionConfig
    }
    
    func gooeyCellActionTriggered(for cell: UITableViewCell,
                                  direction: GooeyEffect.Direction) {
        switch direction {
        case .toLeft:
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let itemToDelete = myToDoList.uncompletedList[indexPath.row]
            confirmDelete(itemToDelete, index: indexPath)
        case .toRight:
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            completeItemAt(index: indexPath)
        }
    }
}
