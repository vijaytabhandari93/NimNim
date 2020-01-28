//
//  OrderNumberCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OrderNumberCollectionViewCell: UICollectionViewCell {
    
    var service : [ServiceModel]?
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func viewDetailsOfOrder(_ sender: Any) {
        let ordersStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let allServices = ordersStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController
        if let allServices  = allServices {
            allServices.service = service
        }
        
        NavigationManager.shared.push(viewController: allServices)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
