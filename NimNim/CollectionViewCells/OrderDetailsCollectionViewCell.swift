//
//  OrderDetailsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OrderDetailsCollectionViewCell: UICollectionViewCell {
    
    var model : ServiceModel?
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var noOfProducts: UILabel!
    @IBOutlet weak var amountPayable: UILabel!
    @IBOutlet weak var dropOffGTimeSlotDate: UILabel!
    @IBOutlet weak var serviceStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(withModel model : ServiceModel?)
        
    {    self.model = model
        if let serviceModel = model {
            serviceName.text = serviceModel.name
            let qty = serviceModel.productQuantity()
            if serviceModel.alias == "shoe-repair" {
                if qty == 1 {
                    noOfProducts.text = "\(String(describing: qty)) Shoe Repair Task"
                }else {
                    noOfProducts.text = "\(String(describing: qty)) Shoe Repair Tasks"
                }
            }
            else if serviceModel.alias == "tailoring" {
                if qty == 1 {
                    noOfProducts.text = "\(String(describing: qty)) Tailoring Task"
                }else {
                    noOfProducts.text = "\(String(describing: qty)) Tailoring Tasks"
                }
            }
            else if serviceModel.alias == "carpet-cleaning" {
                    if qty == 1 {
                        noOfProducts.text = "\(String(describing: qty)) Carpet"
                    }else {
                        noOfProducts.text = "\(String(describing: qty)) Carpets"
            }
                }
                else if serviceModel.alias == "laundered-shirts" {
                        if qty == 1 {
                            noOfProducts.text = "\(String(describing: qty)) Shirt"
                        }else {
                            noOfProducts.text = "\(String(describing: qty)) Shirts"
                }
                    }

                else if serviceModel.alias == "wash-and-fold" {
                        noOfProducts.text = "To be weighed"
                }

            else {
                if qty == 1 {
                    noOfProducts.text = "\(String(describing: qty)) Clothes"
                }else  {
                    noOfProducts.text = "\(String(describing: qty)) Clothes"
                }
            }
           
            
        }
    }
    

    @IBAction func viewServiceDetails(_ sender: Any) {
        //here there should  be no changing option.
    }
}
