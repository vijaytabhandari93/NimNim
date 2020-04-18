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

class TimelineModel:NSObject, Mappable, Codable {
    var date:String?
    var service:String?
    var value:String?
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        date         <- map["date"]
        service      <- map["service"]
        value        <- map["value"]
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
    var paidViaWallet:Double? //Amount paid from user's  wallet
    var paidViaStripe:Double? //Amount paid from card
    var rushDeliveryCost:Double? // Rush Delivery charges
    var grandTotal:Double? // GrandTotal Amount - Price of  services + rush delivery - promo...
    var subTotal:Double? // price of services
    var walletPointsApplicable:Double?
    var timelines:[TimelineModel] = []
    //When submit ticket is tapped on submit ticket screen... you will create an Issue Model and store the concerned type and description in it...and pass this model to Order Details Screen...
    var deliverycost : Double? //(Number, normal delivery cost)
    var delivery_charges_waived: Bool? //(Boolean)
    var delivery_note : String? //(String, This note will be a message to be shown to the user if the admin has waived off his delivery charges)
    var rush_delivery_note: String?// Additional $20 will be charged
    func mapping(map: Map) {
        updated_at <- map["updated_at"]
        orderStatus <- map["order_status"]
        customerId <- map["customerId"]
        couponCode <- map["couponCode"]
        cartId <- map["cart_id"]
        orderTotal <-  map["order_total"]
        services  <- map  ["services"]
        v   <- map ["__v"]
        timelines <- map["timelines"]
        addressId <- map["address_id"]
        CardId  <- map["card_id"]
        isWalletSelected <- map["isWalletSelected"]
        orderNumber <- map["orderNumber"]
        date  <-  map["date"]
        createdAt <- map["created_at"]
        orderAmount<-map["order_amount"]///provided by  mukesh for orderAmout
        walletPoints<-map["walletPoints"]
        paidViaWallet <- map["paidViaWallet"]
        paidViaStripe <- map["paidViaStripe"]
        rushDeliveryCost <- map["rushdeliverycost"]
        subTotal <- map["sub_total"]
        grandTotal <- map["grand_total"]
        deliverycost <- map["deliverycost"]
        delivery_charges_waived <- map["delivery_charges_waived"]
        delivery_note <- map["delivery_note"]
        rush_delivery_note <- map["rush_delivery_note"]
    }
    func confirmRushRequiredOrNot() ->Int {
        if let services = services {
            for service in services {
                if service.isRushDeliverySelected == true {
                    return 1
                    break
                }
            }
        }
    return 0
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

