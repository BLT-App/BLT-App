//
//  CourseListViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 5/11/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit
import Eureka

class CourseListViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Courses"
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Manage all your courses",
                               footer: "Insert and delete all the courses you have referenced in to-do items. ") {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New Tag"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Tag Name"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Tag Name"
                                }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Code from Eureka Example
class MultivaluedOnlyReorderController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let secondsPerDay = 24 * 60 * 60
        let list = ["Today", "Yesterday", "Before Yesterday"]
        
        form +++
            
            MultivaluedSection(multivaluedOptions: .Reorder,
                               header: "Reordering Selectors") {
                                $0 <<< PushRow<String> {
                                    $0.title = "Tap to select ;).."
                                    $0.options = ["Option 1", "Option 2", "Option 3"]
                                    }
                                    <<< PushRow<String> {
                                        $0.title = "Tap to select ;).."
                                        $0.options = ["Option 1", "Option 2", "Option 3"]
                                    }
                                    <<< PushRow<String> {
                                        $0.title = "Tap to select ;).."
                                        $0.options = ["Option 1", "Option 2", "Option 3"]
                                    }
                                    <<< PushRow<String> {
                                        $0.title = "Tap to select ;).."
                                        $0.options = ["Option 1", "Option 2", "Option 3"]
                                }
                                
            }
            
            +++
            // Multivalued Section with inline rows - section set up to support only reordering
            MultivaluedSection(multivaluedOptions: .Reorder,
                               header: "Reordering Inline Rows") { section in
                                list.enumerated().forEach({ offset, string in
                                    let dateInlineRow = DateInlineRow(){
                                        $0.value = Date(timeInterval: Double(-secondsPerDay) * Double(offset), since: Date())
                                        $0.title = string
                                    }
                                    section <<< dateInlineRow
                                })
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: .Reorder,
                               header: "Reordering Field Rows")
            <<< NameRow {
                $0.value = "Martin"
            }
            <<< NameRow {
                $0.value = "Mathias"
            }
            <<< NameRow {
                $0.value = "Agustin"
            }
            <<< NameRow {
                $0.value = "Enrique"
        }
        
    }
}

class MultivaluedOnlyInsertController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multivalued Only Insert"
        form    +++
            
            MultivaluedSection(multivaluedOptions: .Insert) { sec in
                sec.addButtonProvider = { _ in return ButtonRow {
                    $0.title = "Add Tag"
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textAlignment = .left
                    }
                }
                sec.multivaluedRowToInsertAt = { index in
                    return TextRow {
                        $0.placeholder = "Tag Name"
                    }
                }
                sec.showInsertIconInAddButton = false
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: .Insert, header: "Insert With Inline Cells") {
                $0.multivaluedRowToInsertAt = { index in
                    return DateInlineRow {
                        $0.title = "Date"
                        $0.value = Date()
                    }
                }
        }
    }
}

class MultivaluedOnlyDeleteController: FormViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = false
        let nameList = ["family", "male", "female", "client"]
        
        let section = MultivaluedSection(multivaluedOptions: .Delete)
        
        for tag in nameList {
            section <<< TextRow {
                $0.placeholder = "Tag Name"
                $0.value = tag
            }
        }
        
        let section2 =  MultivaluedSection(multivaluedOptions: .Delete, footer: "")
        for _ in 1..<4 {
            section2 <<< PickerInlineRow<String> {
                $0.title = "Tap to select"
                $0.value = "client"
                $0.options = nameList
            }
        }
        
        editButton.title = tableView.isEditing ? "Done" : "Edit"
        editButton.target = self
        editButton.action = #selector(editPressed(sender:))
        
        form    +++
            
            section
            
            +++
            
        section2
    }
    
    @objc func editPressed(sender: UIBarButtonItem){
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.title = tableView.isEditing ? "Done" : "Edit"
        
    }
}
