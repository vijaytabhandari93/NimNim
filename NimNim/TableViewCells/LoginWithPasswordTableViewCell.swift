//
//  LoginWithPasswordTableViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol LoginWithPasswordTableViewCellDelegate:class {
    func signUpTappedInLoginWithPasswordTableViewCell()// To tell the loginSignUpVC to do changes in the currentScreenState variable
    func logInViaOtpTappedInLoginWithPasswordTableViewCell() // To tell the loginSignUpVC to do changes in the currentScreenState variable
    func textFieldStartedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to add tap geture to the view and to pass the text field selected
    func textFieldEndedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to remove the tap gesture from the view and to pass the textfield upon which end editing has been called
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
        textField.endEditing(true) //To shut the keyboard
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInLoginViaPasswordTableViewCell(withTextField: textField)
        return true
    } // built in delegate function of textfield
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInLoginViaPasswordTableViewCell(withTextField: textField)
        return true
    } // built in delegate function of textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This function is changing the font of the textField to montserratMedium/20 as soon as the user starts typing into the textField...and changing it back to montserratRegular/14 when the text is cleared or rubbed completely....
        // range =
        
        //Here we are converting NSRange to Range using the NSRange value passed above...and the current textField text...we have done this because the function "replacingCharacters" used below expects a Range Value and not NSRange value...
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            //Here, we are using the range and text values to determine the upcoming string inside the textfield...this will enable to setup the font beforehand....
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
