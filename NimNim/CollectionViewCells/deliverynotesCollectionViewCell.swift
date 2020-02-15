//
//  deliverynotesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 15/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

protocol DeliverynotesCollectionViewCellDelegate:class{
    func sendImage()// To tell the VC to send image post call
    func textViewStartedEditingInCell(withTextField textView
        :UITextView) // To tell the VC to add tap geture to the view and to pass the text View selected
    func textViewEndedEditingInCell(withTextField textView : UITextView) // To tell the VC to remove the tap gesture from the view and to pass the textview upon which end editing has been called
    func preferenceTapped()
}


class deliverynotesCollectionViewCell: UICollectionViewCell,UITextViewDelegate {
    
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var preferenceSelected: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    var notesWritten : String?
    weak var delegate : DeliverynotesCollectionViewCellDelegate?
    
    @IBAction func editPreferenceTapped(_ sender: Any) {
        
        delegate?.preferenceTapped()
    }
    
    @IBAction func uploadImageTapped(_ sender: Any) {
            delegate?.sendImage()
        
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notes.delegate = self
        notes.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
    }
    
    func configureCell() {
        if let pref = UserDefaults.standard.object(forKey: UserDefaultKeys.pickUpDropOfPreferences) as? String  {
            preferenceSelected.text = pref
            preferenceSelected.textColor = Colors.nimnimGreen
        }else {
            preferenceSelected.text = "Please select your preference"
            preferenceSelected.textColor = Colors.nimnimGrey
        }
    }

  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        delegate?.textViewStartedEditingInCell(withTextField: textView)
        if textView.text.caseInsensitiveCompare("Any Delivery notes...") == .orderedSame {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        delegate?.textViewEndedEditingInCell(withTextField: textView)
        if textView.text == "" {
            textView.font = Fonts.regularFont12
            textView.textColor = Colors.nimnimGrey
            textView.text = "Any Delivery notes..."
        }
        else {
            notesWritten = textView.text
            print(notesWritten)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // This function is changing the font of the textField to montserratMedium/20 as soon as the user starts typing into the textField...and changing it back to montserratRegular/14 when the text is cleared or rubbed completely....
        // range =
        
        //Here we are converting NSRange to Range using the NSRange value passed above...and the current textField text...we have done this because the function "replacingCharacters" used below expects a Range Value and not NSRange value...
        if let textViewCurrentText = textView.text,
            let textRange = Range(range, in: textViewCurrentText) {
            //Here, we are using the range and text values to determine the upcoming string inside the textfield...this will enable to setup the font beforehand....
            let updatedText = textViewCurrentText.replacingCharacters(in: textRange,
                                                       with: text)
            if updatedText.count > 0 {
                textView.font = Fonts.regularFont14
                textView.textColor = Colors.nimnimGreen
            }else {
                textView.font = Fonts.regularFont12
                
                
            }
        }
        return true
    }
    
    
    
    
}
