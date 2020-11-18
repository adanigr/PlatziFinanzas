//
//  LocalNotificationController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/20/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationsController {
    
    init() {
        //Get instance for notification center
        let center = UNUserNotificationCenter.current()
        //Send message to authorize sending notifications to the user
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if success {
                self.addNotifications()
                self.addSchedulingNotificationLocally()
            }
        }
    }
    
    func test() {
    }
    
    func addSchedulingNotificationLocally() {
        // Listing 1 Configuring the notification content
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Wednesday at 2:07 pm"
        
        
//        let imageName = "Google"
//        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "pdf") else { return }
//
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//
//        content.attachments = [attachment]
        
        //Listing 2 Configuring a recurring date-based trigger
        // Configure the recurring date.
        var dateComponents = DateComponents()
        
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = dateComponents.day //4  // Wednesday
        dateComponents.hour = 13    // 13:00 hours
        dateComponents.minute = 50  // 13:50 minutes
        dateComponents.second = 00  // 13:50:00 seconds
        
        content.body = "Date weekday \(String(describing: dateComponents.weekday)) at \(String(describing: dateComponents.hour)):\(String(describing: dateComponents.minute)):\(String(describing: dateComponents.second))"
        
        dateComponents.timeZone = .current
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        //Listing 3 Registering the notification request
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func addNotifications() {
        //Get instance for notification center
        let center = UNUserNotificationCenter.current()
        //Get instance content with annoter properties
        let content = UNMutableNotificationContent()
        content.title = "¿Hiciste alguna compra el día de hoy?"
        content.body = "Recuerda agregar los gastos del día de hoy"
        content.sound = UNNotificationSound.default
        
//        let imageName = "arrest"
//        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
//        
//        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//        
//        content.attachments = [attachment]
        
        //set trigger for notificacions
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            guard let error = error else {
                return
            }
            
            print(error.localizedDescription)
        }
    }
}
