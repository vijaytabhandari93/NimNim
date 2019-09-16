//
//  LoginWithPasswordTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol LoginWithPasswordTableViewCellDelegate:class {
    func signUpTappedInLoginWithPasswordTableViewCell()
    func logInViaOtpTappedInLoginWithPasswordTableViewCell()
}

class LoginWithPasswordTableViewCell: UITableViewCell {

    //MARK: Constants and Variables
    weak var delegate :LoginWithPasswordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: IBActions
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInLoginWithPasswordTableViewCell()
    }
    @IBAction func logInTapped(_ sender: Any) {
        //actual login
        
    }
    @IBAction func logInViaOtpTapped(_ sender: Any) {
        delegate?.logInViaOtpTappedInLoginWithPasswordTableViewCell()
    }
}
