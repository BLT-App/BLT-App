//
//  MilestoneItem.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

/**
 A MilestoneItem is a ToDoItem that contains milestones. This is meant for larger ToDoItems such as essays or reports.
 */
class MilestoneItem: ToDoItem {

	/// The milestones of the assignment in an array.
	var milestones: [Milestone]

	/// Initializer method from Decodable.
	init(from: Decodable, className: String, title: String, description: String,
		 dueDate: Date, completed: Bool, milestones: [Milestone]) {
		self.milestones = milestones
		super.init(className: className, title: title, description: description,
			dueDate: dueDate)
	}

	/// Initializer method.
	init(className: String, title: String, description: String,
		 dueDate: Date, completed: Bool, milestones: [Milestone]) {

		self.milestones = milestones
		super.init(className: className, title: title, description: description,
			dueDate: dueDate)

	}

	/// Throws error if initializer method has not been implemented.
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}
