////
////  WashAndAirDryViewController.swift
////  NimNim
////
////  Created by Raghav Vij on 10/10/19.
////  Copyright © 2019 NimNim. All rights reserved.

import UIKit

class WashAndAirDryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate {
    
    
    
    //IBOutlets
    @IBOutlet weak var washAndAirDryCollectionView: UICollectionView!
    @IBOutlet weak var washAndAirDryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        
        
        let type4PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        let type5PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell")
        let type6PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        washAndAirDryCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        washAndAirDryCollectionView.delegate = self
        washAndAirDryCollectionView.dataSource = self
        if let name = serviceModel?.name {
            washAndAirDryLabel.text = "\(name)"
        }
        if let description = serviceModel?.name {
            descriptionLabel.text = "\(description)"
        }
        if let priceOfService = serviceModel?.price {
            priceLabel.text = "\(priceOfService)"
        }
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func basketTapped(_ sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
    }
    
    @IBAction func justNimNimItTapped(_ sender: Any) {
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        addToCart.setTitle("CheckOut", for: .normal)
        IsAddToCartTapped = true
        washAndAirDryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:88)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }else if section == 2 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 92)
        }
        return CGSize(width: collectionView.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PreferencesCollectionReusableView", for: indexPath) as! PreferencesCollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
        
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 5 }
        else
        {
            return 4 }//number of clothes, preferences, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 3
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.titleLabel.text = "Number of Clothes"
            return cell
        }
        else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Wash"
                if let washes = serviceModel?.wash, washes.count >= 2 {
                    let firstPreference = washes[0]
                    let secondPreference = washes[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: washes)
                }
                return cell
                
            case 1 :
                cell.titleLabel.text = "Bleach"
                if let bleach = serviceModel?.bleach, bleach.count >= 2 {
                    let firstPreference = bleach[0]
                    let secondPreference = bleach[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: bleach)
                }
                return cell
            case 2 :
                cell.titleLabel.text = "Softner"
                if let softner = serviceModel?.softner, softner.count >= 2 {
                    let firstPreference = softner[0]
                    let secondPreference = softner[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: softner)
                }
                return cell
        
            default:
                cell.titleLabel.text = "Detergent"
                cell.leftImageView.image = UIImage(named: "scented")
                cell.leftLabel.text = "Scented"
                cell.rightImageView.image = UIImage(named: "nonScented")
                cell.rightLabel.text = "Non - Scented"
                return cell
                
            }
        }
        if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            return cell
        }
        else if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell", for: indexPath) as! RushDeliveryNotAvailableCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
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
