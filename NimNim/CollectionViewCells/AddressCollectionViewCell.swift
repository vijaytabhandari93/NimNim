//
//  AddressCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 20/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var subTitleLabel:UILabel!
    var addressModel : AddressDetailsModel?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func editTapped(_ sender:Any?) {
        let addressSB = UIStoryboard(name:"Profile", bundle: nil)
        let orderReviewVC = addressSB.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController
        orderReviewVC?.editTapped = true // passing info further
        orderReviewVC?.model = addressModel // passing info further
        NavigationManager.shared.push(viewController: orderReviewVC)
        
        
    }

}
