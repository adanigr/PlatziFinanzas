//
//  PushNotificationsController.swift
//  PlatziFinanzas
//
//  Created by Adan Reséndiz on 2/23/19.
//  Copyright © 2019 Adan Reséndiz. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging

class PushNotificationsController: NSObject {
    
    init(application : UIApplication) {
        //se llama este constructor al utilizar NSObject
        super.init()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (success, error) in
            //Registramos app sobre el hilo principal
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
    }
    
    func addDeviceToken(_ token: Data) {
        Messaging.messaging().apnsToken = token
    }
}

extension PushNotificationsController: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token \(fcmToken)")
        
        let data: [String:String] = ["token": fcmToken]
    }
}
