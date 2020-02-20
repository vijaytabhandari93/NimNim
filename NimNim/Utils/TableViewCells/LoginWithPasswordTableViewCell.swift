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
    func logInTappedInLoginWithPasswordTableViewCell(withEmail email:String?,withPassword password:String?) // main login tapped
    func sendLinkTappedInLoginWithPasswordTableViewCell(withPhone email:String?)
}
enum PasswordState {
    case forgotPassword
    case logIn
}

class LoginWithPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var otpAndForgotPasswordView: UIView!
    @IBOutlet weak var dontHaveAccountView: UIView!
    @IBOutlet weak var PasswordViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logInButton: UIButton!
    
    //MARK: Constants and Variables
    weak var delegate :LoginWithPasswordTableViewCellDelegate?
    var currentState:PasswordState = .logIn {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTextFieldDelegates()
    }
    
    func configureView(withState State:PasswordState) {
        currentState = State // We are saving the current state so that we can use it later to determine what has to be done when the user taps on the login button later on...
    }
    
    func setupView() {
        if currentState == .forgotPassword {
            passwordView.isHidden = true
            emailTextField.text = ""
            emailTextField.placeholder = "Phone number here *"
            PasswordViewTopConstraint.constant = 0
            logInButton.setTitle("Send OTP", for: .normal)
            passwordViewHeightConstraint.constant = 0
            otpAndForgotPasswordView.isHidden = true
            dontHaveAccountView.isHidden = true
        }else {
            passwordView.isHidden = false
            emailTextField.placeholder = "Email here *"
            PasswordViewTopConstraint.constant = 39
            logInButton.setTitle("Log In", for: .normal)
            passwordViewHeightConstraint.constant = 28
            otpAndForgotPasswordView.isHidden = false
            dontHaveAccountView.isHidden = false
        }
    }
    
    func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.inputAccessoryView = nil //keyboard corrections option are set to nil
        passwordTextField.inputAccessoryView = nil //keyboard corrections option are set to nil
    }

    //MARK: IBActions
    @IBAction func forgotPassword(_ sender: Any) {
        currentState = .forgotPassword
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInLoginWithPasswordTableViewCell()
    }
    @IBAction func logInTapped(_ sender: Any) {
        //if current state is .getOtp then we need to call getOtpTapped in the delegate of this cell...else we need to call verifyOtpTapped in the delegate of this cell...
        if currentState == .forgotPassword {
            delegate?.sendLinkTappedInLoginWithPasswordTableViewCell(withPhone: emailTextField.text)
        }else {
            delegate?.logInTappedInLoginWithPasswordTableViewCell( withEmail:emailTextField.text, withPassword: passwordTextField.text)
        }
    }
    
    @IBAction func logInViaOtpTapped(_ sender: Any) {
        delegate?.logInViaOtpTappedInLoginWithPasswordTableViewCell()
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) //To shut the keyboard// this function is called when the user is pressing the return button
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
