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
    /// Type Of Event
    @objc dynamic var eventType: GeneralEventType
    /// String Description Of The Event Text
    @objc dynamic var eventText: String = ""
    /// Date of Event
    @objc dynamic var date: Date = dateManager.date
    /// `ToDoItem` that triggered the event
    @objc dynamic var item: ToDoItem?
    /// Identifier For Each Event
    @objc dynamic var eventID: String = UUID().uuidString
    /// Duration Of Event Pair (For StoppedStudyingInFocusMode)
    let duration: RealmOptional<TimeInterval> = RealmOptional<TimeInterval>()
    
    required init() {
        self.eventType = .openedApp
        self.eventText = "Initialized As Blank DatabaseEvent"
        super.init()
    }
    
    /**
     Initializes a DatabaseEvent with parameters
     - Parameters:
        - event: The type of event that was triggered
        - item: The ToDoItem triggering the event
    */
    convenience init(event: GeneralEventType, item: ToDoItem) {
        self.init()
        self.eventType = event
        self.item = item
        setEventText()
    }
    
    /// Initializes a DatabaseEvent with parameters
    ///
    /// - Parameter event: Type of event
    convenience init(event: GeneralEventType) {
        self.init()
        self.eventType = event
        setEventText()
    }
    
    /// Initializes a DatabaseEvent with parameters
    /// - Attention: Only Use This Initializer For StoppedStudyingInFocusMode
    ///
    /// - Parameters:
    ///   - event: Type of event
    ///   - item: ToDoItem triggering the event
    ///   - duration:
    convenience init(event: GeneralEventType, item: ToDoItem, duration: TimeInterval) {
        if event != GeneralEventType.stoppedStudyingInFocusMode && event != GeneralEventType.markedCompletedInFocusMode {
            print("WARNING: INCORRECT INITIALIZER USED FOR DATABASEEVENT")
            exit(0)
        }
        self.init()
        self.eventType = event
        self.item = item
        self.duration.value = duration
        setEventText()
    }
    
    /// Sets the text representation of the event type
    func setEventText() {
        
        switch self.eventType {
        ///Occurs when an item is created
        case .createdItem:
            eventText = "Task \(item?.title ?? "") was created"
        ///Occurs when a user changes the due date of an item
        case .itemDueDateChanged:
            eventText = "Task \(item?.title ?? "") had its due date changed"
        ///Occurs when a user marks an item as complete from the Focus Mode page
        case .markedCompletedInFocusMode:
            eventText = "Task \(item?.title ?? "") was completed in Focus Mode after \(Int(duration.value ?? 0 / 60)) mins"
        ///Occurs when a user marks an item as complete from the List View page
        case .markedCompletedInListView:
            eventText = "Task \(item?.title ?? "") was completed from List View"
        ///Occurs when a user unmarks an item as complete
        case .unmarkedComplete:
            eventText = "Task \(item?.title ?? "") was marked as uncompleted"
        ///Occurs when an item has started to be studied in focus mode
        case .startedStudyingInFocusMode:
            eventText = "Task \(item?.title ?? "") started to be studied in Focus Mode"
        ///Occurs when an item has stopped being studied in focus mode
        case .stoppedStudyingInFocusMode:
            eventText = "Task \(item?.title ?? "") stopped being studied after \(Int(duration.value ?? 0 / 60)) mins"
        ///Occurs when a Focus Mode session begins
        case .focusSessionOpened:
            eventText = "Occurs when a Focus Mode session begins"
        ///Occurs when a Focus Mode session ends
        case .focusSessionClosed:
            eventText = "Occurs when a Focus Mode session begins"
        ///Occurs when the app is opened
        case .openedApp:
            eventText = "App was opened"
        ///Occurs when the app is closed
        case .closedApp:
            eventText = "App was closed"
        default:
            eventText = ""
        }
    }
    
    override static func primaryKey() -> String? {
        return "eventID"
    }
}
