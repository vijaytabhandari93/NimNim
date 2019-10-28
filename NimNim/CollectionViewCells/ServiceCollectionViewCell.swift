//
//  ServiceCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 03/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var backgroundCurvedView: UIView!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBAction func selectTapped(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.applySketchShadow(color: Colors.nimnimServicesShadowColor, alpha: 1, x: 12, y: 12, blur: 14, spread: 0)
    }
    
    func configureCell(withTitle title:String?) {
        serviceName.text = title
    }

}
