//
//  WalletTransactionCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 10/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class WalletTransactionCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var orderNumber: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var transactionType: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
