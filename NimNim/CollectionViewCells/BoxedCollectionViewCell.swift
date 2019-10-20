//
//  BoxedCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class BoxedCollectionViewCell: UICollectionViewCell {

    @IBAction func rightButtonPressed(_ sender: Any) {
    }
    @IBAction func leftButtonpressed(_ sender: Any) {
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
