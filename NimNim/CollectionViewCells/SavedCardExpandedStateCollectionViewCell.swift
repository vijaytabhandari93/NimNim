//
//  SavedCardExpandedStateCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedCardExpandedStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var missingElement: UIImageView!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var missingDescription: UILabel!
    @IBOutlet weak var bottomSeparator:UIView!
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupAddNewCardButton()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let addNewCardVC = profileStoryboard.instantiateViewController(withIdentifier: "AddNewCardViewController")
        NavigationManager.shared.push(viewController: addNewCardVC)
    }
    
    func setupAddNewCardButton() {
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 1.5
        addButton.layer.borderColor = Colors.nimnimButtonBorderGreen.cgColor
    }

}
