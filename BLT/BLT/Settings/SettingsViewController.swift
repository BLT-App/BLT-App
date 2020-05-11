//
//  SettingsViewController.swift
//  BLT
//
//  Created by Jiahua Chen on 5/11/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section(header: "User Info", footer: "So we know who you are and how to address you.")
            <<< TextRow(){ row in
                row.title = "First Name"
                row.placeholder = "Enter here"
                row.value = globalData.firstName
                
                }.onChange { row in
                    globalData.firstName = row.value ?? ""
            }
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.placeholder = "Enter here"
                row.value = globalData.lastName
                
                }.onChange { row in
                    globalData.lastName = row.value ?? ""
            }
            +++ Section(header: "To-Do List", footer: "Change how you would like to view your to-do list.")
            <<< SwitchRow() {
                $0.title = "Sort List By Date"
                $0.value = globalData.wantsListByDate
                
                }.onChange { swt in
                    globalData.wantsListByDate = swt.value ?? false
            }
            +++ Section(header: "Focus Mode", footer: "Change your focus mode experience. ")
            <<< SwitchRow() {
                $0.title = "Enable End Focus Mode Button"
                $0.value = globalData.includeEndFocusButton
                
                }.onChange { swt in
                    globalData.includeEndFocusButton = swt.value ?? false
            }
            +++ Section(header: "Notifications", footer: "Notification settings. If this is your first time enabling notifications, you will receive a prompt to allow notifications." )
            <<< SwitchRow("Enable Notifications") {
                $0.title = "Send me notifications"
                $0.value = false
                // Implementation not set yet!!
            }
            +++ Section(header: "Notification Settings", footer: "Adjust your notification settings and frequency. ") {
                $0.hidden = .function(["Enable Notifications"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Enable Notifications")
                    return row.value ?? false == false
                })
            }
            <<< LabelRow() { label in
                label.title = "Notification Dates"
            }
            <<< WeekDayRow(){
                $0.value = [.monday, .wednesday, .friday]
            }
            <<< TimeRow() {
                $0.title = "Notification Time"
                $0.value = Date()
            }
            +++ Section(header: "Ultra Sekrit Settings", footer: "Proceed at your own risk.")
            <<< SwitchRow("Enable Developer Mode") {
                $0.title = $0.tag
                $0.value = false
                // Implementation not set yet!!
            }
            <<< SwitchRow("Change Date") {
                $0.hidden = .function(["Enable Developer Mode"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Enable Developer Mode")
                    return row.value ?? false == false
                })
                $0.title = $0.tag
                $0.value = false
                // Implementation not set yet!!
            }
            <<< DateTimeRow() {
                $0.hidden = .function(["Enable Developer Mode"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Enable Developer Mode")
                    return row.value ?? false == false
                })
                $0.disabled = Eureka.Condition.function(["Change Date"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Change Date")
                    return !(row.value ?? false)
                })
                $0.title = "Custom Time"
                $0.value = Date()
            }
            <<< SliderRow() {
                $0.hidden = .function(["Enable Developer Mode"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Enable Developer Mode")
                    return row.value ?? false == false
                })
                $0.disabled = Eureka.Condition.function(["Change Date"], { (form) -> Bool in
                    let row: SwitchRow! = form.rowBy(tag: "Change Date")
                    return !(row.value ?? false)
                })
                $0.title = "Time Speed"
                $0.value = 1.0
            }
            +++ Section(header: "End Matter", footer: "© 2020 BLT Group")
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Credits"
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Bug Report"
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
