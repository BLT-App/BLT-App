//
//  DatabaseEvent.swift
//  BLT
//
//  Created by LorentzenN on 1/30/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation

///Enum of different events that can occur on a [ToDoItem](x-source-tag://ToDoItem)
enum GeneralEventType: Int, Codable {
    ///Occurs when a user changes the due date of an item
    case dueDateChanged
    ///Occurs when a user marks an item as complete from the Focus Mode page
    case markedCompletedInFocusMode
    ///Occurs when an item is created
    case created
    ///Occurs when a user marks an item as complete from the List View page
    case markedCompletedInListView
    ///Occurs when a user unmarks an item as complete
    case unmarkedComplete
}

///Used For Logging Various Events For Later Use
class DatabaseEvent: Codable {
    ///Type Of Event
    let eventType: GeneralEventType
    ///Date of Event
    let date: Date
    ///Identifier of the ToDoItem that triggered the event
    let toDoItemIdentifier: String
    ///Sequential Identifier For Each Event
    let eventNumber: Int
    
    /**
     Initializes a DatabaseEvent with parameters
     - Parameters:
        - item: The ToDoItem triggering the event
        - event: The type of event that was triggered
        - currentDate: The date of the event
    */
    init(item: ToDoItem, event: GeneralEventType, currentDate: Date) {
        self.toDoItemIdentifier = item.hashVal
        self.eventType = event
        self.eventNumber = globalTaskDatabase.myDatabaseIndex.getEventNumForUse()
        self.date = currentDate
    }
}
