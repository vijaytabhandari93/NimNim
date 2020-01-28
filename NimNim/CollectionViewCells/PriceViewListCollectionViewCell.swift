//
//  PriceViewListCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 14/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class PriceViewListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    var screenType : String  = "Household Items"
    
    @IBAction func viewList(_ sender: Any) {
    
        if screenType == "Dry Cleaning"{
            let servicesStoryboard = UIStoryboard(name: "Pricing", bundle: nil)
            let allServices = servicesStoryboard.instantiateViewController(withIdentifier: "PriceListViewController") as! PriceListViewController
                NavigationManager.shared.push(viewController: allServices)
           
            }
        else
            
          {
            let servicesStoryboard = UIStoryboard(name: "Pricing", bundle: nil)
            let allServices = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsPriceViewController") as! HouseHoldItemsPriceViewController
                          NavigationManager.shared.push(viewController: allServices)
                
            
        }
            
    }
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
