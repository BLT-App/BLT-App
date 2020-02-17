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
    
    ///Database Index
    var myDatabaseIndex: DatabaseIndex
    ///Current Working Database Log
    var currentDatabaseLog: DatabaseLog
    
    struct DatabaseLog: Codable {
        var year: Int
        var month: Int
        var log: [DatabaseEvent]
        var numOfEvents: Int {
            return log.count
        }
        var logString: String {
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
            return "\(yearString)\(monthString)"
        }
        
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
        }
        
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
            self.log = []
        }
    }
    
    struct DatabaseIndex: Codable {
        private var eventNumber: Int
        var listOfDatabases: [String]
        
        mutating func getEventNumForUse() -> Int {
            self.eventNumber += 1
            return self.eventNumber
        }
        
        init() {
            self.eventNumber = 0
            self.listOfDatabases = []
        }
    }
    
    enum DatabaseError: Error {
        case databaseDoesntExistError
    }
    
    init() {
        print("Getting Database Index")
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("databaseIndex").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseIndex = try? propertyListDecoder.decode(DatabaseIndex.self, from: retrievedNoteData) {
            print("Loaded Database Index")
            self.myDatabaseIndex = decodedDatabaseIndex
        } else {
            print("No Database Index Found")
            print("Creating New Database Index")
            self.myDatabaseIndex = DatabaseIndex()
        }
        print("Initializing DatabaseLog")
        currentDatabaseLog = DatabaseLog(year: -1, month: -1)
        currentDatabaseLog = fetchDatabaseLog(targetDate: Date())
    }
    
    func loadDatabaseIndex() -> DatabaseIndex {
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("databaseIndex").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseIndex = try? propertyListDecoder.decode(DatabaseIndex.self, from: retrievedNoteData) {
            print("Loaded Database Index")
            return decodedDatabaseIndex
        } else {
            print("No Database Index Found")
            print("Creating New Logfile")
            return DatabaseIndex()
        }
    }
    
    func saveDatabaseIndex() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("databaseIndex").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(self.myDatabaseIndex)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
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
        let archiveURL = documentsDirectory.appendingPathComponent("log\(yearString)\(monthString)").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseLog = try? propertyListDecoder.decode(DatabaseLog.self, from: retrievedNoteData) {
            print("Loaded Database Log for \(yearString)\(monthString) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } else {
            print("No Log found for log\(yearString)\(monthString)")
            print("Creating New Logfile")
            let tempDatabaseLog = DatabaseLog(year: year, month: month)
            saveDatabaseLog(targetLog: tempDatabaseLog)
            myDatabaseIndex.listOfDatabases.append("\(yearString)\(monthString)")
            return tempDatabaseLog
        }
    }
    
    func fetchDatabaseLog(targetDate: Date) -> DatabaseLog {
        var dateString: String = String(targetDate.description.prefix(7))
        dateString = String(dateString.prefix(4)) + String(dateString.suffix(2))
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(dateString)").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseLog = try? propertyListDecoder.decode(DatabaseLog.self, from: retrievedNoteData) {
            print("Loaded Database Log for log\(dateString) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } else {
            print("No Log found for log\(dateString)")
            print("Creating New Logfile")
            let tempDatabaseLog = DatabaseLog(date: targetDate)
            saveDatabaseLog(targetLog: tempDatabaseLog)
            myDatabaseIndex.listOfDatabases.append(dateString)
            return tempDatabaseLog
        }
    }
    
    func fetchDatabaseLog(targetLogString: String) throws -> DatabaseLog {
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLogString)").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedDatabaseLog = try? propertyListDecoder.decode(DatabaseLog.self, from: retrievedNoteData) {
            print("Loaded Database Log for log\(targetLogString) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } else {
            print("No Database Found for \(targetLogString)")
            throw DatabaseError.databaseDoesntExistError
        }
    }
    
    func saveDatabaseLog(targetLog: DatabaseLog) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLog.logString)").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(targetLog)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
        print("Saved Log: log\(targetLog.logString)")
    }
    
    func getDatabaseLogString(date: Date) -> String {
        var dateString: String = String(date.description.prefix(7))
        dateString = String(dateString.prefix(4)) + String(dateString.suffix(2))
        return dateString
    }
    
    func getDatabaseLogString(year: Int, month: Int) -> String {
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
        
        return yearString + monthString
    }
    
    func getNumEventsOfTypeInLast(numDays: Int, eventType: GeneralEventType) -> Int {
        let startDate = Date().addingTimeInterval(TimeInterval(-7600 * numDays))
        let endDate = Date()
        return getNumEventsOfTypeFrom(startDate: startDate, endDate: endDate, eventType: eventType)
    }
    
    func getNumEventsOfTypeFrom(startDate: Date, endDate: Date, eventType: GeneralEventType) -> Int {
        var numEvents = 0
        for databaseString in myDatabaseIndex.listOfDatabases where databaseString > getDatabaseLogString(date: startDate) && databaseString < getDatabaseLogString(date: endDate) {
            if let database = try? fetchDatabaseLog(targetLogString: databaseString) {
                for event in database.log where event.eventType == eventType && event.date > startDate && event.date < endDate {
                    numEvents += 1
                }
            } else {
                print("WARNING: Faulty Database Index Contains Non-Existent Log")
            }
        }
        
        return numEvents
    }
}

