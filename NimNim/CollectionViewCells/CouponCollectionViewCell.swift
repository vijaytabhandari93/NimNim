//
//  CouponCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 23/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: CouponModel)
    {
        if let discountValue = model.discount {
            discount.text = "\(discountValue)"
        }
        code.text = model.code
        id.text = model.id
    }
}
