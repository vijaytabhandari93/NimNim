//
//  PricingViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher


class FAQViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBAction func backButtonTapped(_ sender: Any) {navigationController?.popViewController(animated: true)
    }
    
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
    }
    
    var KnowMoreAboutNimNim  : Bool  = false
    var AccountAndProfileManagement  : Bool  = false
    var Payments  : Bool  = false
    var PickupDelivery  : Bool  = false
    var RefundAndCancellation  : Bool  = false

    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type3PreferencesNib = UINib(nibName: "PricingHeaderCollectionViewCell", bundle: nil)
             pricingCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "PricingHeaderCollectionViewCell")
         let type2PreferencesNib = UINib(nibName: "DescriptionCollectionViewCell", bundle: nil)
           pricingCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "DescriptionCollectionViewCell")
        let type1PreferencesNib = UINib(nibName: "AnswerDescriptionCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AnswerDescriptionCollectionViewCell")
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.item == 0
        {
            return CGSize(width: collectionView.frame.size.width, height:45)
        }
        else {
            var text = ""
            if indexPath.section == 0 {
                if indexPath.item == 1 {
                    text = "What is NimNim?"
                }
                if indexPath.item == 2 {
                    text = "We are a real-time, on-demand pick up and drop off concierge for your everyday lifestyle chores including Laundry, Dry-Cleaning, Shoe Care, and Alterations. We’re driven by convenience and customer service is our top most priority."
                }
                if indexPath.item == 3 {
                    text = "How does NimNim work?"
                }
            }else if indexPath.section == 1 {
                if indexPath.item == 2 {
                    text = "Download the app. Choose your services. Enter your contact details and hit submit. We’ll take care of the rest!"
                }
               }
            else if indexPath.section == 2 {
                if indexPath.item == 2 {
                    text = "Minimum: 1 shirt"
                }
                if indexPath.item == 3 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 4 {
                    text = "Delivered within 24 hours"
                }
                
            }else if indexPath.section == 3 {
                if indexPath.item == 1 {
                    text = "View list for specific prices"
                }
                if indexPath.item == 2 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours"
                }
            }else {
                if indexPath.item == 1 {
                    text = "View list for specific prices"
                }
                if indexPath.item == 2 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours"
                }
            }
            let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
            label.text = text
            label.numberOfLines = 0
            label.font = Fonts.regularFont12
            label.sizeToFit()
            let h: CGFloat = label.frame.size.height
            print(h)
            return CGSize.init(width:collectionView.frame.size.width, height : h+10)
        }
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if KnowMoreAboutNimNim == true{
                return 8
            }
            else{
                return 1
            }
        }
        else if section == 1 {
            if AccountAndProfileManagement == true{
                return 8
            }
            else{
                return 1
            }
        }
        else if section == 2 {
            if Payments == true{
                return 8
            }
            else{
                return 1
            }
        }
        else if section == 3 {
            if PickupDelivery == true{
                return 8
            }
            else{
                return 1
            }
        }
        else {
            if RefundAndCancellation == true{
                return 8
            }
            else{
                return 1
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Know more about NimNim"
                if KnowMoreAboutNimNim == true {
                    cell.configureCell(withExpandedState: true)
                } else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                    cell.label.text = "What is NimNim?"
                               
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerDescriptionCollectionViewCell", for: indexPath) as! AnswerDescriptionCollectionViewCell
                cell.answerLabel.text = "We are a real-time, on-demand pick up and drop off concierge for your everyday lifestyle chores including Laundry, Dry-Cleaning, Shoe Care, and Alterations. We’re driven by convenience and customer service is our top most priority."
                return cell
            }
            else if indexPath.item == 3
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "How does NimNim work?"
                return cell
            }
            else  if indexPath.item == 4
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerDescriptionCollectionViewCell", for: indexPath) as! AnswerDescriptionCollectionViewCell
                cell.answerLabel.text = "Download the app. Choose your services. Enter your contact details and hit submit. We’ll take care of the rest!"
                return cell
            }
        
        }
        else if indexPath.section == 1 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Account and Profile Management"
                if AccountAndProfileManagement == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
            
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "No Minimum order."
                return cell
            }
           
            
        }else if indexPath.section == 2 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Payments"
                if Payments == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
      
       
                return cell
            }
            else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Minimum: 1 shirt"
                return cell
            }
                
            else if indexPath.item == 3
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Rush-enabled"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Delivered within 24 hours"
                return cell
            }
            
        }else if indexPath.section == 3 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Pickup/Delivery"
                if PickupDelivery == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceViewListCollectionViewCell", for: indexPath) as! PriceViewListCollectionViewCell
                cell.screenType  = "Household Items"
                return cell
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Rush service not available"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 24 hours"
                return cell
            }
        }
        else if indexPath.section == 4 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text  = "Refund and Cancellation"
                if RefundAndCancellation == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceViewListCollectionViewCell", for: indexPath) as! PriceViewListCollectionViewCell
                cell.screenType  = "Dry Cleaning"
                return cell
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Rush-enabled"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 24 hours"
                return cell
            }
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
              cell.label.text  = "Delivered within 7 days"
              return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            KnowMoreAboutNimNim = !KnowMoreAboutNimNim
        }
        else if indexPath.section == 1 && indexPath.item == 0 {
            AccountAndProfileManagement = !AccountAndProfileManagement
        }
        else if indexPath.section == 2 && indexPath.item == 0 {
             Payments = !Payments
        }
        else if indexPath.section == 3 && indexPath.item == 0 {
            PickupDelivery = !PickupDelivery
        }else if indexPath.section == 4 && indexPath.item == 0 {
            RefundAndCancellation = !RefundAndCancellation
        }
        pricingCollectionView.reloadData()
        
    }
    
    
    
}

