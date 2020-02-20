//
//  HelpRequiredCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class HelpRequiredCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var issueHeading: UILabel!
    @IBOutlet weak var issueDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
           super.layoutSubviews()
           self.addTopShadowToView()
        self.addBottomShadowToView()
       }

}
