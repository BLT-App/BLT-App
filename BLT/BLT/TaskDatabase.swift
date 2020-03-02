//
//  TaskDatabase.swift
//  BLT
//
//  Created by LorentzenN on 1/29/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import Datez

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
            for event in currentDatabaseLog.log {
                print("Event: \(event.toDoItemIdentifier), \(event.eventType), \(event.date)")
            }
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
        
        /// The Sequential Event Number For Assigning To New DatabaseEvents
        private var eventNumber: Int
        
        /// List Of Databases Created
        var listOfDatabases: [String]
        
        
        /// Gets The Current Event Number For Use In A New `DatabaseEvent`
        ///
        /// - Returns: The Current Event Number
        mutating func getEventNumForUse() -> Int {
            self.eventNumber += 1
            return self.eventNumber
        }
        
        
        /// Initializes A New DatabaseIndex
        init() {
            self.eventNumber = 0
            self.listOfDatabases = []
        }
    }
    
    ///Enum for possible errors that arise from a database
    enum DatabaseError: Error {
        /// Error Occurs When Trying To Load A Database By Exact Name That Is Not In Memory
        case databaseDoesntExistError
    }
    
    /// Intializes A New TaskDatabase
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
     Saves The 'DatabaseIndex' Of The User
     */
    func saveDatabaseIndex() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("databaseIndex").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(self.myDatabaseIndex)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
        print("Database Index Stored")
    }
    
    
    /// Get The URL of The DatabaseLog
    ///
    /// - Parameters:
    ///   - year: Year of Log
    ///   - month: Month of Log
    /// - Returns: Full URL of DatabaseLog
    func getDatabaseLogURL(year: Int, month: Int) -> URL {
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
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(yearString)\(monthString)").appendingPathExtension("json")
        return archiveURL
    }
    
    /// Get The URL of The DatabaseLog
    ///
    /// - Parameters:
    ///   - targetDate: Date of log
    /// - Returns: Full URL of DatabaseLog
    func getDatabaseLogURL(targetDate: Date) -> URL {
        var dateString: String = String(targetDate.description.prefix(7))
        dateString = String(dateString.prefix(4)) + String(dateString.suffix(2))
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(dateString)").appendingPathExtension("json")
        return archiveURL
    }
    
    /// Loads a `DatabaseLog` from memory
    ///
    /// - Parameter atURL: Location of URL
    /// - Returns: The requested DatabaseLog
    /// - Throws: If `DatabaseLog` doesn't exist throws an error
    func loadDatabaseLog(atURL: URL) throws -> DatabaseLog {
        do {
            let jsonData = try Data(contentsOf: atURL)
            let decoder = JSONDecoder()
            let decodedDatabaseLog: DatabaseLog = try decoder.decode(DatabaseLog.self, from: jsonData)
            return decodedDatabaseLog
        } catch {
            throw DatabaseError.databaseDoesntExistError
        }
    }

    /// Fetches the `DatabaseLog` for the month year combo
    ///
    /// - Parameters:
    ///   - year: year of log
    ///   - month: month of log
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
    func fetchDatabaseLog(year: Int, month: Int) -> DatabaseLog {
        let archiveURL = getDatabaseLogURL(year: year, month: month)
        
        do{
            let decodedDatabaseLog = try loadDatabaseLog(atURL: archiveURL)
            print("Loaded Database Log for Year: \(year) Month: \(month) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } catch {
            print("No Log found for Year: \(year) Month: \(month)")
            print("Creating New Logfile")
            let tempDatabaseLog = DatabaseLog(year: year, month: month)
            saveDatabaseLog(targetLog: tempDatabaseLog)
            myDatabaseIndex.listOfDatabases.append(tempDatabaseLog.logString)
            return tempDatabaseLog
        }
    }
    
    
    /// Fetches the `DatabaseLog` that encompasses the date given
    ///
    /// - Parameter targetDate: date for which the target `DatabaseLog` should encompass
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
    func fetchDatabaseLog(targetDate: Date) -> DatabaseLog {
        let archiveURL = getDatabaseLogURL(targetDate: targetDate)
        
        do{
            let decodedDatabaseLog = try loadDatabaseLog(atURL: archiveURL)
            print("Loaded Database Log for Date: \(targetDate) from memory")
            print("Log has \(decodedDatabaseLog.log.count) entries")
            return decodedDatabaseLog
        } catch {
            print("No Log found for Date: \(targetDate)")
            print("Creating New Logfile")
            let tempDatabaseLog = DatabaseLog(date: targetDate)
            saveDatabaseLog(targetLog: tempDatabaseLog)
            myDatabaseIndex.listOfDatabases.append(tempDatabaseLog.logString)
            return tempDatabaseLog
        }
    }
    
    
    /// Fetches the `DatabaseLog` with the target identifier
    ///
    /// - Parameter targetLogString: identifier of the `DatabaseLog` to load
    /// - Returns: `DatabaseLog` for the given inputs from memory, or creates a new `DatabaseLog`
    /// - Throws: `DatabaseError.databaseDoesntExistError` if the desired `DatabaseLog` doesn't exist
    func fetchDatabaseLog(targetLogString: String) throws -> DatabaseLog {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLogString)").appendingPathExtension("json")
        do {
            let jsonData = try Data(contentsOf: archiveURL)
            let decoder = JSONDecoder()
            let decodedDatabaseLog: DatabaseLog = try decoder.decode(DatabaseLog.self, from: jsonData)
            return decodedDatabaseLog
        } catch {
            throw DatabaseError.databaseDoesntExistError
        }
    }
    
    
    ///Saves the specified log to local storage
    ///
    /// - Parameter targetLog: The log to be saved
    func saveDatabaseLog(targetLog: DatabaseLog) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("log\(targetLog.logString)").appendingPathExtension("json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(targetLog)
            try jsonData.write(to: archiveURL, options: .noFileProtection)
            print("Saved Log: log\(targetLog.logString) with \(targetLog.log.count) elts. ")
        } catch {
            print("ERROR: Couldn't Save Log \(targetLog.logString)")
        }
    }
    

    /// Gets The DatabaseLog String For A Date
    ///
    /// - Parameter date: The date for which the DatabaseLog will represent
    /// - Returns: The String to retrieve the log at
    func getDatabaseLogString(date: Date) -> String {
        var dateString: String = String(date.description.prefix(7))
        dateString = String(dateString.prefix(4)) + String(dateString.suffix(2))
        return dateString
    }
    
    
    /// Gets The DatabaseLog String of database for a given year month pair
    ///
    /// - Parameters:
    ///   - year: year of database
    ///   - month: month of database
    /// - Returns: URL of Database
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
    
    /// Searches databases efficiently for items matching the queries from the current date back
    ///
    /// - Parameters:
    /// - numDays: Number of days back to search
    /// - eventType: The type of event searching for
    ///
    /// - Returns: The number of events matching the query from the present day back to the number of days specified
    func getNumEventsOfTypeInLast(numDays: Int, eventType: GeneralEventType) -> Int {
        let startDate = Date(timeIntervalSinceNow: numDays.days.timeInterval)
        let endDate = Date()
        return getNumEventsOfTypeFrom(startDate: startDate, endDate: endDate, eventType: eventType)
    }
    
    
    /// Searches databases efficiently for items matching the queries
    ///
    /// - Parameters:
    ///    - startDate: Start of the search boundary for date
    ///    - endDate: End of the search boundary for date
    ///    - eventType: The type of event searching for
    ///
    /// - Returns: The number of events matching the query within the date constraint
    func getNumEventsOfTypeFrom(startDate: Date, endDate: Date, eventType: GeneralEventType) -> Int {
        saveDatabaseLog(targetLog: currentDatabaseLog)
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

