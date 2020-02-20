//
//  AppDelegate.swift
//  BLT
//
//  Created by LorentzenN on 11/9/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		let center = UNUserNotificationCenter.current()

		let options: UNAuthorizationOptions = [.sound, .alert]

		center.requestAuthorization(options: options) {
			(granted, error) in
			if error != nil {
				print("Error")
			}
		}

		center.delegate = self

		return true
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .badge, .sound])
	}

	func applicationWillResignActive(_ application: UIApplication) {

	}

	func applicationDidEnterBackground(_ application: UIApplication) {

	}

	func applicationWillEnterForeground(_ application: UIApplication) {

	}

	func applicationDidBecomeActive(_ application: UIApplication) {

	}

	func applicationWillTerminate(_ application: UIApplication) {
		myToDoList.storeList()
		globalTaskDatabase.saveDatabaseLog(targetLog: globalTaskDatabase.currentDatabaseLog)
		globalTaskDatabase.saveDatabaseIndex()
	}

}
