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
    
    var model : ItemModel? //local
    
    enum SelectedGender { 
        case male
        case female
    }
    var currentGender:SelectedGender = .male
    
    @IBAction func minusTapped(_ sender:Any?) {
        if let number = (currentGender == .male) ? model?.maleCount : model?.femaleCount {
            if currentGender == .male {
                let newCount = number - 1
                if newCount >= 0 {
                    model?.maleCount = newCount
                    numberLabel.text = "\(String(describing: newCount))"
                }
            }else {
                let newCount = number - 1
                if newCount >= 0 {
                    model?.femaleCount = newCount
                    numberLabel.text = "\(String(describing: newCount))"
                }
            }
        }
    }
    @IBAction func plusTapped(_ sender:Any?) {
        if let number = (currentGender == .male) ? model?.maleCount : model?.femaleCount {
            if currentGender == .male {
                let newCount = number + 1
                if newCount < 100 {
                    model?.maleCount = newCount
                }
                numberLabel.text = "\(String(describing: newCount))"
            }else {
                let newCount = number + 1
                if newCount < 100 {
                    model?.femaleCount = newCount
                }
                numberLabel.text = "\(String(describing: newCount))"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewofStack.layer.borderWidth = 1
        viewofStack.layer.borderColor = Colors.nimnimButtonBorderGrey.cgColor
        
    }
    
    
    
}
