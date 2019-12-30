//
//  CardsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit


protocol CardsCollectionViewCellDelegate:class {
    func deleteCardTapped(withId id : String?)
    func selectedTapped(withIndexPath indexPath : IndexPath?)
}


class CardsCollectionViewCell: UICollectionViewCell {
    var cardId : String = ""
    var IndexPath  : IndexPath?
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var Delete: UIButton!
    weak var delegate :CardsCollectionViewCellDelegate?
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var cardNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteTapped(_ sender: Any) {
       
        delegate?.deleteCardTapped(withId : cardId)
    }
    
    @IBAction func tickButtonTapped(_ sender: Any) {
        delegate?.selectedTapped(withIndexPath: IndexPath)
        
    }
    func configureUI(forRushDeliveryState rushDeliveryState:Bool, forIndex IndexPath : IndexPath) {
        self.IndexPath = IndexPath
        if rushDeliveryState {
            let image = UIImage(named: "path2")
            tickButton.setImage(image, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGreen
        }else {
            tickButton.setImage(nil, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGrey
        }
    }
}
