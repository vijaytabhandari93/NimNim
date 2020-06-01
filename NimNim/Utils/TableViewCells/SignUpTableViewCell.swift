//
//  SignUpTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 09/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol SignUpTableViewCellDelegate:class {
    func loginTappedInSignUpTableViewCell() //already have an account wala...
    func signUpTappedInSignUpTableViewCell(withEmail email:String?, withFirstName firstName:String?,  withLastName lastName:String?, withPhoneNumber phoneNumber:String?, withPassword password:String?, withDob dob:String?) // main sign up tapped
    
    func verifyTappedInSignUpTableViewCell(withPhoneNumber phoneNumber:String?) // main sign up tapped
    func textFieldStartedEditingInSignUpTableViewCell(withTextField textField:UITextField) // to give keeeboard space
    func textFieldEndedEditingInSignUpTableViewCell(withTextField textField:UITextField) // to give keyboard space
}

class SignUpTableViewCell: UITableViewCell,UITextFieldDelegate {

    //MARK: IBOutlets
    
    var checkedStatus : String?

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var showPaswordButton: UIButton!
    
    //MARK: Constants and Variables
    weak var delegate:SignUpTableViewCellDelegate?
    var indexPath1:IndexPath?
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
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        dobTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerFromValueChanged), for: .valueChanged)
    }
    
    func configureCell(withEmail email:String?, withFirstName firstName:String?, withLastName lastName:String?, shouldEnableVerify shouldVerfiy:Bool = true) {
        if checkedStatus == "done" {
            verifyButton.setTitleColor(Colors.nimnimButtonBorderGreen, for: .normal)
            verifyButton.setTitle("Verified", for: .normal)
        }else {
            verifyButton.setTitleColor(Colors.nimnimBlue, for: .normal)
            verifyButton.setTitle("Verify", for: .normal)
        }
        if let email = email, email.count > 0 {
            emailAddressTextField.text = email
            emailAddressTextField.font = Fonts.medium20
        }
        if let firstName = firstName, firstName.count > 0 {
            firstNameTextField.text = firstName
            firstNameTextField.font = Fonts.medium20
        }
        if let lastName = lastName, lastName.count > 0 {
            lastNameTextField.text = lastName
            lastNameTextField.font = Fonts.medium20
        }
        if shouldVerfiy {
            verifyButton.isUserInteractionEnabled = true
            verifyButton.alpha  = 1
        }else  {
            verifyButton.isUserInteractionEnabled = false
            verifyButton.alpha  = 0.5
        }
    }

    //MARK:IBActions
    @IBAction func showTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
           showPaswordButton.setTitle("Show", for: .normal)
        }else {
           showPaswordButton.setTitle("Hide", for: .normal)
        }
    }
    
    @IBAction func verifyTapped(_ sender: Any) {
        verifyButton.isUserInteractionEnabled = false
        verifyButton.alpha  = 0.5
        delegate?.verifyTappedInSignUpTableViewCell(withPhoneNumber:phoneNumberTextField.text)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInSignUpTableViewCell(withEmail: emailAddressTextField.text, withFirstName: firstNameTextField.text, withLastName: lastNameTextField.text, withPhoneNumber: phoneNumberTextField.text, withPassword: passwordTextField.text, withDob: dobTextField.text)
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        delegate?.loginTappedInSignUpTableViewCell()
    }
    
    @IBAction func dobTapped(_ sender: Any) {
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dobTextField.font = Fonts.medium20
        dobTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInSignUpTableViewCell(withTextField: textField)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInSignUpTableViewCell(withTextField: textField)
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
