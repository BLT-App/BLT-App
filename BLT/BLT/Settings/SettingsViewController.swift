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
        form +++ Section(header: "User Info", footer: "So we can tailor the BLT experience to you.")
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
            <<< ButtonRow("Courses") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "courseListSegue", onDismiss: nil)
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
                $0.value = [.monday, .tuesday, .wednesday, .thursday, .friday]
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
                }.onChange { swt in
                    dateManager.isInDebugMode = swt.value ?? false
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
                $0.value = dateManager.date
                }.onChange { dateTimeSlider in
                    dateManager.setDate(to: dateTimeSlider.value ?? Date())
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
                $0.value = dateManager.timeMultiplier
                }.onChange { multiplier in
                    dateManager.timeMultiplier = multiplier.value ?? 1.0
            }
            +++ Section(header: "End Matter", footer: "© 2020 🥪 BLT")
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Credits"
                }.onCellSelection { [weak self] (cell, row) in
                    self?.performSegue(withIdentifier: "creditsSegue", sender: self)
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Bug Report"
                }.onCellSelection { [weak self] (cell, row) in
                    if let url = URL(string: "https://bit.ly/BLT-Bug-Report") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:])
                        }
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
