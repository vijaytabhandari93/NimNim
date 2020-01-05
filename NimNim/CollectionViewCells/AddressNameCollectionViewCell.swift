//
//  AddressNameCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol AddressNameCollectionViewCellDelegate:class {
    func addressSelectedChangeUI(withIndexPath indexPath : IndexPath?)
}
class AddressNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tick: UIButton!
    var addressModel : AddressDetailsModel?
    var IndexPath  : IndexPath?
    var cartModel : CartModel?
     weak var delegate:AddressNameCollectionViewCellDelegate?
    
    @IBAction func tickTapped(_ sender: Any) {
        delegate?.addressSelectedChangeUI(withIndexPath : self.IndexPath)
        let savedAddress = addressModel?.id
        UserDefaults.standard.set(savedAddress,forKey: UserDefaultKeys.addressSelected)
        cartModel?.addressId =  addressModel?.id
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureUI(forSelected selected:Bool, forIndex IndexPath : IndexPath) {
        self.IndexPath = IndexPath
        if selected {
            let image = UIImage(named: "path2")
            tick.setImage(image, for: .normal)
            tick.backgroundColor = Colors.nimnimGreen
        }else {
            tick.setImage(nil, for: .normal)
            tick.backgroundColor = Colors.nimnimGrey
        }
    }
    
    
    
}
