//
//  SelectFromListOfClothesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SelectFromListOfClothesCollectionViewCell: UICollectionViewCell {

override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func selectTapped(_ sender: Any) {
    
        
        
        let servicesSB = UIStoryboard(name:"Services", bundle: nil)
        let selectItemVC = servicesSB.instantiateViewController(withIdentifier: "AllItemsViewController") as! AllItemsViewController
        NavigationManager.shared.push(viewController:selectItemVC)
        
}

}
