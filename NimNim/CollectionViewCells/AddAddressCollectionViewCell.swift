//
//  AddAddressCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
protocol AddAddressCollectionViewCellDelegate:class {
    
    func textFieldStartedEditingInAddAddressCollectionViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to add tap geture to the view and to pass the text field selected
    func textFieldEndedEditingInAddAddressCollectionViewCell(withTextField textField:UITextField) // To tell the loginSignUpVC to remove the tap gesture from the view and to pass the textfield upon which end editing has been called
    func textEntered(withText text:String?, withIndexPath indexPath:IndexPath?)
    
}


class AddAddressCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addressText: UITextField!
    
    enum selectionMode {
        case add
        case edit
    }
    
    var mode : selectionMode = .add
    
    weak var delegate :AddAddressCollectionViewCellDelegate?
    
    var indexPath:IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        addressText.delegate = self
        
    }
    
    //MARK: TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) //To shut the keyboard// this function is called when the user is pressing the return button
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldStartedEditingInAddAddressCollectionViewCell(withTextField: textField)
        return true
    } // built in delegate function of textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndedEditingInAddAddressCollectionViewCell(withTextField: textField)
        delegate?.textEntered(withText: textField.text, withIndexPath: indexPath)
        return true
    
    }
}
