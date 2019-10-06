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
    func textFieldStartedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField)
    func textFieldEndedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField)
}


class LoginViaOTPTableViewCell: UITableViewCell, UITextFieldDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    //MARK: Constants and Variables
    weak var delegate:LoginViaOTPTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTextFieldDelegates()
    }
    
    func setupTextFieldDelegates() {
        mobileNumberTextField.delegate = self
        otpTextField.delegate = self
        mobileNumberTextField.inputAccessoryView = nil
        otpTextField.inputAccessoryView = nil
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
    
    //MARK: UITextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInLoginViaOTPTableViewCell(withTextField: textField)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInLoginViaOTPTableViewCell(withTextField: textField)
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
