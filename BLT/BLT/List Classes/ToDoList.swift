//
//  ToDoList.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import Datez
import RealmSwift

/// Global ToDoList Variable
var myToDoList: ToDoList = ToDoList()

/**
 A class that represents entire lists of to-do. This is what is stored into storage by the system.
 */
class ToDoList {

	/// The list of to-do items.
    var uncompletedList: Results<ToDoItem> {
        let realm = realmManager.realm
        let results = realm.objects(ToDoItem.self).filter("deleted == false AND completed == false").sorted(byKeyPath: "dueDate")
        return results
    }
    
    ///List Of Deleted Items
    var deletedList: Results<ToDoItem> {
        let realm = realmManager.realm
        let results = realm.objects(ToDoItem.self).filter("deleted == true").sorted(byKeyPath: "dateCreated")
        return results
    }
    
    ///List Of Completed Items
    var completedList: Results<ToDoItem> {
        let realm = realmManager.realm
        let results = realm.objects(ToDoItem.self).filter("completed == true").sorted(byKeyPath: "dateCompleted")
        return results
    }
    
    var allToDoItems: Results<ToDoItem> {
        let realm = realmManager.realm
        let results = realm.objects(ToDoItem.self).filter("completed == true").sorted(byKeyPath: "dateCreated")
        return results
    }
    
    /// Current number of points.
    var points: Int = 0

	/// Initializes a ToDoList object. If it has never been saved to disk before, it saves the object to file.
	init() {
        if allToDoItems.count <= 0 {
            createExampleList()
        }
	}

	/// Adds example tasks to the to do list, for example funcionality.
	func createExampleList() {
        var exampleItems: [ToDoItem] = []
        exampleItems.append(ToDoItem(className: "Math",
                                  title: "Complete Calculus Homework",
                                  description: "Discover Calculus pg. 103 - 120",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "English",
                                  title: "Read Dalloway",
                                  description: "Page 48 - 64",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "Computer Science",
                                  title: "Complete Lo-Fi Prototype",
                                  description: "Use Invision and upload to Canvas",
                                  dueDate: Date(timeIntervalSinceNow: 2.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "Supreme Court",
                                  title: "Brief Rucho",
                                  description: "Read Rucho v United States and write brief",
                                  dueDate: Date(timeIntervalSinceNow: 3.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "Photo",
                                  title: "Print photos",
                                  description: "Print and mount pieces from last week",
                                  dueDate: Date(timeIntervalSinceNow: 2.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "Econ",
                                  title: "Read Unit 7",
                                  description: "Read Unit 7 and respond to prompt online",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		exampleItems.append(ToDoItem(className: "Philosophy",
                                  title: "Paine",
                                  description: "Read Paine's Common Sense from Philosophy reader",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
        let realm = realmManager.realm
        
        if realm.isInWriteTransaction {
            realm.add(exampleItems)
        } else {
            try! realm.write {
                realm.add(exampleItems)
            }
        }
	}
}
