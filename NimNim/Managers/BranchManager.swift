//
//  BranchManager.swift
//  NimNim
//
//  Created by Raghav Vij on 11/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import UIKit
import Branch

class BranchManager {
    static let shared = BranchManager()
    
    func initialize(withLaunchOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) {
        Branch.setUseTestBranchKey(true)
        Branch.getInstance().enableLogging()
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            if let params = params as? [String:Any] {
                print("branch params:\(params)")

            }
        }
    }
}
