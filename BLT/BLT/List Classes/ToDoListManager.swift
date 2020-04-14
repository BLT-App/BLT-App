//
//  ToDoListManager.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import Datez

/// Global ToDoList Variable
var toDoListManager: ToDoListManager = ToDoListManager()

/// To Do List Object
struct ToDoList: Codable {
    /// The list of to-do items.
    var list: [ToDoItem] = []
    
    /// Current number of points.
    var points: Int = 0
    
    ///List Of Deleted Items
    var deletedList: [ToDoItem] = []
    
    ///List Of Completed Items
    var completedList: [ToDoItem] = []
}

/**
 A Class To Manage The To Do List
 */
class ToDoListManager {
    
    /// ToDoList to manage
    var list: ToDoList = ToDoList()
    
    /// Number Of Items In List
    var numItemsInList: Int {
        return list.list.count
    }

	/// Initializes a ToDoList object. If it has never been saved to disk before, it saves the object to file.
	init() {
        list = retrieveList()
	}
    
    /// Saves user data to local file.
    func storeList() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("todolist").appendingPathExtension("json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(list)
            try jsonData.write(to: archiveURL, options: .noFileProtection)
            print("To Do List Stored")
        } catch {
            print("Could Not Store To Do List")
        }
        UserDefaults.standard.set(true, forKey: "ListHasLoaded")
    }
    
    /// Retrieves saved user data.
    func retrieveList() -> ToDoList {
        print("** Retrieving To Do List")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("todolist").appendingPathExtension("json")
        do {
            let jsonData = try Data(contentsOf: archiveURL)
            let decoder = JSONDecoder()
            let tempList = try decoder.decode(ToDoList.self, from: jsonData)
            return tempList
        } catch {
            print("No To Do List Found: Creating One Now")
            return ToDoList()
        }
    }
    
    /// Sorts the ToDoList.
    func sortList() {
        list.list = list.list.sorted()
    }
    
    /// Adds A New `ToDoItem` To The List
    ///
    /// - Parameter item: `ToDoItem` To Add
    func addNewToDoItem(_ item: ToDoItem) {
        list.list.append(item)
        storeList()
    }
    
    
    /// Replaces The `ToDoItem` At An Index With The Parameter
    ///
    /// - Parameters:
    ///   - item: Target Item
    ///   - index: Location For Item
    func placeToDoItemAtIndex(item: ToDoItem, index: Int) {
        list.list[index] = item
    }

    
    /// Retrieves The `ToDoItem` At The Index
    ///
    /// - Parameter index: Index of ToDoItem
    func getToDoItemAt(index: Int) -> ToDoItem {
        return list.list[index]
    }
    
    /// Removes The Specified `ToDoItem`
    ///
    /// - Parameter index: Index Of Item To Remove
    func removeItemAt(index: Int) -> ToDoItem {
        return list.list.remove(at: index)
    }
    
	/// Adds example tasks to the to do list, for example funcionality.
	func createExampleList() {
        addNewToDoItem(ToDoItem(className: "Math",
                                  title: "Complete Calculus Homework",
                                  description: "Discover Calculus pg. 103 - 120",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "English",
                                  title: "Read Dalloway",
                                  description: "Page 48 - 64",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "Computer Science",
                                  title: "Complete Lo-Fi Prototype",
                                  description: "Use Invision and upload to Canvas",
                                  dueDate: Date(timeIntervalSinceNow: 2.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "Supreme Court",
                                  title: "Brief Rucho",
                                  description: "Read Rucho v United States and write brief",
                                  dueDate: Date(timeIntervalSinceNow: 3.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "Photo",
                                  title: "Print photos",
                                  description: "Print and mount pieces from last week",
                                  dueDate: Date(timeIntervalSinceNow: 2.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "Econ",
                                  title: "Read Unit 7",
                                  description: "Read Unit 7 and respond to prompt online",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
		addNewToDoItem(ToDoItem(className: "Philosophy",
                                  title: "Paine",
                                  description: "Read Paine's Common Sense from Philosophy reader",
                                  dueDate: Date(timeIntervalSinceNow: 1.days.timeInterval)))
	}
}
