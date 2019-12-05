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
    var detergents : [PreferenceModel]?
    var wash : [PreferenceModel]?
    var drying : [PreferenceModel]?
    var starch : [PreferenceModel]?
    var bleach : [PreferenceModel]?
    var softner : [PreferenceModel]?
    var returnPreferences : [PreferenceModel]?
    var ordering:Int?
    var items : [ItemModel]?
    var minimum_quantity_required:Int?
    var price : Double?
    var pricing:String?
    var rushDeliveryOptions : [RushDeliveryOptionsModel]?
    var v:Int?
    var isNimNimItAvailable:Bool?
    var costPerPiece : Double?
    var costPerPieceBox : Int?

    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        v        <- map["__v"]
        id       <- map["_id"]
        name    <- map["name"]
        alias   <- map["alias"]
        costPerPiece   <- map["cost_per_piece"]
        costPerPieceBox   <- map["cost_per_piece_box"]
        icon  <- map["icon"]
        detergents <- map["detergents"]
        wash <- map["wash"]
        drying <- map["drying"]
        softner <- map["softner"]
        bleach <- map["bleach"]
        starch <- map["starch"]
        returnPreferences <- map["return_preference"]
        ordering    <- map["ordering"]
        items <- map["items"]
        minimum_quantity_required <- map["minimum_quantity_required"]
        price <- map["price"]
        pricing <- map["pricing"]
        rushDeliveryOptions <- map["rush_delivery_options"]
        isNimNimItAvailable <- map["is_nimnim_it_available"]
    }
    
    func getMaleItems() -> [ItemModel] {
        var maleItems:[ItemModel] = []  
        if let items = items, items.count > 0 {
            for item in items {
                if item.genders == "male" {
                    maleItems.append(item)
                }
            }
        }
        return maleItems
    }
    
    func getFemaleItems() -> [ItemModel] {
        var femaleItems:[ItemModel] = []
        if let items = items, items.count > 0 {
            for item in items {
                if item.genders == "female" {
                    femaleItems.append(item)
                }
            }
        }
        return femaleItems
    }
}
class PreferenceModel:NSObject, Mappable, Codable {
    var id:String?
    var title:String?
    var icon: String?
    var isNimNimItValue:Bool?
    var isSelected:Bool? = false
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id <- map["_id"]
        title <- map["title"]
        icon <- map["icon"]
        isNimNimItValue <- map["nimnimitvalue"]
    }
}

  

class ItemModel:NSObject, Mappable, Codable {
    var id:String?
    var name : String?
    var laundryPrice : String?
    var drycleaningPrice : String?
    var price:Int?
    var genders:String?
    var icon : String?
    
    //this is our property
    var count:Int? = 0
    var maleCount:Int? = 0
    var femaleCount:Int? = 0
    
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        name             <- map["name"]
        id               <- map["_id"]
        laundryPrice     <- map["laundry_price"]
        drycleaningPrice <- map["drycleaning_price"]
        price            <- map["price"]
        genders          <- map["gender"]
        icon             <- map["icon"]
    }
}

class RushDeliveryOptionsModel:NSObject, Mappable, Codable {
    var id:String?
    var turnAroundTime :String?
    var price :Int?
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        id       <- map["_id"]
        turnAroundTime <- map["turn_around_time"]
        price <- map["price"]
    }
}





