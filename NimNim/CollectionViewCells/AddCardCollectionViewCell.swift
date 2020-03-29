//
//  AddCardCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 20/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NTMonthYearPicker

protocol AddCardCollectionViewCellDelegate:class {
    
    func textFieldStartedEditingInAddCardCollectionViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to add tap geture to the view and to pass the text field selected
    func textFieldEndedEditingInAddCardCollectionViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to remove the tap gesture from the view and to pass the textfield upon which end editing has been called
    func cardNumberEntered(withText text:String?)
    func expiryEntered(withText text:String?)
    func cvvEntered(withText text:String?)
    func nameEntered(withText text:String?)
}

class AddCardCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {

    weak var delegate :AddCardCollectionViewCellDelegate?
    //MARK: IBOutlets
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardHolderName: UILabel!
    @IBOutlet weak var cardHolderNamePopulate: UILabel!
    @IBOutlet weak var validTill: UILabel!
    @IBOutlet weak var validTillPopulate: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardNumberPopulate: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var nameOnCardTextField: UITextField!
    
    @IBOutlet weak var cardNumberTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expiryTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvvTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameOnCardTopConstraint: NSLayoutConstraint!
    
    //MARK: Constants and Variables
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardNumberTextField.delegate = self
        expiryTextField.delegate = self
        cvvTextField.delegate = self
        nameOnCardTextField.delegate = self
        let datePickerView = NTMonthYearPicker()
        expiryTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerFromValueChanged), for: .valueChanged)
    }
    
    func animateToTop(withConstraint constraint:NSLayoutConstraint) {
        constraint.constant = 5
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {[weak self] in
            self?.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateToBottom(withConstraint constraint:NSLayoutConstraint) {
        constraint.constant = 25
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {[weak self] in
            self?.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) //To shut the keyboard// this function is called when the user is pressing the return button
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInAddCardCollectionViewCell(withTextField: textField)
        if textField == cardNumberTextField{
            animateToTop(withConstraint: cardNumberTopConstraint)
        }else if textField == expiryTextField {
            animateToTop(withConstraint: expiryTopConstraint
            )
        }else if textField == cvvTextField {
            animateToTop(withConstraint: cvvTopConstraint)
        }else if textField == nameOnCardTextField {
            animateToTop(withConstraint: nameOnCardTopConstraint)
        }
        
        return true
    } // built in delegate function of textfield
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInAddCardCollectionViewCell(withTextField: textField)
        if textField == cardNumberTextField{
            delegate?.cardNumberEntered(withText: textField.text)
            if let text = textField.text, text.count == 0 {
                animateToBottom(withConstraint: cardNumberTopConstraint)
            }else if textField.text == nil {
                animateToBottom(withConstraint: cardNumberTopConstraint)
            }
        }else if textField == expiryTextField {
            delegate?.expiryEntered(withText: textField.text)
            if let text = textField.text, text.count == 0 {
                animateToBottom(withConstraint: expiryTopConstraint)
            }else if textField.text == nil {
                animateToBottom(withConstraint: expiryTopConstraint)
            }
        }else if textField == cvvTextField {
            delegate?.cvvEntered(withText: textField.text)
            if let text = textField.text, text.count == 0 {
                animateToBottom(withConstraint: cvvTopConstraint)
            }else if textField.text == nil {
                animateToBottom(withConstraint: cvvTopConstraint)
            }
        }else if textField == nameOnCardTextField {
            delegate?.nameEntered(withText: textField.text)
            if let text = textField.text, text.count == 0 {
                animateToBottom(withConstraint: nameOnCardTopConstraint)
            }else if textField.text == nil {
                animateToBottom(withConstraint: nameOnCardTopConstraint)
            }
        }
        return true///The above functions are used to send the data of textfield in the cell to the view controller.
    } // built in delegate function of textfield
    
    
    @objc func datePickerFromValueChanged(sender:NTMonthYearPicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        expiryTextField.font = Fonts.medium20
        expiryTextField.text = dateFormatter.string(from: sender.date) //convert the date into string format
        validTillPopulate.text = expiryTextField.text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This function is changing the font of the textField to montserratMedium/20 as soon as the user starts typing into the textField...and changing it back to montserratRegular/14 when the text is cleared or rubbed completely....
        // range =
        
        //Here we are converting NSRange to Range using the NSRange value passed above...and the current textField text...we have done this because the function "replacingCharacters" used below expects a Range Value and not NSRange value...
        if let text = textField.text, //abcde
            let textRange = Range(range, in: text) { // position and length is in range which has typed
            //Here, we are using the range and text values to determine the upcoming string inside the textfield...this will enable to setup the font beforehand....
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string) // final string
            if updatedText.count > 0 {
                textField.font = Fonts.medium20
            }else {
                textField.font = Fonts.regularFont14
            }
            if textField == cardNumberTextField {
                cardNumberPopulate.text = updatedText
            }
            if textField == expiryTextField {
                validTillPopulate.text = updatedText
            }
            if textField == nameOnCardTextField {
                cardHolderNamePopulate.text = updatedText
            }
        }
        return true
    }
}
