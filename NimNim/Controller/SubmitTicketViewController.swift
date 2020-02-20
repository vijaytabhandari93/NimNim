//
//  SubmitTicketViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 20/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit


protocol SubmitTicketViewControllerDelegate:class {
    func submitTicket(withIssueDescription issueDescription: String,withType type: String)
}

class SubmitTicketViewController: UIViewController,UITextViewDelegate {
    
    weak var delegate:SubmitTicketViewControllerDelegate?
    var Issue : IssueModel?
    var issueDescriptionToBeSend : String = ""
    var type : String = ""
    
    @IBOutlet weak var issueType: UILabel!
    @IBOutlet weak var issueDescription: UITextView!
    @IBOutlet weak var addressMethod: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDescription.delegate = self
        issueType.text = type

    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
     }
    
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAddressTapped(_ sender: Any) {

        delegate?.submitTicket(withIssueDescription: issueDescriptionToBeSend,withType : type)
        let alert = UIAlertController(title: "Alert", message: "Your issue has been reported and will be shortly resolved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {[weak alert] (_) in
            self.navigationController?.popViewController(animated: true)
              }))
        self.present(alert, animated: true, completion: nil)
     
      }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
         addTapGestureToView()
        if textView.text.caseInsensitiveCompare("Describe the issue in detail.") == .orderedSame {
                   textView.text = ""
               }
         return true
     }
     func addTapGestureToView() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
           self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
       }
    @objc func backViewTapped() {
          view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
      }
       
       func removeTapGestures(forTextView textView:UITextView) {
           // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
           if let activeTextView = issueDescription, activeTextView == textView {
               for recognizer in view.gestureRecognizers ?? [] {
                   view.removeGestureRecognizer(recognizer)
               }
           }
       }
     func textViewShouldEndEditing(_ textView: UITextView) -> Bool{
        if let abc = textView.text{
            self.issueDescriptionToBeSend =  abc
        }
  
         return true
     }
   
}
