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
    func textFieldStartedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField)
    func textFieldEndedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField)
}

class LoginWithPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Constants and Variables
    weak var delegate :LoginWithPasswordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTextFieldDelegates()
    }
    
    func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.inputAccessoryView = nil
        passwordTextField.inputAccessoryView = nil
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
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInLoginViaPasswordTableViewCell(withTextField: textField)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInLoginViaPasswordTableViewCell(withTextField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count > 0 {
                textField.font = Fonts.medium20
            }else {
                textField.font = Fonts.regularFont14
            }
        }
        return true
    }
}
