//
//  NeedRushDeliveryCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 10/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol NeedRushDeliveryCollectionViewCellDelegate:class {
    func rushDeliveryTapped()
}

class NeedRushDeliveryCollectionViewCell: UICollectionViewCell {

    var hours : String?
    var extraPrice : Int?
    
    @IBOutlet weak var labelAgainsCheckbox: UILabel!
    @IBOutlet weak var descriptionofLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var needRushDeliveryTapped: UIButton!
    
    weak var delegate:NeedRushDeliveryCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBAction func tickButtonTapped(_ sender: Any) {
        delegate?.rushDeliveryTapped()
    }
    
    func configureUI(forRushDeliveryState rushDeliveryState:Bool) {
        if rushDeliveryState {
            let image = UIImage(named: "path2")
            tickButton.setImage(image, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGreen
        }else {
            tickButton.setImage(nil, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGrey
        }
    }
}

