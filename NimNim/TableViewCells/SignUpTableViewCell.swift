//
//  SignUpTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol SignUpTableViewCellDelegate:class {
    func loginTappedInSignUpTableViewCell()
}

class SignUpTableViewCell: UITableViewCell {

    //MARK: Constants and Variables
    weak var delegate:SignUpTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:IBActions
    @IBAction func showTapped(_ sender: Any) {
    }
    @IBAction func signUpTapped(_ sender: Any) {
    }
    @IBAction func logInTapped(_ sender: Any) {
        delegate?.loginTappedInSignUpTableViewCell()
    }
}
