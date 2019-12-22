//
//  CartModel.swift
//  NimNim
//
//  Created by Raghav Vij on 16/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class CartModel : NSObject, Mappable, Codable  {
    required convenience init?(map: Map) { self.init() }
    var orderStatus:String?
    var customerId:String?
    var couponCodes:[String]?
    var cartId : String?
    var orderTotal : Int?
    var services : [ServiceModel]?  //servicemodel is a class which is like a dictionary of key value pairs
    var id : String?
    var v : String?
    
    func mapping(map: Map) {
        orderStatus <- map["order_status"]
        customerId <- map["customerId"]
        couponCodes <- map["couponCodes"]
        cartId <- map["cart_id"]
        orderTotal <-  map["order_total"]
        services  <- map  ["services"]
        id  <- map["_id"]
        v   <- map ["__v"]
    }
}
