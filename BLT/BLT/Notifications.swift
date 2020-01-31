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
    
    init(){
        
    }
    
    func prepareNotification(title: String?, subtitle: String?, body: String?){
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
        
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-nofications temp"
        
        let date = Date(timeIntervalSinceNow: 10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
            center.add(request) {(error) in
            if error != nil {
                print("Error")
            }
        }
    }
}
