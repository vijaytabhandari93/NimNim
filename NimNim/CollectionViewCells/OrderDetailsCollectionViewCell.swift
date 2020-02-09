//
//  OrderDetailsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OrderDetailsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var noOfProducts: UILabel!
    @IBOutlet weak var amountPayable: UILabel!
    @IBOutlet weak var dropOffGTimeSlotDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func viewServiceDetails(_ sender: Any) {
        //here there should  be no changing option.
    }
}
