//
//  PushNotificationsManager.swift
//  NimNim
//
//  Created by Raghav Vij on 03/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class PushNotificationsManager {
    static let shared = PushNotificationsManager()
    
    init() {
        
    }
    
    func requestForPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {[weak self] (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
