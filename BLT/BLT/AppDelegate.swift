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

/// Delegate for the application.
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    /**
     Tells the delegate that the launch process has begun but that state restoration has not yet occurred.
     also asks the user for notifications permissions when the app is first launched.
     - Parameters:
         - application: the singleton app object.
         - didFinishLaunchingWithOptions launchOptions: A dictionary indicating the reason the app was launched.
         - Returns: false if the app cannot handle the URL resource or continue a user activity. (look up more in developer documentation from apple if you want).
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.sound, .alert]
        
        center.requestAuthorization(options: options) {
            (granted, error) in if error != nil {
                print("Error")
            }
        }
        
        center.delegate = self
        
        return true
    }
    /**
     function for the user notification center.
     - Parameters:
        - center: the center that is used for notifications.
        - willPresent notification: a notification to be entered.
        - withCompletionHandler completionHandler: options to be used in notifications.
    */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    /// Tells the delegate that the app is about to become inactive.
    func applicationWillResignActive(_ application: UIApplication) {

    }

    /// Tells the delegate that the app is now in the background.
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    /// Tells the delegate that the app is about to enter the foreground.
    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    /// Tells the delegate that the app has become active.
    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    /// Tells the delegate when the app is about to terminate.
    func applicationWillTerminate(_ application: UIApplication) {
        toDoListManager.storeList()
        globalTaskDatabase.saveDatabaseLog(targetLog: globalTaskDatabase.currentDatabaseLog)
        globalTaskDatabase.saveDatabaseIndex()
    }

}
