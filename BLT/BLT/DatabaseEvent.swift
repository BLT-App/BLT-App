//
//  DatabaseEvent.swift
//  BLT
//
//  Created by LorentzenN on 1/30/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
enum GeneralEventType: Int, Codable {
    case DueDateChanged
    case MarkedCompletedInFocusMode
    case Created
    case MarkedCompletedInListView
    case UnmarkedComplete
}

class DatabaseEvent: Codable {

    
    let eventType: GeneralEventType
    let date: Date = Date()
    let toDoItemIdentifier: String
    
    init(item: ToDoItem, event: GeneralEventType) {
        self.toDoItemIdentifier = item.hashValue
        self.eventType = event
    }
    
}
