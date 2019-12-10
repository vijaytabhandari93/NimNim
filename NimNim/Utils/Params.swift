//
//  Params.swift
//  NimNim
//
//  Created by Raghav Vij on 10/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

struct SignUpViaFormParams {
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let phone = "phone"
    static let password = "password"
    static let dob = "dob"
    static let email = "email"
}
struct LogInViaFormParams {
    static let password = "password"
    static let email = "email"
}

struct LogInViaOTP {
    static let mobile = "phone"
  
}
struct VerifyOTP {
    static let mobile = "phone"
    static let otp = "otp"
    
}
struct ForgotPassword {
    static let email = "email"
    }
struct SocialSignIn {
    static let userId = "accountId"
    static let typeOfSignIn = "type"
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let phone = "phone"
    static let password = "password"
    static let dob = "dob"
    static let email = "email"
}

struct AddCard {
    static let cardNumber = "number"
    static let year = "exp_year"
    static let cvv = "CVC"
    static let month = "exp_month"
    static let name  = "name"
}

struct AddAddress {
    static let streetAddress = "street"
    static let houseBlockNumber = "house"
    static let city = "city"
    static let state = "state"
    static let zipcode = "pincode"
    static let enterLandmark = "landmark"
    static let phoneNumber = "phone"
    static let label = "label"
    static let address = "address"
    static let id = "_id"
}

struct VerifyOTPSignIn {
    static let phone = "phone"
    static let otp = "otp"
    
}

struct AddToCart {
    static let services = "services"
    static let name = "name"
    static let alias = "alias"
    static let icon = "icon"
    static let description = "description"
    static let ordering = "ordering"
    static let detergents = "detergents"
    static let wash = "wash"
    static let drying = "drying"
    static let bleach = "bleach"
    static let softner = "softner"
    static let price = "price"
    static let pricing = "pricing"
    static let rushDeliveryOptions = "rush_delivery_options"
    static let needRushDelivery = "need_rush_delivery"
    static let pickupSlot = "pickup_slot"
    static let dropOffSlot = "dropoff_slot"
    static let specialNotes = "special_notes"
    static let uploadedImages = "uploaded_images"
}
