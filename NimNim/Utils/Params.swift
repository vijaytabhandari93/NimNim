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
}

