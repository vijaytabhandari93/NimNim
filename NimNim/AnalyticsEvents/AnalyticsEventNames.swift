//
//  AnalyticsEventNames.swift
//  NimNim
//
//  Created by Raghav Vij on 05/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation

struct AnalyticsEventNames {
    static let loginSuccess = "loginSuccess"
    static let loginFailure = "loginFailure"
    static let signupSuccess = "signupSuccess"
    static let signupFailure = "signupFailure"
    static let addedCardSuccess = "addedCardSuccess"
    static let addedCardFailure = "addedCardFailure"
    static let addedAddressSuccess = "addedAddressSuccess"
    static let addedAddressFailure = "addedAddressFailure"
    static let addedToCart = "addedToCart"
    static let apiFailure = "apiFailure"
    static let cartViewed = "cartViewed"
    static let promoApplied = "promoApplied"
    static let selectedAddress = "selectedAddress"
    static let selectedPickup = "selectedPickup"
    static let selectedDropOff = "selectedDropOff"
    static let selectedPayment = "selectedPayment"
    static let placedOrder = "placedOrder"
    static let orderSuccess = "orderSuccess"
    static let orderFailure = "orderFailure"
    static let orderDetailsViewed = "orderDetailsViewed"
    static let appLaunch = "appLaunch"
}

struct Events {
    static func fireAddedCardSuccess() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.addedCardSuccess, withProperties: nil)
    }
    static func appLaunched() {
         FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.appLaunch, withProperties: nil)
     }
    
    static func fireAddedCardFailure() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.addedCardFailure, withProperties: nil)
    }
    
    static func fireAddedAddressSuccess() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.addedAddressSuccess, withProperties: nil)
    }
    
    static func fireAddedAddressFailure() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.addedAddressFailure, withProperties: nil)
    }
    
    static func fireAddedToCart(withType type:String?) {
        guard let type = type else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"ecommerce",
            AnalyticsEventProperties.label:type
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.addedToCart, withProperties: props)
    }
    
    static func cartViewed() {
        let props:[String:String] = [
            AnalyticsEventProperties.category:"ecommerce"
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.cartViewed, withProperties: props)
    }
    
    static func promoApplied(withCoupon coupon:String?) {
        guard let type = coupon else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"ecommerce",
            AnalyticsEventProperties.label:type
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.promoApplied, withProperties: props)
    }
    
    static func selectedAddress() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.selectedAddress, withProperties: nil)
    }
    
    static func selectedPickup() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.selectedPickup, withProperties: nil)
    }
    
    static func selectedDropOff() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.selectedDropOff, withProperties: nil)
    }
    
    static func selectedPayment() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.selectedPayment, withProperties: nil)
    }
    
    static func placedOrder() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.placedOrder, withProperties: nil)
    }
    
    static func orderSuccess() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.orderSuccess, withProperties: nil)
    }
    
    static func orderFailure() {
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.orderFailure, withProperties: nil)
    }
    
    static func orderDetailsViewed(withOrderNumber orderNumber:String?) {
        guard let type = orderNumber else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"ecommerce",
            AnalyticsEventProperties.label:type
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.orderDetailsViewed, withProperties: props)
    }
}
