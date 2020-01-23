//
//  UserData.swift
//  BLT
//
//  Created by Jiahua Chen on 11/10/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import Foundation
import UIKit
import RandomColorSwift

/**
 A class that stores user data. 
 */
class UserData: Codable {
    
    var hueCounter = 0
    var subjects: [String: Color]
    var subjectList: [String] {
        return Array(subjects.keys).sorted()
    }
    var wantsListByDate: Bool
    var firstName: String
    var lastName: String
    var includeEndFocusButton: Bool
    
    /// Adds subject
    func addSubject(name: String) {
        subjects[name] = Color(uiColor: randomColor(hue: getHue(), luminosity: .dark))
        saveUserData()
    }
    
    /// Saves user data to local file.
    func saveUserData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("userSettings").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedNote = try? propertyListEncoder.encode(self)
        try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /// Retrieves saved user data.
    func retrieveUserData() {
        let propertyListDecoder = PropertyListDecoder()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("userSettings").appendingPathExtension("plist")
        if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedUserData = try? propertyListDecoder.decode(UserData.self, from: retrievedNoteData) {
            self.subjects = decodedUserData.subjects
            self.firstName = decodedUserData.firstName
            self.lastName = decodedUserData.lastName
            self.wantsListByDate = decodedUserData.wantsListByDate
            self.includeEndFocusButton = decodedUserData.includeEndFocusButton
        }
    }
    
    /// Initializer
    init() {
        hueCounter = 0
        subjects = [:]
        wantsListByDate = true
        firstName = ""
        lastName = ""
        includeEndFocusButton = true
        retrieveUserData()
        
    }
    
    /// Updates user data. Contains the information about the list of courses.
    func updateCourses(fromList toDoList: ToDoList) {
        print("*** Updating Courses")
        for item: ToDoItem in toDoList.list {
            print("*** Updating \(item.className)")
            if subjects[item.className] == nil {
                subjects[item.className] = Color(uiColor: randomColor(hue: getHue(), luminosity: .dark))
            }
        }
        saveUserData()
    }
    
    /// Gets the next hue so the colors are differentiated when generating.
    func getHue() -> Hue {
        var hues: [Hue] = [.red, .orange, .green, .blue, .purple, .pink]
        hueCounter += 1
        return hues[hueCounter % 6]
    }
}

///  Codable Color struct to enable saving courses.
struct Color: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
