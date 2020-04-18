//
//  CollectionReusableView.swift
//  NimNim
//
//  Created by Raghav Vij on 27/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol CollectionReusableViewDelegate:class {
    func trackOrderTapped()
}

class CollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var trackOrderButton:UIButton!
    @IBOutlet weak var noOfItems: UILabel!
    @IBOutlet weak var pickUpDateAndTime: UILabel!
    @IBOutlet weak var orderCreatedDate: UILabel!
    weak var delegate:CollectionReusableViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func trackOrderTapped(_ sender: Any) {
        delegate?.trackOrderTapped()
    }
}
