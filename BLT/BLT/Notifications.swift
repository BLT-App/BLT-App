//
//  Notifications.swift
//  BLT
//
//  Created by DLG on 1/30/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import Datez

/// Class that handles notifications.
class Notifications {
    
    /// Date object for when the user receives a notification.
    var date: Date
    
    var notifRequests: [String]
    
    /// Basic initializer sets default notification date to 10s from when called.
    init() {
        date = Date(timeIntervalSinceNow: 10)
        notifRequests = []
    }
    
    
    
    /**
     Creates a new notification and adds it to the notification center to be sent at a specified time.
     - Parameters:
         - title: The string to be displayed in title of the notification; can be nil.
         - subtitle: The *subtitle* of the notification. can be nil.
         - body: The string to be displayed in the body of the notification. can be nil
         - notifDate: The date when the user should recieve the notification. can be nil will resort to default date if nil.
    */
    func prepareNotification(title: String?, subtitle: String?, body: String?, notifDate: Date?) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        if let title: String = title {
            content.title = title
        } else {
            content.title = "Title"
        }
        
        if let subtitle: String = subtitle {
            content.subtitle = subtitle
        } else {
            content.subtitle = "Subtitle"
        }
        
        if let body: String = body {
            content.body = body
        } else {
            content.body = "Body"
        }
        
        if let ndate: Date = notifDate {
            date = ndate
        } else {
            date = Date(timeIntervalSinceNow: 10)
        }
            
        content.sound = UNNotificationSound.default
        
        content.threadIdentifier = UUID().uuidString
        
        let dateComponents =  Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) {(error) in
            if error != nil {
                print("Error")
            }
        }
    }
    
    /// deletes all pending notifications
    func deleteAllPendingNotifications(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
    }
    
    ///deletes specified notifications
    func deleteSpecificNotifications(array: [String]){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: array)
        
    }
    
    
    ///function for preparing repeating notifications (not fully functional yet)
    func prepareRegularUpdateNotif(notifnum: Int){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "update"
        content.body = "body"
        
        var dateComponents = DateComponents()
        var identifier: String
        if(notifnum == 1){
            dateComponents.hour = 12
            identifier = "reminder1"
        }
        else if(notifnum == 3){
            
            identifier = "reminder3"
        }
            
        else if(notifnum == 7){
            dateComponents.weekday = 1
            identifier = "reminder7"
        }
            
        else if(notifnum == 14){
            
            identifier = "reminder14"
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "", content: content, trigger: trigger)
        center.add(request) {(error) in
            if error != nil {
                print("Error")
            }
        }
        
        
        
    }
}
