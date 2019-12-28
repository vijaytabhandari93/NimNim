//
//  ShoppingbagSummaryCollectionReusableView.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ShoppingbagSummaryCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var noOfItems: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let count = fetchNoOfServicesInCart()
        if count != 0 {
            noOfItems.text = "\(count) Items"
        }
        else {
            noOfItems.text = ""
        }
        
    }
}
