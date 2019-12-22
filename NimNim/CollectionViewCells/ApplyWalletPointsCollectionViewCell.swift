//
//  ApplyWalletPointsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol ApplyWalletPointsCollectionViewCellDelegate:class {
    func applyPointsTapped(tapped : Bool)
}
class ApplyWalletPointsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var apply: UIButton!
    
    var lastState : Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var delegate : ApplyWalletPointsCollectionViewCellDelegate?
    
    @IBAction func applyPointsTapped(_ sender:Any?) {
        lastState = !lastState
        delegate?.applyPointsTapped(tapped: lastState)
        if lastState {
            let image = UIImage(named: "path2")
            apply.setImage(image, for: .normal)
            apply.backgroundColor = Colors.nimnimGreen
            
        }
        else {
            apply.setImage(nil, for: .normal)
            apply.backgroundColor = Colors.nimnimGrey
        }
    }
}
