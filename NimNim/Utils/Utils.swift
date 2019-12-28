//
//  Utils.swift
//  NimNim
//
//  Created by Raghav Vij on 15/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

var model : CartModel?

func addServiceToCartAliasinUserDefaults(withAlias alias : String?) // written in all services screen and called wheneever add to cart or update cart is called.
{
    if let alias = alias {
        if var aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {  // alias array is an array of string ....ie ["wash and fold","waash and air Dry" etc]
            if !aliasArray.contains(alias)
            {
                aliasArray.append(alias)
                UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
            }
        }
        else
        {
            let aliasArray = [alias]
            UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
        }
    }
}

func removeServiceFromCartAliasInUserDefault(withAlias alias:String?) {
    if let alias = alias {
        if var aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {  // alias array is an array of string ....ie ["wash and fold","waash and air Dry" etc]
            if aliasArray.contains(alias)
            {
                //This function will loop over all the values inside the alias array... and the closure will be called for every value(aliasValue parameter of the closure) inside the array... all those values will be removed from the aliasArray for which the closure will return true... this means in our case all the values that match the service alias inside the array will be removed...
                aliasArray.removeAll { (aliasValue) -> Bool in
                    return aliasValue == alias
                }
                UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
            }
        }
        else
        {
            let aliasArray = [alias]
            UserDefaults.standard.set(aliasArray, forKey: UserDefaultKeys.cartAlias)
        }
    }
}

func fetchNoOfServicesInCart() -> Int { //// written in cart icon updation.
    if let array =  UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {
        return array.count
    }
    return 0
}

func checkIfInCart(withAlias alias : String) -> Bool
{
    if let aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {
        if aliasArray.contains(alias)
        {
            return true
        }
        else
        {
            return false
        }
    }
    return false
}
