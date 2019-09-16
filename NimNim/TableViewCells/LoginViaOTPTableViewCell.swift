//
//  LoginViaOTPTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol LoginViaOTPTableViewCellDelegate:class {
    func logInViaPasswordTappedInLoginViaOTPTableViewCell()
    func signUpTappedInLoginViaOTPTableViewCell()
}


class LoginViaOTPTableViewCell: UITableViewCell {
    
    //MARK: Constants and Variables
    weak var delegate:LoginViaOTPTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:IBActions
    @IBAction func logInViaPasswordTapped(_ sender: Any) {
        delegate?.logInViaPasswordTappedInLoginViaOTPTableViewCell()
    }
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInLoginViaOTPTableViewCell()
    }
    @IBAction func resendOtpTapped(_ sender: Any) {
    }
    @IBAction func getOtptapped(_ sender: Any) {
    }
}
