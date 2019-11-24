//
//  ServiceBaseModel.swift
//  NimNim
//
//  Created by Raghav Vij on 18/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class ServiceBaseModel:NSObject, Mappable, Codable {
    var currentPage:Int?
    var total:Int?
    var totalPages:Int?
    var data:[ServiceModel]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        currentPage     <- map["current_page"]
        total           <- map["total"]
        totalPages      <- map["total_pages"]
        data            <- map["data"]
        
    }
    func saveInUserDefaults() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: UserDefaultKeys.services)
        UserDefaults.standard.synchronize() // This is a recommendation to do every time when we save anything in userdefaults...try? PropertyListEncoder().encode(self) is used to encode
    }
    
    static func fetchFromUserDefaults() -> ServiceBaseModel? {
        if let decoded = UserDefaults.standard.object(forKey: UserDefaultKeys.services) as? Data {
            if let decodedModel = try? PropertyListDecoder().decode(ServiceBaseModel.self, from: decoded) {
                return decodedModel
            }
        }
        return nil
    }
    
}
class ServiceModel:NSObject, Mappable, Codable {
    
    var id:String?
    var name:String?
    var alias:String?
    var icon:String?
    var detergents : [detergentsdic]?
    var wash : [washdic]?
    var drying : [dryingdic]?
    var starch : [starchdic]?
    var return_preferences : [return_preferencesdic]?
    var ordering:Int?
    var items : [itemsdic]?
    var minimum_quantity_required : Int?
    var price : Int?
    var pricing:String?
    var rush_delivery_options : [rush_delivery_optionsdic]?
    var v:Int?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        v        <- map["__v"]
        id       <- map["_id"]
        name    <- map["name"]
        alias   <- map["alias"]
        icon  <- map["icon"]
        detergents <- map["detergents"]
        wash <- map["wash"]
        drying <- map["drying"]
        starch <- map["starch"]
        return_preferences <- map["return_preferences"]
        ordering    <- map["ordering"]
        items <- map["items"]
        minimum_quantity_required <- map["minimum_quantity_required"]
        price <- map["price"]
        pricing <- map["pricing"]
        rush_delivery_options <- map["rush_delivery_options"]
    }

}
class detergentsdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id <- map["_id"]
    }
}
class washdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}
class dryingdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}
class starchdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}
class return_preferencesdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}

class itemsdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}

class rush_delivery_optionsdic:NSObject, Mappable, Codable {
    var id:String?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
    }
}





