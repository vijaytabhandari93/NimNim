//
//  NoofClothesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol NoofClothesCollectionViewCellDelegate:class {
   
    func textFieldStartedEditingInCell(withTextField textField:UITextField) // To tell the loginSignUpVC to add tap geture to the view and to pass the text field selected
    func textFieldEndedEditingInCell(withTextField textField:UITextField) // To tell the loginSignUpVC to remove the tap gesture from the view and to pass the textfield upon which end editing has been called
}

class NoofClothesCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noOfPieces: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noOfPieces.delegate = self
        // Initialization code
    }
    var delegate : NoofClothesCollectionViewCellDelegate?
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) //To shut the keyboard// this function is called when the user is pressing the return button
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInCell(withTextField: textField)
        return true
    } // built in delegate function of textfield
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInCell(withTextField: textField)
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
    


