//
//  LocationcCell.swift
//  NimNim
//
//  Created by Raghav Vij on 24/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class LocationcCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationPincode: UILabel!
    @IBOutlet weak var selectedLocationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Constants and Variables
    let selectedStateFont = Fonts.semiBoldFont24
    let nonSelectedStateFont = Fonts.regularFont18
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupcell(forState:Bool){
        if forState{
            locationName.font = selectedStateFont
            locationPincode.font = selectedStateFont
            locationName.textColor = Colors.nimnimLocationDarkGrey
            locationPincode.textColor = Colors.nimnimLocationDarkGrey
            selectedLocationView.isHidden = false
            
        }
        else{
            locationName.font = nonSelectedStateFont
            locationPincode.font = nonSelectedStateFont
            locationName.textColor = Colors.nimnimLocationGrey
            locationPincode.textColor = Colors.nimnimLocationGrey
            selectedLocationView.isHidden = true
        }
    }
    
}

