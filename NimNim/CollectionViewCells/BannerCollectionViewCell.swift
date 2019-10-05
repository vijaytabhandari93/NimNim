//
//  BannerCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 26/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBottomShadowToView()
    }
}
