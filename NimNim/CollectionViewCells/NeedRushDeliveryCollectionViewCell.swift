//
//  NeedRushDeliveryCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 10/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol NeedRushDeliveryCollectionViewCellDelegate:class {
    func rushDeliveryTapped(withIndexPath indexPath : IndexPath?)
}

class NeedRushDeliveryCollectionViewCell: UICollectionViewCell {

    var hours : String?
    var extraPrice : Int?
    var IndexPath  : IndexPath?
    
    @IBOutlet weak var labelAgainsCheckbox: UILabel!
    @IBOutlet weak var descriptionofLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    
    weak var delegate:NeedRushDeliveryCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBAction func tickButtonTapped(_ sender: Any) {
        delegate?.rushDeliveryTapped(withIndexPath : self.IndexPath)
        
    }
    
    func configureUI(forRushDeliveryState rushDeliveryState:Bool, forIndex IndexPath : IndexPath) {
        self.IndexPath = IndexPath
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
//At the moment the cell is made, with the help of configureUI the indexPath of the cell is given. This index Path is saved in the global variable. The global variable is later used to send the index path value to Rush delivery tapped.
