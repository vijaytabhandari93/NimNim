//
//  SelectFromListOfClothesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SelectFromListOfClothesCollectionViewCell: UICollectionViewCell {
    
    var serviceModel:ServiceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func selectTapped(_ sender: Any) {
        let servicesSB = UIStoryboard(name:"Services", bundle: nil)
        let selectItemVC = servicesSB.instantiateViewController(withIdentifier: "AllItemsViewController") as! AllItemsViewController
        if let serviceModel = serviceModel {
            let maleItems = serviceModel.getMaleItems()
            let femaleItems = serviceModel.getFemaleItems()
            selectItemVC.maleItems = maleItems
            selectItemVC.femaleItems = femaleItems
        }
        selectItemVC.modelOfServices = serviceModel
        NavigationManager.shared.push(viewController:selectItemVC)
        
    }
    
}
