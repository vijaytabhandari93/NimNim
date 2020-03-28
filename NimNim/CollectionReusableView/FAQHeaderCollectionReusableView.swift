//
//  FAQHeaderCollectionReusableView.swift
//  NimNim
//
//  Created by Raghav Vij on 28/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol FAQHeaderCollectionReusableViewDelegate:class {
    func headerTapped(atIndexPath indexPath:IndexPath?)
}

class FAQHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var bottomArrow: UIImageView!
    
    var indexPath:IndexPath?
    weak  var delegate:FAQHeaderCollectionReusableViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func headerTapped(_ sender: Any) {
        delegate?.headerTapped(atIndexPath: indexPath)
    }
}
