//
//  Card.swift
//  NimNim
//
//  Created by Raghav Vij on 28/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class CardModel: NSObject, Mappable, Codable {
    
    var object:String?
    var data:[CardDetailsModel]?
    var hasMore:String?
    var url:String?
   
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        object     <- map["object"]
        data           <- map["data"]
        hasMore            <- map["has_more"]
        url     <- map["url"]
    }
    
    func saveInUserDefaults() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.User)
        UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...try? PropertyListEncoder().encode(self) is used to encode. Since user defaults.standard.set uses only standard data types we have to encode the user model geenerated.
    }
    
    static func fetchFromUserDefaults() -> UserModel? {
        if let savedValue = UserDefaults.standard.object(forKey: UserDefaultKeys.User) as? Data {
            if let decodedModel = try? PropertyListDecoder().decode(UserModel.self, from: savedValue) {
                return decodedModel
            }
        }
        return nil
    }
}
class CardDetailsModel:NSObject, Mappable, Codable {
    
    var id:String?
    var name:String?
    var last4 : String?
    var expMonth :String?
    var expYear :String?
    var brand : String?
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        name        <- map["name"]
        id       <- map["id"]
        name        <- map["name"]
        last4       <- map["last4"]
        expMonth       <- map["exp_month"]
        expYear       <- map["exp_year"]
        brand       <- map["brand"]
    }
    
  
    
}
