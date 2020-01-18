//
//  PricingHeaderCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 14/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class PricingHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var servicelabel: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var arrow: UIImageView!
    
    func configureCell(withExpandedState isExpanded:Bool) {
              if isExpanded {
                  arrow.image = UIImage(named: "downArrow")
                  bottomSeparator.isHidden = true
                }else {
                  arrow.image = UIImage(named: "rightArrow")
                  bottomSeparator.isHidden = false
                  }
}
    
    
}
