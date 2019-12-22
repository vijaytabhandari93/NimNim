//
//  Utils.swift
//  NimNim
//
//  Created by Raghav Vij on 15/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation

func addServiceToCartAliasinUserDefaults(withAlias alias : String?)
{
    if var alias = alias {
        if var aliasArray = UserDefaults.standard.object(forKey: UserDefaultKeys.cartAlias) as? [String] {
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
func fetchNoOfServicesInCart() -> Int {
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
