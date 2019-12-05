//
//  AddressModel.swift
//  NimNim
//
//  Created by Raghav Vij on 30/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressModel: NSObject, Mappable, Codable {
    
    var id:String?
    var data:[AddressDetailsModel]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        id     <- map["_id"]
        data   <- map["data"]
        
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
class AddressDetailsModel:NSObject, Mappable, Codable {
    
    var id:String?
    var label:String?
    var area:String?
    var house:String?
    var landmark:String?
    var pincode:String?
    var street:String?
    var city:String?
    var state:String?
    var phone:String?
    var lat:String?
    var long:String?
    
 required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        label        <- map["label"]
        id       <- map["_id"]
        area        <- map["area"]
        house        <- map["house"]
        landmark       <- map["landmark"]
        pincode        <- map["pincode"]
        city        <- map["city"]
        state       <- map["state"]
        phone        <- map["phone"]
        lat       <- map["lat"]
        long        <- map["long"]
        street        <- map["street"]
    }
    
}




