//
//  TaskDatabase.swift
//  BLT
//
//  Created by LorentzenN on 1/29/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation

///Global `TaskDatabase` Variable
var globalTaskDatabase: TaskDatabase = TaskDatabase()


///Stores User Events For Use In Creating Our Profile Page Statistics
class TaskDatabase {
    
    ///Boolean to set testing mode
    let inTestingMode: Bool = true
    
    ///`DatabaseIndex` Of The User
    var myDatabaseIndex: DatabaseIndex{
        didSet {
            saveDatabaseIndex()
        }
    }
    
    ///Current Working `DatabaseLog`
    var currentDatabaseLog: DatabaseLog {
        didSet {
            saveDatabaseLog(targetLog: currentDatabaseLog)
        }
    }
    
    ///Holds Info About Various Events Caused By The User
    struct DatabaseLog: Codable {
        ///Year Created
        var year: Int
        ///Month Created
        var month: Int
        ///List Of Events
        var log: [DatabaseEvent]
        ///Number of Events in Log
        var numOfEvents: Int {
            return log.count
        }
        ///String Name of The Log
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
        
        /**
         Initializes a `DatabaseLog` for a Date
         
         - Parameter date: The date for which the log will hold data for
        */
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
        
        /**
         Initializes a DatabaseLog for a Month and a Year
         
         - Parameters:
            - year: Year for which the log will represent
            - month: Month for which the log will represent
         */
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
            self.log = []
        }
    }
    
    ///Index Of All Databases And Other Info For All Databases
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
    
    ///Enum for possible errors that arise from a database
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
    
    /**
     Loads The `DatabaseIndex` Object For The User
     
     - Returns: The `DatabaseIndex` from memory or creates a new `DatabaseIndex` using default constructor
     */
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
    
    /**
     Saves The 'DatabaseIndex' Of The User
     */
    func saveDatabaseIndex() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("databaseIndex").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(self.myDatabaseIndex)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
        print("** Stored Database")
    }
    

    /// Fetches the `DatabaseLog` for the month year combo
    ///
    /// - Parameters:
    ///   - year: year of log
    ///   - month: month of log
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
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
    
    
    /// Fetches the `DatabaseLog` that encompasses the date given
    ///
    /// - Parameter targetDate: date for which the target `DatabaseLog` should encompass
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
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
    
    
    /// Fetches the `DatabaseLog` with the target identifier
    ///
    /// - Parameter targetLogString: identifier of the `DatabaseLog` to load
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
    /// - Throws: `DatabaseError.databaseDoesntExistError` if the desired `DatabaseLog` doesn't exist
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
    
    /**
     Saves the specified log to local storage
     
     - Parameter targetLog: The log to be saved
    */
    func saveDatabaseLog(targetLog: DatabaseLog) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLog.logString)").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(targetLog)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
        print("Saved Log: log\(targetLog.logString) with \(targetLog.log.count) elts. ")
    }
    
    /**
     Gets the URL of database for a given date
     
     - Parameter date: The date for which the DatabaseLog will represent
 
     - Returns: 
    */
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
    
    /**
     Searches databases efficiently for items matching the queries from the current date back
     
     - Parameters:
     - numDays: Number of days back to search
     - eventType: The type of event searching for
     
     - Returns: The number of events matching the query from the present day back to the number of days specified
     */
    func getNumEventsOfTypeInLast(numDays: Int, eventType: GeneralEventType) -> Int {
        let startDate = Date().addingTimeInterval(TimeInterval(-86400 * numDays))
        let endDate = Date()
        return getNumEventsOfTypeFrom(startDate: startDate, endDate: endDate, eventType: eventType)
    }
    
    /**
     Searches databases efficiently for items matching the queries
     
     - Parameters:
        - startDate: Start of the search boundary for date
        - endDate: End of the search boundary for date
        - eventType: The type of event searching for
     
     - Returns: The number of events matching the query within the date constraint
     */
    func getNumEventsOfTypeFrom(startDate: Date, endDate: Date, eventType: GeneralEventType) -> Int {
        print("Searching logs from \(startDate.description.prefix(10)) to \(endDate.description.prefix(10)) for \(eventType) from list of \(myDatabaseIndex.listOfDatabases.count) logs")
        var numEvents = 0
        for databaseString in myDatabaseIndex.listOfDatabases {
            print("\(databaseString) is within date range. : \(databaseString >= getDatabaseLogString(date: startDate) && databaseString <= getDatabaseLogString(date: endDate))")
            if databaseString >= getDatabaseLogString(date: startDate) && databaseString <= getDatabaseLogString(date: endDate) {
                print("Checking log\(databaseString) for \(eventType)")
                if let database = try? fetchDatabaseLog(targetLogString: databaseString) {
                    for event in database.log {
                        print("Event with \(event.eventNumber) is correct. : \(event.eventType == eventType && event.date >= startDate && event.date <= endDate)")
                        if event.eventType == eventType && event.date >= startDate && event.date <= endDate {
                            numEvents += 1
                        }
                    }
                } else {
                    print("WARNING: Faulty Database Index Contains Non-Existent Log")
                }
            }
        }
        
        return numEvents
    }
}

