//
//  SelectItemCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 21/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SelectItemCollectionViewCell: UICollectionViewCell {

@IBOutlet weak var selectedImage : UIImageView!
@IBOutlet weak var selectedLabel : UILabel!
@IBOutlet weak var numberLabel : UILabel!
@IBOutlet weak var stack : UIStackView!
@IBOutlet weak var viewofStack : UIView!
@IBAction func minusTapped(_ sender:Any?) {
    
    }
@IBAction func plusTapped(_ sender:Any?) {
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewofStack.layer.borderWidth = 1
        viewofStack.layer.borderColor = Colors.nimnimButtonBorderGrey.cgColor
    
        
    }



}
