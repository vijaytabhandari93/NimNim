//
//  SavedAddressCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedAddressCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var addAddressButton:UIButton!
    @IBOutlet weak var bottomSeparator:UIView!
    @IBOutlet weak var stackViewTopConstraint:NSLayoutConstraint!
    @IBAction func addNewCardTapped(_ sender: Any) {
        
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
        let addAddressVC = profileStoryBoard.instantiateViewController(withIdentifier: "AddAddressViewController")
        NavigationManager.shared.push(viewController: addAddressVC)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAddNewAddressButton()
    }

    func setupAddNewAddressButton() {
        addAddressButton.layer.cornerRadius = 10
        addAddressButton.layer.borderWidth = 1.5
        addAddressButton.layer.borderColor = Colors.nimnimButtonBorderGreen.cgColor
    }
    
  
    
}

