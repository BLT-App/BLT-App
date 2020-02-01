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
class Notifications {
    
    var date: Date
    
    //basic initializer sets default notification date to 10s from when called
    init(){
        date = Date(timeIntervalSinceNow: 10)
    }
    
    
    // sends the notification when called
    // title: title of notification
    //subtitle: subtitle of notification
    //body: body of notification
    // notifDate: the date for the notification to be sent
    func prepareNotification(title: String?, subtitle: String?, body: String?, notifDate: Date?){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        if let title: String = title {
            content.title = title
        }
        else {
            content.title = "Title"
        }
        
        if let subtitle: String = subtitle {
            content.subtitle = subtitle
        }
        else {
            content.subtitle = "Subtitle"
        }
        
        if let body: String = body {
            content.body = body
        }
            
        else {
            content.body = "Body"
        }
        
        if let ndate: Date = notifDate  {
            date = ndate
        }
        else{
            date = Date(timeIntervalSinceNow: 10)
        }
            
            
        content.sound = UNNotificationSound.default
        
        
        content.threadIdentifier = UUID().uuidString
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) {(error) in
            if error != nil {
                print("Error")
            }
        }
    }
}
