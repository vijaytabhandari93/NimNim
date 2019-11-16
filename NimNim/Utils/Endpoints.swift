//
//  Endpoints.swift
//  NimNim
//
//  Created by Raghav Vij on 05/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

struct Endpoints {
    static let serviceableLocations = "admin/serviceable_regions"
    static let customers = "customer/customers"
    static let customersLoginWithPassword = "customer/login"
    static let customersLoginWithOTP = "sendotp"
    static let verifyOTP = "verfiyotp"
    static let resendOTP = "resendotp"
    static let forgotPasssword = "forgotpassword"
    static let socialSignUp = "socialsignup"
}
