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
    
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var preferenceSelected: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    var notesWritten : String?
    weak var delegate : DeliverynotesCollectionViewCellDelegate?
    let placeholderText = "Attach photos and write any notes"
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
    
    func configureCell(withUploadedImages uploadedImages:[String]?) {
        image1.alpha = 0
        image2.alpha = 0
        image3.alpha = 0
        if let pref = UserDefaults.standard.object(forKey: UserDefaultKeys.pickUpDropOfPreferences) as? String  {
            preferenceSelected.text = pref
            preferenceSelected.textColor = Colors.nimnimGreen
        }else {
            preferenceSelected.text = "Please select your preference"
            preferenceSelected.textColor = Colors.nimnimGrey
        }
        
        if let uploadedImages = uploadedImages {
            if uploadedImages.count > 0 {
                let image = uploadedImages[0]
                if let urlValue = URL(string: image)
                {
                    image1.alpha = 1
                    image1.kf.setImage(with: urlValue)
                }
            }
            if uploadedImages.count > 1 {
                let image = uploadedImages[1]
                if let urlValue = URL(string: image)
                {
                    image2.alpha = 1
                    image2.kf.setImage(with: urlValue)
                }
            }
            if uploadedImages.count > 2 {
                let image = uploadedImages[2]
                if let urlValue = URL(string: image)
                {
                    image3.alpha = 1
                    image3.kf.setImage(with: urlValue)
                }
            }
        }
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
