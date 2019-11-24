//
//  NeedRushDeliveryCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 10/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NeedRushDeliveryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelAgainsCheckbox: UILabel!
    @IBOutlet weak var descriptionofLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var needRushDeliveryTapped: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tickButtonTapped(_ sender: Any) {
        if tickButton.currentImage != nil{
            tickButton.setImage(nil, for: .normal)
        }
        else{
            let image = UIImage(named: "path2")
            tickButton.setImage(image, for: .normal)
        }
    }
}

