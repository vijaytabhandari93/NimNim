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
    
    let dateFormatter = DateFormatter()
    let displayDF = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        displayDF.dateFormat = "dd MMM YYYY"
    }
    
    func configure(model: CouponModel)
    {
        if let discountValue = model.discount {
            discount.text = "$\(discountValue) OFF"
        }
        code.text = model.codeName
        if let validUpto = model.validto {
            if let date = dateFormatter.date(from: validUpto) {
                let dateString = displayDF.string(from: date)
                id.text = "Valid upto: \(dateString)"
            }
        }
    }
}
