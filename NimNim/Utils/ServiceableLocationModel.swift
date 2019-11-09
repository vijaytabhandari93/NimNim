//
//  ServiceableLocationModel.swift
//  NimNim
//
//  Created by Raghav Vij on 05/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class ServiceableLocationModel:NSObject, Mappable {
    var currentPage:Int?
    var total:Int?
    var totalPages:Int?
    var data:[LocationModel]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        currentPage     <- map["current_page"]
        total           <- map["total"]
        totalPages      <- map["total_pages"]
        data            <- map["data"]
        
    }
}

class LocationModel:NSObject, Mappable, Codable {
    var v:Int?
    var id:String?
    var title:String?
    var radius:String?
    var lat:String?
    var long:String?
    var pincode:String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        v        <- map["__v"]
        id       <- map["_id"]
        title    <- map["title"]
        radius   <- map["radius"]
        lat      <- map["latitude"]
        long     <- map["longnitude"]
        pincode  <- map["pincode"]
    }
    
    func saveInUserDefaults() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.location)
        _ = UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...
    }
    
    static func fetchFromUserDefaults() -> LocationModel? {
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.location) as? Data {
            if let decodedModel = try? PropertyListDecoder().decode(LocationModel.self, from: decoded) {
                return decodedModel
            }
        }
        return nil
    }
    
}
