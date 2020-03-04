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
import SwiftyJSON

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

    func checkForPushNotificationFromAppLaunch(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: Any] {
            handlePushNotification(withUserInfo: notification)
        }
    }
    
    func handlePushNotification(withUserInfo userInfo:[AnyHashable : Any]?) {
        if let userInfo = userInfo as? [String:Any] {
            let userInfoJson = JSON(arrayLiteral: userInfo)
            print(userInfoJson)
        }
    }
}
