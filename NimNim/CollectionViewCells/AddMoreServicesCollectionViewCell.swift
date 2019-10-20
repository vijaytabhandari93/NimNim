//
//  AddMoreServicesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 10/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddMoreServicesCollectionViewCell: UICollectionViewCell {
    
    @IBAction func addMoreServicesTapped(_ sender: Any) {
        let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"AllServicesViewController") as? AllServicesViewController
        NavigationManager.shared.push(viewController: secondViewController)
        
    }
    
    
    @IBOutlet weak var addMoreServicesTapped: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
