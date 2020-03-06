//
//  FirebaseManager.swift
//  NimNim
//
//  Created by Raghav Vij on 23/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore
class FirebaseManager {
    static let shared = FirebaseManager()
    
    func initializeFirebase() {
        FirebaseApp.configure()
        setupUserProperties()
    }
    
    func setupUserProperties() {
        if let userModel = UserModel.fetchFromUserDefaults(){
            if let firstName = userModel.firstName {
                Analytics.setUserProperty(firstName, forName: "firstname")
            }
            if let lastName = userModel.lastName {
                Analytics.setUserProperty(String(lastName.prefix(36)), forName: "lastname")
            }
            if let email = userModel.email {
                Analytics.setUserProperty(String(email.prefix(36)), forName: "email")
            }
            if let phone = userModel.phone {
                Analytics.setUserProperty(String(phone.prefix(36)), forName: "phone")
            }
            if let dob = userModel.dob {
                Analytics.setUserProperty(String(dob.prefix(36)), forName: "dob")
            }
            if let id = userModel.id {
                Analytics.setUserProperty(String(id.prefix(36)), forName: "userId")
            }
            if let token = userModel.token {
                Analytics.setUserProperty(String(token.prefix(36)), forName: "authtoken")
            }
        }
    }
    
    func fireEvent(withName name:String?, withProperties properties:[String:String]?) {
        if let name = name, let properties = properties {
            Analytics.logEvent(name, parameters: properties)
        }
    }

}
