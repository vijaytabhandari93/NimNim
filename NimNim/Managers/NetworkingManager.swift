//
//  NetworkingManager.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager {
    
    static let shared = NetworkingManager() //This is used to create a singleton object of this class...
    
    // Making the init of this class as private will ensure that no one from outside this class can initialize it...
    private init() {
    }
}




