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
    var orderAmount : Double?
    var services : [ServiceModel]?  //servicemodel is a class which is like a dictionary of key value pairs
    var isWalletSelected:Bool? = true
    var v : String?
    var addressId : String?
    var CardId : String?
    var orderNumber : Int?
    var date : String = "key to be created"
    var updated_at : String?
    var createdAt :String?
    var walletPoints : String?//later to be used in fetch order history
    var issues:[IssueModel] = []

    //When submit ticket is tapped on submit ticket screen... you will create an Issue Model and store the concerned type and description in it...and pass this model to Order Details Screen...
    
    func mapping(map: Map) {
        updated_at <- map["updated_at"]
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
        createdAt <- map["created_at"]
        orderAmount<-map["order_amount"]///provided by  mukesh for orderAmout
        walletPoints<-map["walletPoints"]
    }
}

class IssueModel: NSObject, Mappable, Codable {
    var type:String?
    var issueDescription:String?
    
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        type <- map["type"]
        issueDescription <- map["issueDescription"]
    }
}

