//
//  CouponsUserModel.swift
//  NimNim
//
//  Created by Raghav Vij on 19/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class CouponBaseModel:NSObject, Mappable {
    var currentPage:Int?
    var total:Int?
    var totalPages:Int?
    var data:[CouponModel]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        currentPage     <- map["current_page"]
        total           <- map["total"]
        totalPages      <- map["total_pages"]
        data            <- map["data"]
        
    }
    
}
class CouponModel:NSObject, Mappable, Codable {
    
    var id:String?
    var discount:Int?
    var code:String?
    var v:Int?
    var validfrom : String?
    var validto : String?
    var codeName : String?
    var idTobeused  : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        validto  <- map["valid_to"]
        validfrom  <- map["valid_from"]
        v        <- map["__v"]
        id       <- map["cartId"] // DONE  AS IN FETCH  CART  RESPONSE
        idTobeused    <- map["_id"]
        discount    <- map["discount"]
        code   <- map["couponCode"] // DONE  AS IN FETCH  CART  RESPONSE
        codeName <- map["code"]
}

}
