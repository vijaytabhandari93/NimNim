//
//  DropDownCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 02/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import iOSDropDown

protocol DropDownCollectionViewCellDelegate:class {
    func selectedDropDownValue(withValue value:String?, withIndex index:Int?)
}

class DropDownCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var dropDownTextField: DropDown!
    
    weak var delegate:DropDownCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    

    
    func configureCell(withOptions options:[String], withSelectedIndex selectedIndex:Int?) {
        dropDownTextField.optionArray = options
        if let selectedIndex = selectedIndex {
            dropDownTextField.text = options[selectedIndex]
            dropDownTextField.selectedIndex = selectedIndex
        }
        dropDownTextField.didSelect {[weak self] (option, index, id) in
            self?.delegate?.selectedDropDownValue(withValue: option, withIndex: index)
            self?.dropDownTextField.hideList()
        }
    }

}
