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
    var couponCode:CouponModel?
    var cartId : String?
    var orderTotal : Int?
    var services : [ServiceModel]?  //servicemodel is a class which is like a dictionary of key value pairs
    var isWalletSelected:Bool? = true
    var id : String?
    var v : String?
    
    func mapping(map: Map) {
        orderStatus <- map["order_status"]
        customerId <- map["customerId"]
        couponCode <- map["couponCode"]
        cartId <- map["cart_id"]
        orderTotal <-  map["order_total"]
        services  <- map  ["services"]
        id  <- map["_id"]
        v   <- map ["__v"]
    }
}
