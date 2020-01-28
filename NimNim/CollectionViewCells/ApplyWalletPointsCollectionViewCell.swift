//
//  ApplyWalletPointsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol ApplyWalletPointsCollectionViewCellDelegate:class {
    func applyPointsTapped(tapped : Bool)
}
class ApplyWalletPointsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var apply: UIButton!
    var pointsinWallet  : Int = 0
    var lastState : Bool = true
    var cartModel:CartModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var delegate : ApplyWalletPointsCollectionViewCellDelegate?
    
    func configureCell(withCartModel cartModel:CartModel?) {
        self.cartModel = cartModel
        if  pointsinWallet == 0 {
            setupUIforNonselectablestate()
            setupUI(forState: false)
        }
        else {
            setupUI(forState: cartModel?.isWalletSelected)
          }
       
    }
    
    @IBAction func applyPointsTapped(_ sender:Any?) {
        if let isSelected = self.cartModel?.isWalletSelected {
            self.cartModel?.isWalletSelected = !isSelected
        }
        setupUI(forState: self.cartModel?.isWalletSelected)
    }
    
    func setupUI(forState state:Bool?) {
        if let state = state, state == true {
            let image = UIImage(named: "path2")
            apply.setImage(image, for: .normal)
            apply.backgroundColor = Colors.nimnimGreen
        }else {
            let image = UIImage(named: "rectangleCopy")
            apply.setImage(image, for: .normal)
            apply.backgroundColor = Colors.nimnimGrey
        }
    }
    func setupUIforNonselectablestate(){
        apply.isEnabled = false
    }
}
