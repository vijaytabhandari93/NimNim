//
//  UserDefaultKeys.swift
//  NimNim
//
//  Created by Raghav Vij on 09/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    static let location = "kLocationModel"  //logOut
    static let User = "kUser"
    static let authToken = "kAuthToken"
    static let pickUpDropOfPreferences = "kPickUpDropOfPreferences"
    static let descriptionPreferences = "kDescriptionPreferences"
    static let services = "kservices"
    static let cartId = "kCartId"
    static let cartAlias = "kcartAlias" // Through this key , we will be saving the array of strings
    //(aliases) using UserDefaults
    static let cart = "kCart"
    static let walletBalance = "kwalletBalance"
    static let addressSelected = "kaddressSelected"
    static let dateSelected = "kDate"
    static let timeSlotSelected = "kTimeSlot"
    static let deliverydateSelected = "kdeliveryDate"
    static let deliverytimeSlotSelected = "kdeliveryTimeSlot"
}
