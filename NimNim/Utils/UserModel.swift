//
//  UserModel.swift
//  NimNim
//
//  Created by Raghav Vij on 10/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class UserModel: NSObject, Mappable, Codable {
 
    var firstName:String?
    var lastName:String?
    var phone:String?
    var email:String?
    var hashedPassword:String?
    var provider:String?
    var salt:String?
    var id:String?
    var dob:String?
 
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        firstName     <- map["first_name"]
        lastName           <- map["last_name"]
        phone      <- map["phone"]
        email            <- map["email"]
        hashedPassword     <- map["hashed_password"]
        provider           <- map["provider"]
        salt      <- map["salt"]
        id            <- map["_id"]
        dob            <- map["dob"]
      }
    func saveInUserDefaults() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.User)
        _ = UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...
    }
    
    static func fetchFromUserDefaults() -> UserModel? {
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.User) as? Data {
            if let decodedModel = try? PropertyListDecoder().decode(UserModel.self, from: decoded) {
                return decodedModel
            }
        }
        return nil
    }
}





