//
//  TrackOrderCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 18/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class TrackOrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var bottomview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(withTitle title:String?, withSubTitle subTitle:String?, withStatusImage image:String?) {
        if let title = title, title.count > 0 {
            titleLabel.text = title
        }else {
            if let subTitle = subTitle, subTitle.caseInsensitiveCompare("completed") == .orderedSame {
                titleLabel.text = "Order Completed"
            }
        }
        if let subTitle = subTitle {
            subTitleLabel.text = subTitle
        }
        if let image = image {
            
            if let subTitle = subTitle, subTitle.caseInsensitiveCompare("completed") == .orderedSame {
                statusImageView.image = UIImage(named: "done")
            }else {
                statusImageView.image = UIImage(named: image)
            }
        }
        topview.addDashedBorder()
        bottomview.addDashedBorder()
    }

}
