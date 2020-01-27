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
class UserData {
    
    /// Defaults.
    let defaults = UserDefaults.standard
    
    /// Whether or not User Data has been loaded.
    var hasLoaded: Bool {
        return defaults.object(forKey: "User Data") != nil
    }
    
    /// Number of hues currently defined.
    var hueCounter = 0
    
    /// Subject to Color dictionary.
    var subjects: [String: Color] = [:]
    
    /// Sorted list of Subjects.
    var subjectList: [String] {
        return Array(subjects.keys).sorted()
    }
    
    /// Whether or not user wants to do list sorted by date.
    var wantsListByDate: Bool = true
    
    /// First name of the user.
    var firstName: String = ""
    
    /// Last name of the user.
    var lastName: String = ""
    
    /// Whether or not user wants 'End focus mode' button.
    var includeEndFocusButton: Bool = true
    
    /// Saves user data to local file.
    func saveUserData() {
        defaults.set(self, forKey: "UserData")
    }
    
    /// Retrieves saved user data.
    func retrieveUserData() {
        let data = defaults.object(forKey: "UserData")
        if data == nil {
            saveUserData()
        } else {
            let userData = data as! UserData
            self.hueCounter = userData.hueCounter
            self.subjects = userData.subjects
            self.wantsListByDate = userData.wantsListByDate
            self.firstName = userData.firstName
            self.lastName = userData.lastName
            self.includeEndFocusButton = userData.includeEndFocusButton
        }
    }
    
    /// Initializer
    init() {
        if defaults.object(forKey: "UserData") == nil {
            saveUserData()
        }
        retrieveUserData()
    }
    
    /// Adds subject
    /// - Parameters:
    ///     - name: The name of the Subject to add.
    func addSubject(name: String) {
        subjects[name] = Color(uiColor: randomColor(hue: getHue(), luminosity: .dark))
        saveUserData()
    }
    
    /// Updates user data. Contains the information about the list of courses.
    /// - Parameters:
    ///     - toDoList: The main ToDoList of the user.
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
        saveUserData()
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
