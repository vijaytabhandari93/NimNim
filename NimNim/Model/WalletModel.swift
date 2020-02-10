//
//  WalletModel.swift
//  NimNim
//
//  Created by Raghav Vij on 10/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletModel: NSObject, Mappable, Codable {
    
    var total:Int?
    var data:[WalletDetailsModel]?
    var totalPages:Int?
    var currentPage:Int?
   
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        total     <- map["total"]
        data           <- map["data"]
        totalPages            <- map["total_pages"]
        currentPage     <- map["current_page"]
    }
    
//    func saveInUserDefaults() {
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.User)
//        UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...try? PropertyListEncoder().encode(self) is used to encode. Since user defaults.standard.set uses only standard data types we have to encode the user model geenerated.
//    }
//
//    static func fetchFromUserDefaults() -> UserModel? {
//        if let savedValue = UserDefaults.standard.object(forKey: UserDefaultKeys.User) as? Data {
//            if let decodedModel = try? PropertyListDecoder().decode(UserModel.self, from: savedValue) {
//                return decodedModel
//            }
//        }
//        return nil
//    }
}
class WalletDetailsModel:NSObject, Mappable, Codable {
    
    var amount:Double?
    var type:String?
    var balance : Double?
    var descriptiona :String?
    var id :String?
    var customer : String?
    var created_at  : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        amount        <- map["amount"]
        type       <- map["type"]
        balance        <- map["balance"]
        descriptiona <- map["description"]
        id       <- map["_id"]
        customer       <- map["customer"]
        created_at       <- map["created_at"]
    }
    
  
    
}
