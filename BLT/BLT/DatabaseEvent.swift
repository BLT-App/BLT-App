//
//  DatabaseEvent.swift
//  BLT
//
//  Created by LorentzenN on 1/30/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import RealmSwift

///Enum of different events that can occur on a [ToDoItem](x-source-tag://ToDoItem)
@objc enum GeneralEventType: Int, RealmEnum {
    ///Occurs when an item is created
    case createdItem
    ///Occurs when a user changes the due date of an item
    case itemDueDateChanged
    ///Occurs when a user marks an item as complete from the Focus Mode page
    case markedCompletedInFocusMode
    ///Occurs when a user marks an item as complete from the List View page
    case markedCompletedInListView
    ///Occurs when a user unmarks an item as complete
    case unmarkedComplete
    ///Occurs when an item has started to be studied in focus mode
    case startedStudyingInFocusMode
    ///Occurs when an item has stopped being studied in focus mode
    case stoppedStudyingInFocusMode
    ///Occurs when a Focus Mode session begins
    case focusSessionOpened
    ///Occurs when a Focus Mode session ends
    case focusSessionClosed
    ///Occurs when the app is opened
    case openedApp
    ///Occurs when the app is closed
    case closedApp
}

///Used For Logging Various Events For Later Use
class DatabaseEvent: Object {
    ///Type Of Event
    @objc dynamic var eventType: GeneralEventType {
        didSet {
            switch eventType {
            ///Occurs when an item is created
            case .createdItem:
                eventText = "Occurs when an item is created"
            ///Occurs when a user changes the due date of an item
            case .itemDueDateChanged:
                eventText = "Occurs when a user changes the due date of an item"
            ///Occurs when a user marks an item as complete from the Focus Mode page
            case .markedCompletedInFocusMode:
                eventText = "Occurs when a user marks an item as complete from the Focus Mode page"
            ///Occurs when a user marks an item as complete from the List View page
            case .markedCompletedInListView:
                eventText = "Occurs when a user marks an item as complete from the List View page"
            ///Occurs when a user unmarks an item as complete
            case .unmarkedComplete:
                eventText = "Occurs when a user unmarks an item as complete"
            ///Occurs when an item has started to be studied in focus mode
            case .startedStudyingInFocusMode:
                eventText = "Occurs when an item has started to be studied in focus mode"
            ///Occurs when an item has stopped being studied in focus mode
            case .stoppedStudyingInFocusMode:
                eventText = "Occurs when an item has stopped being studied in focus mode"
            ///Occurs when a Focus Mode session begins
            case .focusSessionOpened:
                eventText = "Occurs when a Focus Mode session begins"
            ///Occurs when a Focus Mode session ends
            case .focusSessionClosed:
                eventText = "Occurs when a Focus Mode session begins"
            ///Occurs when the app is opened
            case .openedApp:
                eventText = "Occurs when a Focus Mode session begins"
            ///Occurs when the app is closed
            case .closedApp:
                eventText = "Occurs when a Focus Mode session begins"
            default:
                eventText = ""
            }
            
        }
    }
    /// String Description Of The Event Text
    @objc private dynamic var eventText: String = ""
    ///Date of Event
    @objc dynamic var date: Date = dateManager.date
    ///`ToDoItem` that triggered the event
    @objc dynamic var item: ToDoItem?
    ///Sequential Identifier For Each Event
    @objc dynamic var eventID: String = UUID().uuidString
    
    required init() {
        self.eventType = .openedApp
    }
    
    /**
     Initializes a DatabaseEvent with parameters
     - Parameters:
        - item: The ToDoItem triggering the event
        - event: The type of event that was triggered
        - currentDate: The date of the event
        - item: The ToDoItem triggering the event
    */
    convenience init(event: GeneralEventType, item: ToDoItem) {
        self.init()
        self.eventType = event
        self.item = item
    }
    
    convenience init(event: GeneralEventType) {
        self.init()
        self.eventType = event
    }
    
    override static func primaryKey() -> String? {
        return "eventID"
    }
}
