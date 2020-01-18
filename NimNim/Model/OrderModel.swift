//
//  OrderModel.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class OrderBaseModel:NSObject, Mappable, Codable {
var data:[OrderModel]?
required convenience init?(map: Map) { self.init() }

func mapping(map: Map) {
    data            <- map["data"]
    
}    
}

class OrderModel : NSObject, Mappable, Codable  {
    
    required convenience init?(map: Map) { self.init() }
    
    var orderStatus:String?
    var customerId:String?
    var couponCode:CouponModel?
    var cartId : String?
    var orderTotal : Int?
    var services : [ServiceModel]?  //servicemodel is a class which is like a dictionary of key value pairs
    var isWalletSelected:Bool? = true
    var v : String?
    var addressId : String?
    var CardId : String?
    var orderNumber : Int?
    var date : String = "key to be created"
   
    
    func mapping(map: Map) {
        orderStatus <- map["order_status"]
        customerId <- map["customerId"]
        couponCode <- map["couponCode"]
        cartId <- map["cart_id"]
        orderTotal <-  map["order_total"]
        services  <- map  ["services"]
        v   <- map ["__v"]
        addressId <- map["address_id"]
        CardId  <- map["card_id"]
        isWalletSelected <- map["isWalletSelected"]
        orderNumber <- map["orderNumber"]
        date  <-  map["date"]
    }
}

