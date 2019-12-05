//
//  DryCleaningViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class DryCleaningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate {
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 5 }
        else
        {
            return 4 }//select from list,return hanger, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }else if section == 4 {
            return 1
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectFromListOfClothesCollectionViewCell", for: indexPath) as! SelectFromListOfClothesCollectionViewCell
            cell.serviceModel = serviceModel
            return cell
            
        }
            
        else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.labelAgainsCheckbox.text = "Return Hangers"
            cell.descriptionofLabel.text = "Do you want to return the hangers? We re-cycle old hangers."
            return cell
        }
            
        else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            return cell
            
        }
            
        else if section == 3  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.labelAgainsCheckbox.text = "I need Rush Delivery"
            if let arrayRushOptions = serviceModel?.rushDeliveryOptions, arrayRushOptions.count == 1 {
                let firstPreference = arrayRushOptions[0]
                if let hours  = firstPreference.turnAroundTime
                    ,let extraPrice = firstPreference.price
                { cell.descriptionofLabel.text = "Under rush delivery your clothes will be delivered with in \(hours) Hours and $\(extraPrice) will be charged extra for the same" }
                return cell
            }
        }
        else if section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var dryCleaningCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerCells()
        dryCleaningCollectionView.delegate = self
        dryCleaningCollectionView.dataSource = self
        if let name = serviceModel?.name {
            washAndFoldLabel.text = "\(name)"
        }
        if let description = serviceModel?.name {
            descriptionLabel.text = "\(description)"
        }
    }
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        let type4PreferencesNib = UINib(nibName: "SelectFromListOfClothesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SelectFromListOfClothesCollectionViewCell")
        
        
    }
    
    @IBAction func basketTapped(_ sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
    }
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        addToCart.setTitle("CheckOut", for: .normal)
        IsAddToCartTapped = true
        dryCleaningCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:56)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 2 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    
    func removeTapGestures(forTextView textView:UITextView) {
        // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextView = activeTextView, activeTextView == textView {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    //Delegate Function of TextView
    func sendImage() {
          print("need Image")
    }
    
    func textViewStartedEditingInCell(withTextField textView: UITextView) {
        activeTextView = textView
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textViewEndedEditingInCell(withTextField textView: UITextView) {
         removeTapGestures(forTextView: textView)
    }
    
    
    
}


