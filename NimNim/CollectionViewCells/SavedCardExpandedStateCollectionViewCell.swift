//
//  SavedCardExpandedStateCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedCardExpandedStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var missingElement: UIImageView!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var missingDescription: UILabel!
    @IBOutlet weak var bottomSeparator:UIView!
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    @IBOutlet weak var addButtonTapped: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
