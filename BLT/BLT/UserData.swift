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

///Global UserData Variable
var globalData = UserData()

/**
 A class that stores user data.
 */
class UserData: Codable {

	/// Number of hues currently defined.
	var hueCounter = 0

	/// Subject to Color dictionary, matches each color to a particular subject.
	var subjects: [String: Color] = [:]

	/// Sorted list of Subjects.
	var subjectList: [String] {
		return Array(subjects.keys).sorted()
	}

	/// Whether or not user wants to do list sorted by date.
	var wantsListByDate: Bool = true {
		didSet {
			saveUserData()
		}
	}

	/// First name of the user.
	var firstName: String = "" {
		didSet {
			saveUserData()
		}
	}

	/// Last name of the user.
	var lastName: String = "" {
		didSet {
			saveUserData()
		}
	}

	/// Whether or not user wants 'End focus mode' button.
	var includeEndFocusButton: Bool = true {
		didSet {
			saveUserData()
		}
	}

	/// Saves user data to local file.
	func saveUserData() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let archiveURL = documentsDirectory.appendingPathComponent("userSettings").appendingPathExtension("plist")
		let propertyListEncoder = PropertyListEncoder()
		let encodedNote = try? propertyListEncoder.encode(self)
		try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
		UserDefaults.standard.set(true, forKey: "UserDataHasLoaded")
		print("** Stored User Data")
	}

	/// Retrieves saved user data.
	func retrieveUserData() {
		print("** Retrieving User Data")
		let propertyListDecoder = PropertyListDecoder()
		let documentsDirectory = FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask).first!
		let archiveURL = documentsDirectory.appendingPathComponent("userSettings")
			.appendingPathExtension("plist")
		if let retrievedNoteData = try? Data(contentsOf: archiveURL),
		   let decodedUserData = try? propertyListDecoder.decode(UserData.self, from: retrievedNoteData) {
			self.hueCounter = decodedUserData.hueCounter
			self.subjects = decodedUserData.subjects
			self.firstName = decodedUserData.firstName
			self.lastName = decodedUserData.lastName
			self.wantsListByDate = decodedUserData.wantsListByDate
			self.includeEndFocusButton = decodedUserData.includeEndFocusButton
		}
	}

	/// Initializer
	init() {
		if UserDefaults.standard.object(forKey: "UserDataHasLoaded") == nil {
			saveUserData()
			// Run any code for the first time user launches app
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
		for item: ToDoItem in toDoList.list {
			if subjects[item.className] == nil {
				subjects[item.className] = Color(uiColor: randomColor(hue: getHue(), luminosity: .dark))
			}
		}
		saveUserData()
	}

	/// Gets the next hue so the colors are differentiated when generating.
	/// - Returns: Hue object.
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
