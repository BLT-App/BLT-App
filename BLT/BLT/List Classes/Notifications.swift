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
        var center = UNUserNotificationCenter.current()
        var content = UNMutableNotificationContent()
        
        if let t: String = title{
            content.title = t
        }
        else {
            content.title = "default"
            
        }
        if let s: String = subtitle {
            content.subtitle = s
        }
        else{
            content.subtitle = "it works"
        }
        
        if let b: String = body {
            content.body = b
        }
        else{
            content.body = "Yaaaayy"
        }
        
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-nofications temp"
        
        let date = Date(timeIntervalSinceNow: 10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
            center.add(request) {(error) in
            if error != nil {
                print(error)
            }
            }
    }
    
    
    
    
    
    
    
    
    
    
}
