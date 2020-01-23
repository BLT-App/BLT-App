//
//  ToDoItem.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

/**
 A to-do item is an item represneting a to-do in the list.
 */
class ToDoItem: Codable {
    /// The name of the class that the to-do is associated with.
    var className: String
    
    /// The title of the to-do.
    var title: String
    
    /// A description of the to-do and any resources/materials that are needed.
    var description: String
    
    /// A due date fot the to-do.
    var dueDate: Date
    
    /// Returns the days between now and the due date.
    var dueCounter: Int {
        let calendar = NSCalendar.current
        let dueDay = calendar.startOfDay(for: dueDate)
        let nowDay = calendar.startOfDay(for: Date())
        let inBetween = calendar.dateComponents([.day], from: nowDay, to: dueDay).day
        return inBetween!
    }
    
    /// Returns the due date as a relative time measure implemented in a string.
    var dueString: String {
        if (dueCounter == 0) {
            return "Due today"
        } else if (dueCounter < 0) {
            return "Due \(abs(dueCounter)) days ago"
        } else {
            return "Due in \(dueCounter) days"
        }
    }

    /// Whether the to-do item is completed.
    var completed: Bool
    
    /// Initializer from Decodable
    init(from: Decodable, className: String, title: String, description: String,
         dueDate: Date, completed: Bool) {
        self.className = className
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.completed = completed
    }
    
    /// Initializer method
    init(className: String, title: String, description: String,
         dueDate: Date, completed: Bool) {
        self.className = className
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.completed = completed
    }
    
    /// Marks an item as completed
    func markCompleted() -> Bool {
        self.completed = true
        return true
    }
}

// ToDoItems have a strict ordering using the duedate. 
extension ToDoItem: Comparable {
    static func < (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.dueCounter < rhs.dueCounter
    }
    
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        return lhs.dueCounter == rhs.dueCounter
    }
}
