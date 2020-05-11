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
    
    //var activityHistory: [DatabaseEvent] = []
    
    var tableData: [[DatabaseEvent]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createTableData()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func createTableData() {
        if tableData.count != 0 {
            return
        }
        
        let realm = realmManager.realm
        let results = realm.objects(DatabaseEvent.self).sorted(byKeyPath: "date")
        var eventIdx = 0
        while eventIdx < results.count {
            var currentSection: [DatabaseEvent] = []
            var currentEvent = results[eventIdx]
            let lastDateView = currentEvent.date.currentCalendar.beginningOfDay
            while currentEvent.date.currentCalendar.beginningOfDay == lastDateView && eventIdx < results.count {
                currentSection.append(currentEvent)
                eventIdx += 1
                currentEvent = results[eventIdx]
            }
            tableData.append(currentSection)
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String]? = []
        for section in tableData {
            let date = section[0].date.currentCalendar.beginningOfDay.components
            titles?.append("\(date.month) \(date.day), \(date.year)")
        }
        return titles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ActivityTableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        if let tempcell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? ActivityTableViewCell {
            cell = tempcell
        }
        
        cell.timeStamp.text = "\(tableData[indexPath.section][indexPath.row].date)"
        cell.eventDescription.text = tableData[indexPath.section][indexPath.row].eventText
        
        return cell
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
