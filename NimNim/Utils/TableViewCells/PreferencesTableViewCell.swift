//
//  PreferencesTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 14/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedStateView: UIView!
    
    //MARK: Constants and Variables
    let selectedStateFont = Fonts.extraBold36
    let nonSelectedStateFont = Fonts.regularFont18
    
    override func
    awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupCell(forState isSelected:Bool) {
        if isSelected {
           selectedStateView.isHidden = false
           titleLabel.font = selectedStateFont
        }else {
           selectedStateView.isHidden = true
           titleLabel.font = nonSelectedStateFont
        }
    }
}
