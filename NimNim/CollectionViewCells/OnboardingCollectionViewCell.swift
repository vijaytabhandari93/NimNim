//
//  OnboardingCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 26/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(withImage image:String?, withTitle title:String?) {
        if let title = title, title.count > 0 {
            titleLabel.text = title
        }
        
        if let image = image, image.count > 0 {
            imageView.image = UIImage(named: image)
        }
    }
}
