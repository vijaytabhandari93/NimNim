//
//  AddShoeRepairCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol AddShoeRepairCollectionViewCellDelegate:class {
    func pushSecondViewController()
}
class AddShoeRepairCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    weak var delegate:AddShoeRepairCollectionViewCellDelegate?
    
    @IBAction func addShoeRepairTaskTapped(_ sender: Any) {
        delegate?.pushSecondViewController()
        
    }
}
