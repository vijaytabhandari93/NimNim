//
//  Klayio.swift
//  NimNim
//
//  Created by Raghav Vij on 13/06/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import KlaviyoSwift

    let klaviyo = Klaviyo.sharedInstance
    let customerDictionary : NSMutableDictionary = NSMutableDictionary()
    customerDictionary[klaviyo.KLPersonEmailDictKey] = "john.smith@example.com"
    customerDictionary[klaviyo.KLPersonFirstNameDictKey] = "John"
    customerDictionary[klaviyo.KLPersonLastNameDictKey] = "Smith"
    let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
    propertiesDictionary["Total Price"] = 10.99
    propertiesDictionary["Items Purchased"] = ["Milk","Cheese", "Yogurt"]
    Klaviyo.sharedInstance.trackEvent(
        eventName: "Completed Checkout",
        customerProperties: customerDictionary,
        properties: propertiesDictionary )

