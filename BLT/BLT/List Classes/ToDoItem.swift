//
//  ToDoItem.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

/**
 A to-do item is an item represneting a to-do in the list.
 */
class ToDoItem: Codable {

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

	///Hash Value
	let hashValue: String

	/// Time Spent In Focus Mode
	var timeSpentInFocusMode: DateInterval = DateInterval(start: Date(), end: Date())

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
	private var completed: Bool

	/// Completes the current task.
	func completeTask() {
		if !completed {
			completed = true
			dateCompleted = Date()
		}
	}

	/// Uncompletes a task.
	func undoCompleteTask() {
		completed = false
		dateCompleted = nil
	}

	/// Checks whether a task is completed.
	///  - Returns: The state of completion of the item.
	func isCompleted() -> Bool {
		return completed
	}

	/// Initializer from Decodable
	/// - Parameters:
	///   - from: Decodable file to initialize from.
	///   - className: Name of the class.
	///   - title: Title of the item.
	///   - description: Description of the item.
	///   - dueDate: Date object of the due date.
	///   - completed: Whether or not an item is completed.
	///   - hashValue: The hashvalue of a specific item.
	init(from: Decodable, className: String, title: String, description: String,
		 dueDate: Date, completed: Bool, hashValue: String) {
		self.className = className
		self.title = title
		self.description = description
		self.dueDate = dueDate
		self.completed = completed
		self.hashValue = hashValue
		print("Item with hash value \(self.hashValue) was created from memory")
	}

	/// Initializer method
	/// - Parameters:
	///   - className: Name of the class.
	///   - title: Title of the item.
	///   - description: Description of the item.
	///   - dueDate: Date object of the due date.
	///   - completed: Whether or not an item is completed.
	init(className: String, title: String, description: String,
		 dueDate: Date, completed: Bool) {
		self.className = className
		self.title = title
		self.description = description
		self.dueDate = dueDate
		self.completed = completed
		self.hashValue = dateCreated.description + "_" + title.uppercased()
		let hashForbiddenCharacters: Set<Character> = [" ", "+", ":", "-"]
		self.hashValue.removeAll(where: { hashForbiddenCharacters.contains($0) })
		print("Item with hash value \(self.hashValue) was added")
		globalTaskDatabase.currentDatabaseLog.log.append(DatabaseEvent(item: self, event: .created))
	}

	/// Marks an item as completed
	/// - Returns: true
	func markCompleted() -> Bool {
		self.completed = true
		return true
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
