//
//  ServicesHeaderCollectionReusableView.swift
//  NimNim
//
//  Created by Raghav Vij on 03/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ServicesHeaderCollectionReusableView: UICollectionReusableView {

    //MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: IBActions
    @IBAction func viewAllTapped(_ sender: Any) {
        
    }
    
}
