//
//  SavedAddressCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedAddressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editAddressTapped(_ sender: Any) {
    }
    
    @IBAction func addNewCardTapped(_ sender: Any) {
        
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
       let addAddressVC = profileStoryBoard.instantiateViewController(withIdentifier: "AddAddressViewController")
        NavigationManager.shared.push(viewController: addAddressVC)
    }
    
}

