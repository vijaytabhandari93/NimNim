//
//  OrderNumberCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OrderNumberCollectionViewCell: UICollectionViewCell {
    
    
    var cardId : String?
    var address : String?
    var price:String?
    var service : [ServiceModel]?
    var orderModel:OrderModel?
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func viewDetailsOfOrder(_ sender: Any) {
        let ordersStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let allServices = ordersStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController
        if let allServices  = allServices {
            allServices.service = service
            allServices.date  = date.text
            allServices.address  = address
            allServices.cardId = cardId
            allServices.orderModel = orderModel
            
        }
        NavigationManager.shared.push(viewController: allServices)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
