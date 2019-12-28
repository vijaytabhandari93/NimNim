//
//  ProfileCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 17/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol ProfileCollectionViewCellDelegate:class{
func sendImage()// To tell the VC to send image post call ....///MARK: UIImagePickerControllerDelegate///upload image
////"image" key will be same..endpoint will remain same
////self?.serviceModel?.uploadedImages.append(imagePath) /// equal to
////usermodel save in user defaults////in services  case the images of special notes are sent via the add to cart api.////put call dede bhai......
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    
   ///imagetaaped // sendimage // through profile view controller picker will open
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmailAddress: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userPoints: UILabel!

    weak var delegate : ProfileCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func userImageTapped(_ sender: Any) {
        delegate?.sendImage()
    }
}
