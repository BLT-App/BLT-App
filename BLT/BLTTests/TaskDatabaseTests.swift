//
//  TaskDatabaseTests.swift
//  BLTTests
//
//  Created by LorentzenN on 2/18/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import XCTest
@testable import BLT
import Datez

let exampleToDoItem: ToDoItem = ToDoItem(className: "Math", title: "Complete Calculus Homework", description: "Discover Calculus pg. 103 - 120", dueDate: Date(), completed: false, deleted: false)

class TaskDatabaseTests: XCTestCase {

    var testingDatabase: TaskDatabase = TaskDatabase()
    var preservedLog: [DatabaseEvent] = []
    
    let exampleEvents: [DatabaseEvent] = [
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 2.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 2.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 4.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 5.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: 2.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 3.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: 2.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 4.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: 2.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: 4.days.timeInterval)),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: 3.days.timeInterval)),
    ]

    
    override func setUp() {
        testingDatabase = TaskDatabase()
        preservedLog = testingDatabase.currentDatabaseLog.log
        testingDatabase.currentDatabaseLog.log.removeAll()
        testingDatabase.currentDatabaseLog.log.append(contentsOf: exampleEvents)
        testingDatabase.saveDatabaseLog(targetLog: testingDatabase.currentDatabaseLog)
        
        let pastDate: Date = Date(timeIntervalSinceNow: 3.days.timeInterval)
        print(testingDatabase.getDatabaseLogString(date: pastDate))
        print(testingDatabase.getDatabaseLogString(date: Date()) <= testingDatabase.getDatabaseLogString(date: pastDate))
        print(testingDatabase.getDatabaseLogString(date: Date()) >= testingDatabase.getDatabaseLogString(date: pastDate))
        
        print(testingDatabase.getNumEventsOfTypeInLast(numDays: 7, eventType: .created))
        
    }

    override func tearDown() {
        testingDatabase.currentDatabaseLog.log.removeAll()
        testingDatabase.currentDatabaseLog.log.append(contentsOf: preservedLog)
    }

    func testGetNumEventsOfTypeInLast() {
        var numThingsCreated = 0
        self.measure {
            numThingsCreated = testingDatabase.getNumEventsOfTypeInLast(numDays: 7, eventType: .created)
        }
        XCTAssert(numThingsCreated == 7, "Expected 7 things created and got \(numThingsCreated)")
    }

}
