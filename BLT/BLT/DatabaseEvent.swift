//
//  DatabaseEvent.swift
//  BLT
//
//  Created by LorentzenN on 1/30/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation

enum GeneralEventType: Int, Codable {
	case dueDateChanged
	case markedCompletedInFocusMode
	case created
	case markedCompletedInListView
	case unmarkedComplete
}

class DatabaseEvent: Codable {
	let eventType: GeneralEventType
	let date: Date = Date()
	let toDoItemIdentifier: String
	let eventNumber: Int

	init(item: ToDoItem, event: GeneralEventType) {
		self.toDoItemIdentifier = item.hashValue
		self.eventType = event
		self.eventNumber = globalTaskDatabase.myDatabaseIndex.getEventNumForUse()
	}

}
