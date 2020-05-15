//
//  ActivityTableViewController.swift
//  BLT
//
//  Created by LorentzenN on 5/11/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import UIKit
import RealmSwift
import Datez

class ActivityTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let tableData = createTableData()
        return tableData.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableData = createTableData()
        return tableData[tableData.keys.sorted()[section]]?.count ?? 0
    }
    
    func createTableData() -> [Date: Results<DatabaseEvent>] {
        var tableData: [Date: Results<DatabaseEvent>] = [:]
        let startDate = dateManager.date.addingTimeInterval(1.days.timeInterval)
        
        for day in 0...30 {
            let results = realmManager.realm.objects(DatabaseEvent.self).filter("date >= %@ " +
                "AND date =< %@", startDate - (1 + day).days.timeInterval, startDate - day.days.timeInterval)
            if results.count != 0 {
                tableData[startDate - day.days.timeInterval] = results
            }
        }
        return tableData
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableData = createTableData()
        var titles: [String]? = []
        for section in tableData.keys.sorted() {
            let date = section.currentCalendar.beginningOfDay.components
            titles?.append("\(date.month)/\(date.day)/\(date.year)")
        }
        return titles?[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableData = createTableData()
        var cell = ActivityTableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if let tempcell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? ActivityTableViewCell {
            cell = tempcell
        }
        let key = tableData.keys.sorted()[indexPath.section]
        if let event = tableData[key]?[indexPath.row] {
            cell.eventID = event.eventID
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
