//
//  NoofClothesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NoofClothesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var separatorView: UIView!
    
    //MARK: Variables
    var counterType:String = "clothes"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func sliderValueChanged(_ sender: Any) {
        configureCounterLabel()
    }
    
    func configureCounterLabel() {
        let step: Float = 1
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        let intValue = Int(slider.value)
        countLabel.text = "\(intValue) \(counterType)"
    }
}
