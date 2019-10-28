//
//  SavedCardCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 17/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var arrowImageView:UIImageView!
    @IBOutlet weak var subTitleLabel:UILabel!
    @IBOutlet weak var bottomSeparator:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(withExpandedState isExpanded:Bool) {
        if isExpanded {
            arrowImageView.image = UIImage(named: "downArrow")
            bottomSeparator.isHidden = true
            subTitleLabel.isHidden = false
        }else {
            arrowImageView.image = UIImage(named: "rightArrow")
            bottomSeparator.isHidden = false
            subTitleLabel.isHidden = true
        }
    }
}
