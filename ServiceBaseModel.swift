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
    var descrip:String?
    var wash : [PreferenceModel]?
    var drying : [PreferenceModel]?
    var starch : [PreferenceModel]?
    var bleach : [PreferenceModel]?
    var softner : [PreferenceModel]?
    var returnPreferences : [PreferenceModel]?
    var ordering:Int?
    var items : [ItemModel]?
    var tasks : [TaskModel]?//for shoe repair...
    var minimum_quantity_required:Int?
    var price : Double?
    var pricing:String?
    var rushDeliveryOptions : [RushDeliveryOptionsModel]?
    var v:Int?
    var isNimNimItAvailable:Bool?
    var costPerPiece : Double?
    var costPerPieceBox : Int?
    //Custom Variables
    var uploadedImages:[String] = []
    var specialNotes:String?
    var numberOfClothes:Int?
    var isRushDeliverySelected:Bool = false
    var needHangers:Bool = false
    var pickupDate : String?
    var dropOffDate : String?
    var pickUpTime : String?
    var dropOffTime  : String?
    var turnAroundTime:String?
    //Not to be sent to server..hence not adding in mapping function
    var isSelectedForNimNimIt = false
    //This variable will be used to group the service models with the 
    var finalTurnaroundTime:String? {
        get {
            if isRushDeliverySelected {
                if let rushDeliveryOptions = rushDeliveryOptions, rushDeliveryOptions.count > 0 {
                    return  rushDeliveryOptions[0].turnAroundTime
                }else  {
                    return "0"
                }
            }else {
                if let turnAroundTime = turnAroundTime {
                    return turnAroundTime
                }else {
                    return "0"
                }
            }
        }
    }
    var servicePrice : String?
    
    enum Alias:String {
        case washAndFold = "wash-and-fold"
        case washAndAirDry = "wash-and-air-dry"
        case launderedShirts = "laundered-shirts"
        case householdItems = "household-items"
        case dryCleaning = "dry-cleaning"
    }
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        v        <- map["__v"]
        id       <- map["_id"]
        name    <- map["name"]
        alias   <- map["alias"]
        costPerPiece   <- map["cost_per_piece"]
        costPerPieceBox   <- map["cost_per_piece_box"]
        icon  <- map["icon"]
        descrip <- map["description"]
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
        uploadedImages <- map["uploaded_images"]
        specialNotes <- map["special_notes"]
        numberOfClothes <- map["noOfClothes"]
        isRushDeliverySelected <- map["need_rush_delivery"]
        needHangers <- map["needHangers"]
        pickupDate <- map["pickupDate"]
        dropOffDate <- map["dropOffDate"]
        pickUpTime <- map["pickUpTime"]
        dropOffTime <- map["dropOffTime"]
        turnAroundTime <- map["turn_around_time"]
        servicePrice <- map["servicePrice"]
        tasks        <- map["tasks"]
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
    
    // The below functions are useful to do changes in the model.
    
    func setupNimNimItForWashAndFold() {
        selectNimNimItPreference(forPreferences: detergents)
        selectNimNimItPreference(forPreferences: wash)
        selectNimNimItPreference(forPreferences: drying)
        selectNimNimItPreference(forPreferences: bleach)
        selectNimNimItPreference(forPreferences: softner)
    }
    
    func setupNimNimItForWashAndAirDry() {
        selectNimNimItPreference(forPreferences: wash)
        selectNimNimItPreference(forPreferences: bleach)
        selectNimNimItPreference(forPreferences: softner)
    }
    
    func setupNimNimItForWashPressedShirts() {
        selectNimNimItPreference(forPreferences: detergents)
        selectNimNimItPreference(forPreferences: starch)
        selectNimNimItPreference(forPreferences: returnPreferences)
    }
    
    
    func selectNimNimItPreference(forPreferences preferences:[PreferenceModel]?) {
        if let preferences = preferences {
            for preference in preferences {
                if preference.isNimNimItValue == true {
                    preference.isSelected = true
                }else {
                    preference.isSelected = false
                }
            }
        }
    }
    
    func productQuantity() -> Int {
        if let alias = alias {
            if let value = Alias(rawValue: alias) {
                switch value {
                case .washAndFold:
                    if let numberOfClothes = numberOfClothes {
                        return numberOfClothes
                    }
                case .washAndAirDry:
                    if let numberOfClothes = numberOfClothes {
                        return numberOfClothes
                    }
                case .launderedShirts:
                    if let numberOfClothes = numberOfClothes {
                        return numberOfClothes
                    }
                case .householdItems:
                    var quantity = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.qty {
                                quantity = quantity + qty
                            }
                        }
                    }
                    return quantity
                case .dryCleaning:
                    var quantity = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.maleCount {
                                quantity = quantity + qty
                            }
                            if let qty = item.femaleCount {
                                quantity = quantity + qty
                            }
                        }
                    }
                    return quantity
                }
            }
        }
        return 0
    }
    
    func calculatePriceForService() -> String {
        if let alias = alias {
            if let value = Alias(rawValue: alias) {
                switch value {
                case .washAndFold:
                    if let price = price {
                        return "$\(price) / lb"
                    }
                case .washAndAirDry:
                    if let price = price {
                        return "$\(price) / lb"
                    }
                case .launderedShirts:
                    var price = 0
                    if let numberOfClothes = numberOfClothes  {
                        if returnPreferences?.first?.isSelected == true {
                            price = price + numberOfClothes*(costPerPieceBox ?? 0)
                        }else  {
                            price = price + numberOfClothes*Int(costPerPiece ?? 0)
                        }
                    }
                    if isRushDeliverySelected == true {
                        if let rushPrice = rushDeliveryOptions?.first?.price{
                            price = price + rushPrice
                        }
                    }
                    return "$\(price)"
                case .householdItems:
                    var price = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.qty {
                                if item.IfDrycleaned {
                                    if let drycleaningPrice = item.dryCleaningPrice {
                                        if let intValue = Int(drycleaningPrice) {
                                            price = price +  (intValue * qty)
                                        }
                                    }
                                }
                                if item.IfLaundered {
                                    if let laundryPrice = item.laundryPrice {
                                        if let intValue = Int(laundryPrice) {
                                            price = price +  (intValue * qty)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if isRushDeliverySelected == true {
                        if let rushPrice = rushDeliveryOptions?.first?.price{
                            price = price + rushPrice
                        }
                    }
                    return "$\(price)"
                case .dryCleaning:
                    var price = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.maleCount {
                                if let ItemPrice =  item.price {
                                    price = price + (ItemPrice * qty)
                                }
                            }
                            if let qty = item.femaleCount {
                                if let ItemPrice =  item.price {
                                    price = price + (ItemPrice * qty)
                                }
                            }
                        }
                    }
                    if isRushDeliverySelected == true {
                        if let rushPrice = rushDeliveryOptions?.first?.price{
                            price = price + rushPrice
                        }
                    }
                    return "$\(price)"
                }
            }
        }
        return ""
    }
    func calculateGenderSpecificPriceForService() -> String {
        if let alias = alias {
            if let value = Alias(rawValue: alias) {
                switch value {
                case .washAndFold:
                    if let price = price {
                        return "$\(price) / lb"
                    }
                case .washAndAirDry:
                    if let price = price {
                        return "$\(price) / lb"
                    }
                case .launderedShirts:
                    return ""
                case .householdItems:
                    var price = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.qty {
                                if item.IfDrycleaned {
                                    if let drycleaningPrice = item.dryCleaningPrice {
                                        if let intValue = Int(drycleaningPrice) {
                                            price = price +  (intValue * qty)
                                        }
                                    }
                                }
                                if item.IfLaundered {
                                    if let laundryPrice = item.laundryPrice {
                                        if let intValue = Int(laundryPrice) {
                                            price = price +  (intValue * qty)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if isRushDeliverySelected == true {
                        if let rushPrice = rushDeliveryOptions?.first?.price{
                            price = price + rushPrice
                        }
                    }
                    return "$\(price)"
                case .dryCleaning:
                    var maleprice = 0
                    var femaleprice = 0
                    if let items = items {
                        for item in items {
                            if let qty = item.maleCount {
                                if let ItemPrice =  item.price {
                                    maleprice = maleprice + (ItemPrice * qty)
                                }
                            }
                            if let qty = item.femaleCount {
                                if let ItemPrice =  item.price {
                                    femaleprice = femaleprice + (ItemPrice * qty)
                                }
                            }
                        }
                    }
                    return "$\(femaleprice+maleprice)"
                }
            }
        }
        return ""
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
        isSelected <- map["is_selected"]
    }
}



class ItemModel:NSObject, Mappable, Codable, NSCopying {
    
    var id:String?
    var name : String?
    var price:Int? //dryCleaning
    var genders:String? //dryCleaning
    var icon : String?
    var laundryPrice : String? // presently made string //household
    var dryCleaningPrice : String? // presently made string //household
    var isSelectedShoeRepairPreference:Bool?
    
    
    //this is our property
    var maleCount:Int? = 0 //dryCleaning
    var femaleCount:Int? = 0 //dryCleaning
    var IfLaundered : Bool = false //household
    var IfDrycleaned : Bool = false //household
    var qty : Int? //household
    
    required convenience init?(map: Map) { self.init() }
    func mapping(map: Map) {
        name             <- map["name"]
        id               <- map["_id"]
        laundryPrice     <- map["laundry_price"]
        dryCleaningPrice <- map["drycleaning_price"]
        price            <- map["price"]
        genders          <- map["gender"]
        icon             <- map["icon"]
        maleCount     <- map["male_count"]
        femaleCount <- map["female_count"]
        IfLaundered            <- map["if_laundered"]
        IfDrycleaned          <- map["if_dryCleaned"]
        qty             <- map["qty"]
        isSelectedShoeRepairPreference <- map["is_selected_shoe_repair_pref"]
    }
    
    //Below function is used to create a copy of the ItemModel object...
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ItemModel(JSON: self.toJSON())
        return copy!
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

class TaskModel: NSObject, Mappable, Codable {
    var specialNotes:String?
    var uploadedImages:[String] = []
    var items:[ItemModel] = []
    var gender:String?
 
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        specialNotes   <- map["special_notes"]
        uploadedImages <- map["uploaded_images"]
        items  <- map["items"]
        gender         <- map["gender"]
    }
    func getGenderSpecificItems() -> [ItemModel]{
        if gender == "male" {
            return getMaleItems()
        }else
        {
            return getFemaleItems()
        }
    }
    
    func getSelectedItems() -> [ItemModel] {
        let genderSpecificItems = getGenderSpecificItems()
        
        let selectedItems = genderSpecificItems.filter { (item) -> Bool in
            if let isSelected =  item.isSelectedShoeRepairPreference, isSelected == true {
                return true
            }
            return false
        }
        
        return selectedItems
    }
    
    func getMaleItems() -> [ItemModel] {
        var maleItems:[ItemModel] = []
        if items.count > 0 {
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
        if items.count > 0 {
            for item in items {
                if item.genders == "female" {
                    femaleItems.append(item)
                }
            }
        }
        return femaleItems
    }
}





