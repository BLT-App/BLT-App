//
//  TaskDatabase.swift
//  BLT
//
//  Created by LorentzenN on 1/29/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation

///Global TaskDatabase Variable
var globalTaskDatabase: TaskDatabase = TaskDatabase()

class TaskDatabase {
    
    ///Current Working Database Log
    var currentDatabaseLog: DatabaseLog
    
    struct DatabaseLog: Codable {
        var year: Int
        var month: Int
        var log: [DatabaseEvent]
        var numOfEvents: Int
        
        init(date: Date) {
            let dateString = String(date.description.prefix(7))
            if let tempYear: Int = Int(String(dateString.prefix(4))) {
                self.year = tempYear
            } else {
                self.year = -1
            }
            if let tempMonth: Int = Int(String(dateString.suffix(2))) {
                self.month = tempMonth
            } else {
                self.month = -1
            }
            self.log = []
            self.numOfEvents = self.log.count
        }
        
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
            self.log = []
            self.numOfEvents = self.log.count
        }
    }
    
    init() {
        print("Initializing DatabaseLog")
        currentDatabaseLog = DatabaseLog(year: -1, month: -1)
        currentDatabaseLog = fetchDatabaseLog(targetDate: Date())
    }
    
    func fetchDatabaseLog(year: Int, month: Int) -> DatabaseLog {
        let yearString: String
        if year < 1000 {
            yearString = "0\(year)"
        } else if year < 100 {
            yearString = "00\(year)"
        } else if year < 10 {
            yearString = "000\(year)"
        } else {
            yearString = String(year)
        }
        
        let monthString: String
        if month < 10 {
            monthString = "0\(month)"
        } else {
            monthString = String(month)
        }
        
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(yearString)-\(monthString)").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseLog = try? propertyListDecoder.decode(DatabaseLog.self, from: retrievedNoteData) {
            print("Loaded Database Log for \(yearString)-\(monthString) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } else {
            print("No Log found for \(yearString)-\(monthString)")
            print("Creating New Logfile")
            return DatabaseLog(year: year, month: month)
        }
    }
    
    func fetchDatabaseLog(targetDate: Date) -> DatabaseLog {
        let dateString: String = String(targetDate.description.prefix(7))
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(dateString)").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseLog = try? propertyListDecoder.decode(DatabaseLog.self, from: retrievedNoteData) {
            print("Loaded Database Log for \(dateString) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } else {
            print("No Log found for \(dateString)")
            print("Creating New Logfile")
            return DatabaseLog(date: targetDate)
        }
    }
    
    func saveDatabaseLog(targetLog: DatabaseLog) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLog.year)-\(targetLog.month)").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(targetLog)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
    }
}
