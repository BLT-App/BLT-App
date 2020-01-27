//
//  Milestone.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation

/**
 A milestone that an assignment could have. This represents an intermediate deliverable for each MilestoneItem.
 */
struct Milestone: Codable {
    
    /// The title/name of the milestone.
    var title: String
    
    /// The due date object of the milestone.
    var dueDate: Date
    
    /// Whether the milestone is completed.
    var completed: Bool
    
}
