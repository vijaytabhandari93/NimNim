//
//  SpecialNotesCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SpecialNotesCollectionViewCell: UICollectionViewCell, UITextViewDelegate {

    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesTextBox: UITextView!
    
    override func awakeFromNib() {
        //border addition to be done
        super.awakeFromNib()
        notesTextBox.delegate = self
        // Initialization code
        notesTextBox.textContainerInset = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
    }
    
    @IBAction func pinTappedToUploadImages(_ sender: Any) {
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        textView.endEditing(true)
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        //tap gesture
    }
    func textViewDidEndEditing(_ textView: UITextView){}
    

}
