//
//  Fonts.swift
//  NimNim
//
//  Created by Raghav Vij on 15/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import UIKit

struct FontNames {
    static let montserratRegular = "Montserrat-Regular"
    static let montserratMedium = "Montserrat-Medium"
    static let montserratSemiBold = "Montserrat-SemiBold"
    static let montserratExtraBold = "Montserrat-ExtraBold"
}

struct Fonts {
    static let regularFont14 = UIFont(name: FontNames.montserratRegular, size: 14)!
    static let regularFont12 = UIFont(name: FontNames.montserratRegular, size: 12)!
    static let regularFont24 = UIFont(name: FontNames.montserratRegular, size: 24)!
    static let semiBoldFont24 = UIFont(name: FontNames.montserratSemiBold, size: 24)!
    static let regularFont18 = UIFont(name: FontNames.montserratRegular, size: 18)!
    static let extraBold36 = UIFont(name: FontNames.montserratExtraBold, size: 36)!
    static let semiBold16 = UIFont(name: FontNames.montserratSemiBold, size: 16)
}
