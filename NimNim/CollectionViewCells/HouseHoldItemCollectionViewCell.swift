//
//  HouseHoldItemCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol HouseHoldItemCollectionViewCellDelegate:class {
    
    func textFieldStartedEditingInCell(withTextField textField:UITextField) // To tell the VC to add tap geture to the view and to pass the text field selected
    func textFieldEndedEditingInCell(withTextField textField:UITextField) // To tell the VC to remove the tap gesture from the view and to pass the textfield upon which end editing has been called
    func ifLaunderedTapped(withIndexPath indexPath : IndexPath?)
    func ifDryCleanedTapped(withIndexPath indexPath : IndexPath?)
}

class HouseHoldItemCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {
    @IBOutlet weak var laundryRate: UILabel!
    @IBOutlet weak var DryCleaningButton: UIButton!
    @IBOutlet weak var laundryButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dryCleaningRate: UILabel!
    @IBOutlet weak var qty: UITextField!

    var indexPath : IndexPath?
    var model : ItemModel?
    var delegate : HouseHoldItemCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        qty.delegate = self
        // Initialization code
    }
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
        if let text = textField.text {
            self.model?.qty = Int(text)
        }
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
    
    @IBAction func ifLaundered(_ sender: Any) {
        //First we have passed the itemModel ie items[indexPath.item] through ConfigureUI function in cell for item at Index Path.
        //We have updated the item model in the collection view cell itseelf.this has avoided the need to create a delegate function... after updating the model we have also updated the UI by calling setupUI... this setupUI function is called even when configure UI is called through cellForItem in Controller... hencee the ui will get updated then as well from the model...
        if let isLaundrySelected = self.model?.IfLaundered, isLaundrySelected == true {
            self.model?.IfLaundered = false
        }else {
            self.model?.IfLaundered = true
            self.model?.IfDrycleaned = false
        }
        setupUI()
        delegate?.ifLaunderedTapped(withIndexPath: indexPath)
    }
    
    @IBAction func ifDryCleaned(_ sender: Any) {
        if let isDryCleaningSelected = self.model?.IfDrycleaned, isDryCleaningSelected == true {
            self.model?.IfDrycleaned = false
        }else {
            self.model?.IfLaundered = false
            self.model?.IfDrycleaned = true
        }
        setupUI()
        delegate?.ifDryCleanedTapped(withIndexPath: indexPath)
    }
    
    func configureUI(withModel model:ItemModel?, withIndexPath indexPath:IndexPath?) {
        self.model = model
        self.indexPath = indexPath
        setupUI()
    }
    
    func setupUI() {
        if let isLaundrySelected = self.model?.IfLaundered, isLaundrySelected == true {
            let image = UIImage(named: "path2")
            laundryButton.setImage(image, for: .normal)
            laundryButton.backgroundColor = Colors.nimnimGreen
        }else {
            laundryButton.setImage(nil, for: .normal)
            laundryButton.backgroundColor = Colors.nimnimGrey
        }
        
        if let isDryCleaningSelected = self.model?.IfDrycleaned, isDryCleaningSelected == true {
            let image = UIImage(named: "path2")
            DryCleaningButton.setImage(image, for: .normal)
            DryCleaningButton.backgroundColor = Colors.nimnimGreen
        }else {
            DryCleaningButton.setImage(nil, for: .normal)
            DryCleaningButton.backgroundColor = Colors.nimnimGrey
        }
        if let quantity = self.model?.qty, quantity > 0 {
            qty.text = "\(quantity)"
        }else {
            qty.text = nil
        }
    }
    
}
