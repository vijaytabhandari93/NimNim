//
//  AddTailoringRepairCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 07/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//


import UIKit

protocol AddTailoringRepairCollectionViewCellDelegate:class {
    func pushSecondViewController()
}
class AddTailoringRepairCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    weak var delegate:AddTailoringRepairCollectionViewCellDelegate?
    
    @IBAction func addShoeRepairTaskTapped(_ sender: Any) {
        delegate?.pushSecondViewController()
        
    }
}
