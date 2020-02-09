//
//  OrderReviewCardCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 27/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OrderReviewCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardHolderName: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var validTill: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
