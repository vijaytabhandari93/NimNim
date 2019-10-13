//
//  SpecialNotesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SpecialNotesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesTextBox: UITextView!
    override func awakeFromNib() {
        //border addition to be done
        super.awakeFromNib()
        // Initialization code
        notesTextBox.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
    }

}
