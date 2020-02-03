//
//  ShoeRepairCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol ShoeRepairCollectionViewCellDelegate:class {
    func preferenceSelected(withIndexPath indexPath : IndexPath?)
}

class ShoeRepairCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    var IndexPath  : IndexPath?
    @IBAction func tickbuttonTapped(_ sender: Any) {
        
        delegate?.preferenceSelected(withIndexPath : self.IndexPath)
        
    }
    weak var delegate:ShoeRepairCollectionViewCellDelegate?
    
    
    func configureUI(forPreferenceSelectedState state:Bool, forIndex IndexPath : IndexPath)
    {
        self.IndexPath = IndexPath
        if state {
            let image = UIImage(named: "path2")
            tickButton.setImage(image, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGreen
        }else {
            let image = UIImage(named: "rectangleCopy")
            tickButton.setImage(image, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGrey
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
