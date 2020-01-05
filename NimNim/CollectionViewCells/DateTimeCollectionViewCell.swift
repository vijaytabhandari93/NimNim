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
