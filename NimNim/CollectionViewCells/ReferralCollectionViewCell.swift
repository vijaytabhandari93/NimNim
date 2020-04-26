//
//  ReferralCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 25/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol ReferralCollectionViewCellDelegate: class {
    func copyTapped(withCode code:String?)
    func inviteTapped(withCode code:String?)
}

class ReferralCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    weak var delegate:ReferralCollectionViewCellDelegate?
    
    @IBAction func copyTapped(_ sender: Any) {
    }
    
    @IBAction func inviteTapped(_ sender: Any) {
        delegate?.inviteTapped(withCode: codeLabel.text)
    }
    
}
