//
//  ToDoList.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

/**
 A class that represents entire lists of to-do. This is what is stored into storage by the system.
 */
class ToDoList {
    
    /// Defaults.
    let defaults = UserDefaults.standard
    
    /// The list of to-do items. 
    var list: [ToDoItem] = []
    
    /// The list of uncompleted to-do items.
    var uncompletedList: [ToDoItem] {
        var uncompleted: [ToDoItem] = []
        for item: ToDoItem in list {
            if !item.completed {
                uncompleted.append(item)
            }
        }
        return uncompleted
    }
    
    /// Saves user data to local file.
    func storeList() {
        defaults.set(self, forKey: "ToDoList")
    }
    
    /// Retrieves saved user data.
    func retrieveList() {
        let list = defaults.object(forKey: "ToDoList")
        if list == nil {
            storeList()
        } else {
            if let toDoList = list as? ToDoList {
                self.list = toDoList.list
            }
        }
    }
    
    /// Initializer
    init() {
        if defaults.object(forKey: "ToDoList") == nil {
            storeList()
        }
        retrieveList()
    }
    
    /// Sorts the ToDoList.
    func sortList() {
        list = list.sorted()
        storeList()
    }
    
    /// Adds example tasks to the to do list, for example funcionality.
    func createExampleList() {
        self.list.append(ToDoItem(className: "Math", title: "Complete Calculus Homework", description: "Discover Calculus pg. 103 - 120", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "English", title: "Read Dalloway", description: "Page 48 - 64", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "Computer Science", title: "Complete Lo-Fi Prototype", description: "Use Invision and upload to Canvas", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "Supreme Court", title: "Brief Rucho", description: "Read Rucho v United States and write brief", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "Photo", title: "Print photos", description: "Print and mount pieces from last week", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "Econ", title: "Read Unit 7", description: "Read Unit 7 and respond to prompt online", dueDate: Date(), completed: false))
        self.list.append(ToDoItem(className: "Philosophy", title: "Paine", description: "Read Paine's Common Sense from Philosophy reader", dueDate: Date(), completed: false))
        storeList()
    }
}
