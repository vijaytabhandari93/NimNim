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
    func getOtpTapped(withPhone phoneNumber:String?)
    func resendOtpTapped(withPhone phoneNumber:String?)
    func verifyOtpTapped(withPhone phoneNumber:String?,withOTP otp:String?)
    func textFieldStartedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField)
    func textFieldEndedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField)
}

enum OTPState {
    case getOtp
    case verifyOtp
}


class LoginViaOTPTableViewCell: UITableViewCell, UITextFieldDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView! //to be optionally hidden
    @IBOutlet weak var resendOtpView: UIView!
    @IBOutlet weak var otpViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var otpViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Constants and Variables
    weak var delegate:LoginViaOTPTableViewCellDelegate?
    var currentState:OTPState = .getOtp
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
    
    func configureView(withOtpState otpState:OTPState) {
        currentState = otpState
        if otpState == .getOtp {
            otpView.isHidden = true
            otpViewTopConstraint.constant = 0
            otpViewHeightConstraint.constant = 0
            otpButton.setTitle("Get OTP", for: .normal)
            resendOtpView.isHidden = true
        }else {
            otpView.isHidden = false
            otpViewTopConstraint.constant = 39
            otpViewHeightConstraint.constant = 28
            otpButton.setTitle("Verify OTP", for: .normal)
            resendOtpView.isHidden = false
        }
    }

    //MARK:IBActions
    @IBAction func logInViaPasswordTapped(_ sender: Any) {
        delegate?.logInViaPasswordTappedInLoginViaOTPTableViewCell()
    }
    @IBAction func signUpTapped(_ sender: Any) {
        delegate?.signUpTappedInLoginViaOTPTableViewCell()
    }
    @IBAction func resendOtpTapped(_ sender: Any) {
        delegate?.resendOtpTapped(withPhone: mobileNumberTextField.text)
    }
    @IBAction func getOtptapped(_ sender: Any) {
        //if current state is .getOtp then we need to call getOtpTapped in the delegate of this cell...else we need to call verifyOtpTapped in the delegate of this cell...
        if currentState == .getOtp {
            delegate?.getOtpTapped(withPhone: mobileNumberTextField.text)
        }else {
            delegate?.verifyOtpTapped(withPhone: mobileNumberTextField.text, withOTP: otpTextField.text)
        }
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
