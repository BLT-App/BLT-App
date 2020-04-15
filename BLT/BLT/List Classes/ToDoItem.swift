//
//  ToDoItem.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import Datez
import RealmSwift

///A to-do item is an item representing a to-do in the list.
class ToDoItem: Object {

	/// The name of the class that the to-do is associated with.
	@objc dynamic var className: String = ""

	/// The title of the to-do.
	@objc dynamic var title: String = ""

	/// A description of the to-do and any resources/materials that are needed.
	@objc dynamic var assignmentDescription: String? = ""

	/// A due date fot the to-do.
	@objc dynamic var dueDate: Date = Date()

	/// Date of creation
	@objc dynamic var dateCreated: Date = Date()

	/// Date of Completion
	@objc dynamic var dateCompleted: Date? = nil

    /// Identifier
    @objc dynamic var identifier: String = UUID().uuidString

	/// Time Spent In Focus Mode
	@objc dynamic var timeSpentInFocusMode: TimeInterval = 0
    
	/// Whether the to-do item is completed.
	@objc dynamic var completed: Bool = false

    /// whether the to-do item has been deleted
    @objc dynamic var deleted: Bool = false
    
	/// Completes the current task.
	func completeTask(mark: GeneralEventType) {
		if !completed {
			completed = true
			dateCompleted = dateManager.date
            globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: mark, currentDate: dateManager.date))
		}
	}

    /// undeletes a task
    func undoDeleteTask(){
        if deleted {
            deleted = false
            //globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .unmarkedComplete, currentDate: currentDate))
        } else {
            print("Not Quite Sure How You Got Here...")
        }
    }
    
    /// marks an item as deleted
    func markDeleted(){
        self.deleted = true
    }
    
    /**
     returns whether the function is deleted
     - Returns: the value of the deleted variable for the item
    */
    func isDeleted()-> Bool {
        return self.deleted
    }
    
	/// Uncompletes a task.
	func undoCompleteTask() {
        if completed {
            completed = false
            dateCompleted = nil
            globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .unmarkedComplete, currentDate: dateManager.date))
        }
	}
    
	/// Checks whether a task is completed.
	///  - Returns: The state of completion of the item.
	func isCompleted() -> Bool {
		return completed
	}

	/// Initializes A New ToDoItem
    required init() {
		print("Item with ID \(self.identifier) and Title \(self.title) was created")
        //globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .created, currentDate: dateManager.date))
	}
    
    /// Returns the days between now and the due date.
    func getDueCounter() -> Int {
        let calendar = NSCalendar.current
        let dueDay = calendar.startOfDay(for: dueDate)
        let nowDay = calendar.startOfDay(for: dateManager.date)
        let inBetween = calendar.dateComponents([.day], from: nowDay, to: dueDay).day
        return inBetween!
    }
    
    /// Returns the due date as a relative time measure implemented in a string.
    func getDueString() -> String {
        if getDueCounter() == 0 {
            return "Due today"
        } else if getDueCounter() < 0 {
            return "Due \(abs(getDueCounter())) days ago"
        } else {
            return "Due in \(getDueCounter()) days"
        }
    }

	/// Marks an item as completed
	func markCompleted() -> Bool {
		self.completed = true
		return true
	}
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

// ToDoItems have a strict ordering using the duedate. 
extension ToDoItem: Comparable {
	static func <(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
		return lhs.getDueCounter() < rhs.getDueCounter()
	}

	static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
		return lhs.getDueCounter() == rhs.getDueCounter()
	}
}
