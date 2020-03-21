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
    var v : String?
    var addressId : String?
    var CardId : String?
    var deliveryRelatedUploadedImages : [String] =  []
    var deliveryNotes : String?
    var deliveryPreference : String?
    var delivery_note :  String?  //$4 delivery fee applied on orders below $35,
    var rush_delivery_note:  String? //Additional $20 will be charged
    
    func mapping(map: Map) {
        orderStatus <- map["order_status"]
        customerId <- map["customerId"]
        couponCode <- map["couponCode"] // FETCH CART CALL
        cartId <- map["cart_id"]
        orderTotal <-  map["order_total"]
        services  <- map  ["services"]
        v   <- map ["__v"]
        addressId <- map["address_id"]
        CardId  <- map["card_id"]
        isWalletSelected <- map["isWalletSelected"]
        deliveryNotes <- map["deliveryNotes"]
        deliveryPreference  <- map["deliveryPreference"]
        deliveryRelatedUploadedImages <- map["deliveryRelatedUploadedImages"]
        delivery_note <- map["delivery_note"]
        rush_delivery_note <- map["rush_delivery_note"]
    }
}
