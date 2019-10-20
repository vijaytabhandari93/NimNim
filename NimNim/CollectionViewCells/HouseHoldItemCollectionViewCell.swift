//
//  HouseHoldItemCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class HouseHoldItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var laundryRate: UILabel!
    @IBOutlet weak var DryCleaningButton: UIButton!
    @IBOutlet weak var laundryButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dryCleaningRate: UILabel!
    
    
    @IBAction func ifLaundered(_ sender: Any) {
    }
    
    @IBAction func ifDryCleaned(_ sender: Any) {
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
