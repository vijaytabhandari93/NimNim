//
//  BannersBaseModel.swift
//  NimNim
//
//  Created by Raghav Vij on 17/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import ObjectMapper

class BannersBaseModel:NSObject, Mappable {
    var currentPage:Int?
    var total:Int?
    var totalPages:Int?
    var data:[BannerModel]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        currentPage     <- map["current_page"]
        total           <- map["total"]
        totalPages      <- map["total_pages"]
        data            <- map["data"]
        
    }
    
}
class BannerModel:NSObject, Mappable, Codable {
    
    var id:String?
    var name:String?
    var alias:String?
    var banner:String?
    var v:Int?
    var icon : String?
    var deeplinking:String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        v        <- map["__v"]
        id       <- map["_id"]
        name    <- map["name"]
        alias   <- map["alias"]
        banner      <- map["banner"]
        icon <- map["icon"]
        deeplinking <- map["deeplinking"]
    }
}

