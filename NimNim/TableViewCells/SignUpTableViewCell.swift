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
    func signUpTappedInSignUpTableViewCell()
}

class SignUpTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    //MARK: Constants and Variables
    weak var delegate:SignUpTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTextFieldDelegates()
    }
    
    func setupTextFieldDelegates() {
        emailAddressTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        dobTextField.delegate = self
        emailAddressTextField.inputAccessoryView = nil
        firstNameTextField.inputAccessoryView = nil
        lastNameTextField.inputAccessoryView = nil
        phoneNumberTextField.inputAccessoryView = nil
        passwordTextField.inputAccessoryView = nil
        dobTextField.inputAccessoryView = nil
    }

    //MARK:IBActions
    @IBAction func showTapped(_ sender: Any) {
    }
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInSignUpTableViewCell()
    }
    @IBAction func logInTapped(_ sender: Any) {
        delegate?.loginTappedInSignUpTableViewCell()
    }
}

extension SignUpTableViewCell:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
