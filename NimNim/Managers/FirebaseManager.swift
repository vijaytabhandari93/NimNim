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
    }
    
    
}
