//
//  SpecialNotesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol SpecialNotesCollectionViewCellDelegate:class{
    func sendImage()// To tell the VC to send image post call
    func textViewStartedEditingInCell(withTextField textView
        :UITextView) // To tell the VC to add tap geture to the view and to pass the text View selected
    func textViewEndedEditingInCell(withTextField textView : UITextView) // To tell the VC to remove the tap gesture from the view and to pass the textview upon which end editing has been called
    
}

class SpecialNotesCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesTextBox: UITextView!
    weak var delegate : SpecialNotesCollectionViewCellDelegate?
    var notesWritten : String?
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    
    let placeholderText = "Attach photos and write any notes"
    
    override func awakeFromNib() {
        //border addition to be done
        super.awakeFromNib()
        notesTextBox.delegate = self
        // Initialization code
        notesTextBox.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        
        firstImage.layer.borderWidth = 1
        secondImage.layer.borderWidth = 1
        thirdImage.layer.borderWidth = 1
        firstImage.layer.borderColor = Colors.borderColor.cgColor
        secondImage.layer.borderColor = Colors.borderColor.cgColor
        thirdImage.layer.borderColor = Colors.borderColor.cgColor
        
    }
    
    @IBAction func pinTappedToUploadImages(_ sender: Any) {
        delegate?.sendImage()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        delegate?.textViewStartedEditingInCell(withTextField: textView)
        if textView.text.caseInsensitiveCompare(placeholderText) == .orderedSame {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        delegate?.textViewEndedEditingInCell(withTextField: textView)
        if textView.text == "" {
            textView.font = Fonts.regularFont12
            textView.textColor = Colors.nimnimGrey
            textView.text = placeholderText
        }
        else {
            notesWritten = textView.text
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
