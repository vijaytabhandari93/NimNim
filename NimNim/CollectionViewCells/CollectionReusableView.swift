//
//  CollectionReusableView.swift
//  NimNim
//
//  Created by Raghav Vij on 27/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var noOfItems: UILabel!
    @IBOutlet weak var pickUpDateAndTime: UILabel!
    @IBOutlet weak var orderCreatedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
