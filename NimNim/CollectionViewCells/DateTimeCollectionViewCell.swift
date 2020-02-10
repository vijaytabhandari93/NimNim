//
//  DateTimeCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class DateTimeCollectionViewCell: UICollectionViewCell {
    
    var cartModel : CartModel?
    
    var  deliverySelections : Bool?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override func layoutSubviews() {
         super.layoutSubviews()
         self.layer.applySketchShadow(color: Colors.nimnimServicesShadowColor, alpha: 1, x: 12, y: 12, blur: 14, spread: 0)
     }
    func configureCell(forSelectedState State:Bool) {
        if State {
            dateLabel.backgroundColor = Colors.nimnimGreen
            dateLabel.textColor  = UIColor.white
            dateLabel.layer.borderWidth = 0
         
        }else {
            dateLabel.backgroundColor =  UIColor.white
            dateLabel.textColor  = Colors.nimnimLocationGrey
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.borderColor = Colors.nimnimBorderGrey.cgColor
            
        }
    }

}
