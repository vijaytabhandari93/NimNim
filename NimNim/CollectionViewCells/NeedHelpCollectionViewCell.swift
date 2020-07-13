//
//  NeedHelpCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol NeedHelpCollectionViewCellDelegate:class {
    func helpCellTapped(withType type:String)
}

class NeedHelpCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    weak var delegate:NeedHelpCollectionViewCellDelegate?
    var Issueheadings = ["Payment","Delivery","Service Issue","Offers/Discounts","Cancellation"]
    var IssueDescriptionHeading = ["Payment is done wrongly","My order has not been delivered yet","I’m not happy with the service","My discount wasn’t applied","Do you want to cancel this order?"]
    var orderModel:OrderModel?
    @IBOutlet weak var helpCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
        helpCollectionView.delegate = self
        helpCollectionView.dataSource = self
    }
    
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "HelpRequiredCollectionViewCell", bundle: nil)
        helpCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "HelpRequiredCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let isCancellable = orderModel?.isCancellable, isCancellable == true {
            return 5
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HelpRequiredCollectionViewCell", for: indexPath) as! HelpRequiredCollectionViewCell
        cell.issueHeading.text = Issueheadings[indexPath.item]
        cell.issueDescription.text = IssueDescriptionHeading[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 214, height: 98)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = Issueheadings[indexPath.item]
        delegate?.helpCellTapped(withType: type)
    }
//here type is referring to the issue number(indexPath.item).
}



