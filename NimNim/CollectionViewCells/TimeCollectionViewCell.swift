//
//  TimeCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
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
            timeLabel.backgroundColor = Colors.nimnimGreen
            timeLabel.textColor  = UIColor.white
            timeLabel.layer.borderWidth = 0
            
        }else {
            timeLabel.backgroundColor =  UIColor.white
            timeLabel.textColor  = Colors.nimnimLocationGrey
            timeLabel.layer.borderWidth = 1
            timeLabel.layer.borderColor = Colors.nimnimBorderGrey.cgColor
            
        }
    }
}
