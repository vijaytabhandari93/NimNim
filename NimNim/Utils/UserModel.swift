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
    var token:String?
    var profileImage : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        firstName     <- map["customer.first_name"]
        lastName           <- map["customer.last_name"]
        phone      <- map["customer.phone"]
        email            <- map["customer.email"]
        hashedPassword     <- map["customer.hashed_password"]
        provider           <- map["customer.provider"]
        salt      <- map["customer.salt"]
        id            <- map["customer._id"]
        dob            <- map["customer.dob"]
        token       <- map["token"]
        profileImage       <- map["customer.profileImage"]
      }
    
    func saveInUserDefaults() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.User)
        UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...try? PropertyListEncoder().encode(self) is used to encode. Since user defaults.standard.set uses only standard data types we have to encode the user model generated.
        saveInFirebase()
    }
    
    func saveInFirebase()  {
        FirebaseManager.shared.setupUserProperties()
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





