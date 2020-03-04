//
//  ToDoItem.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import Datez

///A to-do item is an item representing a to-do in the list.
class ToDoItem: Codable, Hashable {

	/// The name of the class that the to-do is associated with.
	var className: String

	/// The title of the to-do.
	var title: String

	/// A description of the to-do and any resources/materials that are needed.
	var description: String

	/// A due date fot the to-do.
	var dueDate: Date

	/// Date of creation
	let dateCreated: Date = Date()

	/// Date of Completion
	var dateCompleted: Date? = nil

    /// Identifier
    let identifier: Int

	/// Time Spent In Focus Mode
	var timeSpentInFocusMode: TimeInterval = Date() - Date()
    
    /// Time Started Studying In Focus Mode
    private var timeStartedStudying: Date? = nil

	/// Returns the days between now and the due date.
	var dueCounter: Int {
		let calendar = NSCalendar.current
		let dueDay = calendar.startOfDay(for: dueDate)
		let nowDay = calendar.startOfDay(for: Date())
		let inBetween = calendar.dateComponents([.day], from: nowDay, to: dueDay).day
		return inBetween!
	}

	/// Returns the due date as a relative time measure implemented in a string.
	var dueString: String {
		if dueCounter == 0 {
			return "Due today"
		} else if dueCounter < 0 {
			return "Due \(abs(dueCounter)) days ago"
		} else {
			return "Due in \(dueCounter) days"
		}
	}
	/// Whether the to-do item is completed.
	private var completed: Bool = false

    /// whether the to-do item has been deleted
    private var deleted: Bool = false
    
	/// Completes the current task.
	func completeTask(mark: GeneralEventType) {
		if !completed {
			completed = true
			dateCompleted = Date()
            globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: mark, currentDate: Date()))
		}
	}

    /// undeletes a task
    func undoDeleteTask(){
        if deleted {
            deleted = false
            //globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .unmarkedComplete, currentDate: Date()))
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
            globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .unmarkedComplete, currentDate: Date()))
        }
	}
    
	/// Checks whether a task is completed.
	///  - Returns: The state of completion of the item.
	func isCompleted() -> Bool {
		return completed
	}

	/// Initializer method
	/// - Parameters:
	///   - className: Name of the class.
	///   - title: Title of the item.
	///   - description: Description of the item.
	///   - dueDate: Date object of the due date.
	///   - completed: Whether or not an item is completed.
	init(className: String, title: String, description: String,
         dueDate: Date) {
		self.className = className
		self.title = title
		self.description = description
		self.dueDate = dueDate
        self.identifier = globalTaskDatabase.myDatabaseIndex.getTaskIDForUse()
		print("Item with hash value \(self.identifier) was added")
    globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .created, currentDate: Date()))
	}

	/// Marks an item as completed
	func markCompleted() -> Bool {
		self.completed = true
		return true
	}
    
    /// Performs Necessary Setup For Studying In Focus Mode
    func startedStudyingInFocusMode() {
        timeStartedStudying = Date()
        let event: DatabaseEvent = DatabaseEvent(item: self, event: .startedStudyingInFocusMode, currentDate: Date())
        globalTaskDatabase.currentDatabaseLog.log.append(event)
    }
    
    /// Performs Necessary Actions Following End of Studying In Focus Mode
    func stoppedStudyingInFocusMode() {
        timeSpentInFocusMode += (Date() - (timeStartedStudying ?? Date()))
        let event: DatabaseEvent = DatabaseEvent(item: self, event: .stoppedStudyingInFocusMode, currentDate: Date())
        globalTaskDatabase.currentDatabaseLog.log.append(event)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.dueDate)
        hasher.combine(self.title)
        hasher.combine(self.dateCreated)
    }
    
}

// ToDoItems have a strict ordering using the duedate. 
extension ToDoItem: Comparable {
	static func <(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
		return lhs.dueCounter < rhs.dueCounter
	}

	static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
		return lhs.dueCounter == rhs.dueCounter
	}
}
