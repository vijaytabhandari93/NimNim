//
//  WashAndFoldPreferencesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 04/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class WashAndFoldPreferencesCollectionViewCell: UICollectionViewCell {

    //IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    //IBActions
    @IBAction func leftButtonTapped(_ sender: Any) {
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
