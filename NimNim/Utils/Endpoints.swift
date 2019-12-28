//
//  Endpoints.swift
//  NimNim
//
//  Created by Raghav Vij on 05/11/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

struct Endpoints {
    static let serviceableLocations = "admin/serviceable_regions" //static keyword is used for allowing us to use these variables directly by using dot operator with the class name. These are not instance variables. This means we need not initialize the Endpoints object to use them. These are like class variables.
    static let customers = "customer/customers"
    static let customersLoginWithPassword = "customer/login"
    static let customersLoginWithOTP = "sendotp"
    static let socialLogin = "sociallogin"
    static let verifyOTP = "verifyotp"
    static let resendOTP = "resendotp"
    static let forgotPasssword = "forgotpassword"
    static let socialSignUp = "socialsignup"  // need to undeerstand
    static let banners = "admin/banner"
    static let services = "admin/services"
    static let fetchwalletbalance = "fetchwalletbalance"
    static let promocodes = "promocodes"
    static let applypromocode = "applypromocode"
    static let addCard = "addcard"
    static let addAddress = "customer/address"
    static let getallcard = "getallcard"
    static let deletecard = "deletecard"
    static let getallAddrress = "customer/fetchalladdress"
    static let checkotp = "verifyotp"
    static let uploadImage = "singleimage"
    static let addToCart = "addtocart"
    static let updateCart = "updatecart"
    static let fetchCart = "carts"
    static let removeItemFromCart = "removeitemfromcart"
    static let customerFromCart = "customer/customers"
}

