//
//  TaskDatabaseTests.swift
//  BLTTests
//
//  Created by LorentzenN on 2/18/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import XCTest
@testable import BLT

let exampleToDoItem: ToDoItem = ToDoItem(className: "Math", title: "Complete Calculus Homework", description: "Discover Calculus pg. 103 - 120", dueDate: Date(), completed: false)

class TaskDatabaseTests: XCTestCase {

    var testingDatabase: TaskDatabase = TaskDatabase()
    var preservedLog: [DatabaseEvent] = []
    
    let exampleEvents: [DatabaseEvent] = [
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 2))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 2))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 4))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 1))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 5))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 2))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 3))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 2))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 4))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 3))),
        DatabaseEvent(item: exampleToDoItem, event: .created, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 4))),
        DatabaseEvent(item: exampleToDoItem, event: .markedCompletedInFocusMode, currentDate: Date(timeIntervalSinceNow: TimeInterval(-86400 * 3))),
    ]

    
    override func setUp() {
        testingDatabase = TaskDatabase()
        preservedLog = testingDatabase.currentDatabaseLog.log
        testingDatabase.currentDatabaseLog.log.removeAll()
        testingDatabase.currentDatabaseLog.log.append(contentsOf: exampleEvents)
        testingDatabase.saveDatabaseLog(targetLog: testingDatabase.currentDatabaseLog)
        
        let pastDate: Date = Date(timeIntervalSinceNow: TimeInterval(-86400 * 3))
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
