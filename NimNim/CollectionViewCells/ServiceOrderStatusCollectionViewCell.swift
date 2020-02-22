//
//  ServiceOrderStatusCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
protocol ServiceOrderStatusCollectionViewCellDelegate:class {
    
    func orderDetails(withServiceModel model:ServiceModel?) //delegate function will be called which will return the serviceModel back to the order review view controller. based on the alias we will open the vc and pass service model to the vc
    func removeItem(withServiceModel model:ServiceModel?)
}

class ServiceOrderStatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var dropOOffTime: UILabel!
    @IBOutlet weak var removeTapped: UIButton!
    @IBOutlet weak var viewOrderDetails: UIButton!
    @IBOutlet weak var chaneTapped: UIButton!
    
    weak var delegate :ServiceOrderStatusCollectionViewCellDelegate?
    var model : ServiceModel?
    
    func configureCell(withModel model : ServiceModel?)
    {    self.model = model
        if let serviceModel = model {
            serviceName.text = serviceModel.name
            let qty = serviceModel.productQuantity()
            if serviceModel.alias == "shoe-repair" {
                if qty == 1 {
                    productQty.text = "\(String(describing: qty)) Shoe Repair Task"
                }else if qty == 0 {
                    productQty.text = "Tasks to be counted"
                }else {
                    productQty.text = "\(String(describing: qty)) Shoe Repair Tasks"
                }
            }
            else if serviceModel.alias == "tailoring" {
                if qty == 1 {
                    productQty.text = "\(String(describing: qty)) Tailoring Task"
                }else if qty == 0 {
                    productQty.text = "Tasks to be counted"
                }else {
                    productQty.text = "\(String(describing: qty)) Tailoring Tasks"
                }
            }
            else if serviceModel.alias == "carpet-cleaning" {
                if qty == 1 {
                    productQty.text = "\(String(describing: qty)) Carpet"
                }else if qty == 0 {
                    productQty.text = "Rugs to be counted"
                }
                else {
                    productQty.text = "\(String(describing: qty)) Carpets"
                }
            }
            else if serviceModel.alias == "laundered-shirts" {
                if qty == 1 {
                    productQty.text = "\(String(describing: qty)) Shirt"
                } else if qty == 0 {
                    productQty.text = "Shirts to be counted"
                }
                else {
                    productQty.text = "\(String(describing: qty)) Shirts"
                }
            }
                
            else if serviceModel.alias == "wash-and-fold" {
                productQty.text = "Clothes to be weighed"
            }
            else if serviceModel.alias == "wash-and-air-dry" {
                productQty.text = "Clothes to be weighed"
            }
            else {
                if qty == 1 {
                    productQty.text = "\(String(describing: qty)) Cloth"
                    
                }else if qty == 0 {
                    productQty.text = "Clothes to be counted"
                }
                else  {
                    productQty.text = "\(String(describing: qty)) Clothes"
                }
            }
            amount.text = serviceModel.servicePrice
            
        }
    }
    
    @IBAction func changeDidTapped(_ sender: Any) {
        //same as below .....only scrolll to time should be added
        
    }
    @IBAction func removeDidTapped(_ sender: Any) {
        delegate?.removeItem(withServiceModel :model)
        
    }
    @IBAction func viewOrderDetailsDidTapped(_ sender: Any) {
        delegate?.orderDetails(withServiceModel :model)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
