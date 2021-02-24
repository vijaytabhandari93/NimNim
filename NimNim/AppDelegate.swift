//
//  AppDelegate.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FirebaseMessaging
import Branch
import KlaviyoSwift
import Firebase
import FirebaseDynamicLinks


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Setting up the root view controller of this project..i.e. initial view controller for project....
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        NavigationManager.shared.initializeApp()
        MixPanelManager.shared.initializeMixPanel()
        FirebaseManager.shared.initializeFirebase()
        PushNotificationsManager.shared.requestForPermission()
        PushNotificationsManager.shared.checkForPushNotificationFromAppLaunch(withLaunchOptions: launchOptions)
        BranchManager.shared.initialize(withLaunchOptions: launchOptions)
        Klaviyo.setupWithPublicAPIKey(apiKey: "pk_9c876b007807cd169b9419772de8306832")
        Events.appLaunched()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotificationsManager.shared.handlePushNotification(withUserInfo: userInfo)
    }
    
    //Used for GoogleSign In
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handle = false
        handle = GIDSignIn.sharedInstance().handle(url)
        handle = ApplicationDelegate.shared.application(app, open: url, options: options)
        Branch.getInstance().application(app, open: url, options: options)
        return handle
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error  == nil else {
                    print("Found an error!  \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandled
            {
                return true
            }
            else
                
            {
                return false
            }
        }
        return  false
    }
    
    
    
    func handleIncomingDynamicLink(_ dynamicLink : DynamicLink)
    {
        guard let url = dynamicLink.url else {
            print("Thats  weird my dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
    }
    //
    //    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
    //                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //        Branch.getInstance().continue(userActivity)
    //      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
    //        // ...
    //      }
    //
    //      return handled
    //    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handle = false
        handle = ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
        return handle
    }
    
    
    
}

