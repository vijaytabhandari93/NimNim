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
}
struct VerifyOTPSignIn {
    static let phone = "phone"
    static let otp = "otp"
    
}

//"area": "area",not used
//"house": "house",
//"landmark": "landmark",
//"pincode": "110014",
//"street": "12",
//"city": "delhi",
//"state": "delhi",
//"phone": "9874563210",
//"lat": "23.05", not used
//"long": "50.23"  not used
//
