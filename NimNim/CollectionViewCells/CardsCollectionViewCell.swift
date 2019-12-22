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
}


class CardsCollectionViewCell: UICollectionViewCell {
    var cardId : String = ""
    
    weak var delegate :CardsCollectionViewCellDelegate?
    
    
    @IBOutlet weak var cardNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteTapped(_ sender: Any) {
        delegate?.deleteCardTapped(withId : cardId)
    }
}
