//
//  AddNewCardViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 20/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddNewCardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AddCardCollectionViewCellDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var cardCollectionView:UICollectionView!
    @IBOutlet weak var credit: UIButton!
    @IBOutlet weak var debit: UIButton!
    
    enum cardtype : Int {
        case credit
        case debit
    }
    
    var selectedCardState : cardtype! {
        didSet{
            if selectedCardState == .credit
            {
                resetButtons()
                credit.isSelected = true
                credit.titleLabel?.font = Fonts.semiBold16
                credit.setTitleColor(UIColor.white, for: .normal)
                cardCollectionView.reloadData()
                
            }
            else {
                resetButtons()
                debit.isSelected = true
                debit.titleLabel?.font = Fonts.semiBold16
                debit.setTitleColor(UIColor.white, for: .normal)
                cardCollectionView.reloadData()
                
            }
        }
        
    }
    var cardNumber:String?
    var expiry:String?
    var cvv:String?
    var nameOnCard:String?
    
    func resetButtons() {
        credit.isSelected = false
        debit.isSelected = false
        credit.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        debit.titleLabel?.font = Fonts.regularFont12
        credit.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        debit.titleLabel?.font = Fonts.regularFont12
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyHorizontalNimNimGradient()
    }
    var activeTextField:UITextField?
    
    func textFieldStartedEditingInAddCardCollectionViewCell(withTextField textField:UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInAddCardCollectionViewCell(withTextField textField:UITextField) {
        removeTapGestures(forTextField: textField)
    }
    
    func cardNumberEntered(withText text: String?) {
        cardNumber = text
    }
    
    func expiryEntered(withText text: String?) {
        expiry = text
    }
    
    func cvvEntered(withText text: String?) {
        cvv = text
    }
    
    func nameEntered(withText text: String?) {
        nameOnCard = text
    }
    
    func removeTapGestures(forTextField textField:UITextField) {
        // This function first checks if the textField that is passed is the currently active TextField or Not...if the user will tap somewhere outside then the textField passed will be equal to the activeTextField...but if the user will tap on another textField and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextField = activeTextField, activeTextField == textField {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    
    
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "AddCardCollectionViewCell", bundle: nil)
        cardCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AddCardCollectionViewCell")
    }
    
    func postCardDetails(withCardNumber cardNumber:String?, withExpiryEntered expiry:String?, withcvv cvv:String?,withName name:String?) {
        guard let cardNumber = cardNumber, let expiry = expiry, let cvv = cvv, let name = name else {
            return
        }
        var month = ""
        var year = ""
        let splitExpiryArray = expiry.components(separatedBy: "-")
        if splitExpiryArray.count == 2 {
            month = splitExpiryArray[0]
            year = splitExpiryArray[1]
        }
        
        let params:[String:Any] = [
            AddCard.month:month,
            AddCard.year:year,
            AddCard.cvv:cvv,
            AddCard.cardNumber:cardNumber,
        ]
        NetworkingManager.shared.post(withEndpoint: Endpoints.addCard, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                print(responseDict)
                print("hello")
            }
            //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                print("wrong")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addCardTapped(_ sender:Any?) {
        postCardDetails(withCardNumber: cardNumber, withExpiryEntered: expiry, withcvv: cvv, withName: nameOnCard)
    }
  
    @IBAction func creditTapped(_ sender:Any?) {
        selectedCardState = .credit
    }
    @IBAction func debitTapped(_ sender:Any?) {
        selectedCardState = .debit
    }
    
    @IBAction func previousTapped(_ sender:Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCardCollectionViewCell", for: indexPath) as! AddCardCollectionViewCell
        cell.delegate = self //This line tells that i am conforming to this AddCardCollectionViewCellDelegate protocol
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 486)
    }

}
