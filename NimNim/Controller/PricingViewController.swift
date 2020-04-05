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


class PricingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBAction func backButtonTapped(_ sender: Any) {navigationController?.popViewController(animated: true)
    }
    
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchServices()
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
    }
    
    var selectedWashAndFold  : Bool  = false
    var selectedWashAndAirDry  : Bool  = false
    var selectedLaunderedShirts  : Bool  = false
    var selectedDryCleaning  : Bool  = false
    var selectedHouseholdItems  : Bool  = false
    var selectedTailoring  : Bool  = false
    var selectedShoeRepair  : Bool  = false
    var selectedRugCleaning  : Bool  = false
    var serviceModel : ServiceBaseModel?
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "PriceCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "PriceCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "DescriptionCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "DescriptionCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "PricingHeaderCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "PricingHeaderCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "PriceViewListCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "PriceViewListCollectionViewCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.item == 0
        {
            return CGSize(width: collectionView.frame.size.width, height:66)
        }
        else if indexPath.section == 0 && indexPath.item == 1 || indexPath.section == 1 && indexPath.item == 1 || indexPath.section == 2 && indexPath.item == 1 || indexPath.section == 7 && indexPath.item == 1 {
            return CGSize(width: collectionView.frame.size.width, height:10)
        }
        else {
            var text = ""
            if indexPath.section == 0 {
                if indexPath.item == 2 {
                    text = "Minimum - 10 lbs"
                }
                if indexPath.item == 3 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 4 {
                    text = "Delivered within 24 hours"
                }
            }else if indexPath.section == 1 {
                if indexPath.item == 2 {
                    text = "No minimum order"
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
            }else if indexPath.section == 4 {
                if indexPath.item == 1 {
                    text = "View list for specific prices"
                }
                if indexPath.item == 2 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours"
                }
            }else if indexPath.section == 5 {
                if indexPath.item == 1 {
                    text = "View list for specific prices"
                }
                if indexPath.item == 2 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours"
                }
            }else if indexPath.section == 6 {
                if indexPath.item == 1 {
                    text = "View list for specific prices"
                }
                if indexPath.item == 2 {
                    text = "Rush-enabled"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours"
                }
            } else if indexPath.section == 7 {
                if indexPath.item == 2 {
                    text = "Rush service not available"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 7 days"
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
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if selectedWashAndFold == true{
                return 5
            }
            else{
                return 1
            }
        }
        else if section == 1 {
            if selectedWashAndAirDry == true{
                return 3
            }
            else{
                return 1
            }
        }
        else if section == 2 {
            if selectedLaunderedShirts == true{
                return 5
            }
            else{
                return 1
            }
        }
        else if section == 3 {
            if selectedHouseholdItems == true{
                return 4
            }
            else{
                return 1
            }
        }
        else if section == 4 {
            if selectedDryCleaning == true{
                return 4
            }
            else{
                return 1
            }
        }else if section == 5 {
            if selectedTailoring == true{
                return 4
            }
            else{
                return 1
            }
        }else if section == 6 {
            if selectedShoeRepair == true{
                return 4
            }
            else{
                return 1
            }
        } else {
            if selectedRugCleaning == true{
                return 4
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
                cell.servicelabel.text = "Wash & Fold"
                if selectedWashAndFold == true {
                    cell.configureCell(withExpandedState: true)
                } else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
                if let arrayOfService =  serviceModel?.data
                               {
                                   if arrayOfService[indexPath.section + 2 ].alias == "wash-and-fold" {
                                       if let price = arrayOfService[indexPath.section + 2].price  {
                                                               cell.priceLabel.text = "$\(price)/lbs"
                                           }
                                                   
                                   }
                                
                return cell
            }
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Minimum - 10 lbs"
                return cell
            }
            else if indexPath.item == 3
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Rush-enabled"
                return cell
            }
            else  if indexPath.item == 4
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 24 hours"
                return cell
            }
        
        }
        else if indexPath.section == 1 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Wash & Air Dry"
                if selectedWashAndAirDry == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
             if let arrayOfService =  serviceModel?.data
                {
                    if arrayOfService[indexPath.section + 2].alias == "wash-and-air-dry" {
                        if let price = arrayOfService[indexPath.section  + 2].price  {
                                                cell.priceLabel.text = "$\(price)/lbs"
                            }
                                    
                    }
                  
                }
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
                cell.servicelabel.text = "Laundered Shirts"
                if selectedLaunderedShirts == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
       if let arrayOfService =  serviceModel?.data
       {
           if arrayOfService[indexPath.section - 1].alias == "laundered-shirts" {
               if let price = arrayOfService[indexPath.section  - 1].costPerPiece  {
                                       cell.priceLabel.text = "$\(price)/lbs"
                   }
                           
           }
         
       }
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
            else if indexPath.item == 4
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Delivered within 24 hours"
                return cell
            }
            
        }else if indexPath.section == 3 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Household Items"
                if selectedHouseholdItems == true {
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
                cell.servicelabel.text  = "Dry Cleaning"
                if selectedDryCleaning == true {
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
            
        }else if indexPath.section == 5 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text  = "Tailoring"
                if selectedTailoring == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceViewListCollectionViewCell", for: indexPath) as! PriceViewListCollectionViewCell
                cell.screenType  = "Tailoring"
                return cell
            }
           else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Rush service not available"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 4 days"
                return cell
            }
        }else if indexPath.section == 6 {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text  = "Shoe Repair"
                if selectedShoeRepair == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceViewListCollectionViewCell", for: indexPath) as! PriceViewListCollectionViewCell
                cell.screenType  = "Shoe Repair"
                return cell
            }
             else if indexPath.item == 2
                       { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                           cell.label.text = "Rush service not available"
                           return cell
                       }
                       else
                       { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                           cell.label.text = "Delivered within 7 days"
                           return cell
                       }
            
        } else {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text = "Rug Cleaning"
                if selectedRugCleaning == true {
                    cell.configureCell(withExpandedState: true)
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
         if let arrayOfService =  serviceModel?.data
                {
                    if arrayOfService[indexPath.section].alias == "carpet-cleaning" {
                        if let price = arrayOfService[indexPath.section].price  {
                                                cell.priceLabel.text = "$\(price)/sq ft"
                            }
                                    
                    }
                  
                }
                    
                return cell
            }
            else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Rush service not available"
                return cell
            }
                
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Delivered within 7 days"
                return cell
            }
            
        }
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
              cell.label.text  = "Delivered within 7 days"
              return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            selectedWashAndFold = !selectedWashAndFold
        }
        else if indexPath.section == 1 && indexPath.item == 0 {
            selectedWashAndAirDry = !selectedWashAndAirDry
        }
        else if indexPath.section == 2 && indexPath.item == 0 {
            selectedLaunderedShirts = !selectedLaunderedShirts
        }
        else if indexPath.section == 3 && indexPath.item == 0 {
            selectedHouseholdItems = !selectedHouseholdItems
        }else if indexPath.section == 4 && indexPath.item == 0 {
            selectedDryCleaning = !selectedDryCleaning
        }else if indexPath.section == 5 && indexPath.item == 0 {
            selectedTailoring = !selectedTailoring
        }else if indexPath.section == 6 && indexPath.item == 0 {
            selectedShoeRepair = !selectedShoeRepair
        }
        else {
            selectedRugCleaning = !selectedRugCleaning
        }
        pricingCollectionView.reloadData()
        
    }
    
    func fetchServices() {
        //activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.services, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let serviceModel = Mapper<ServiceBaseModel>().map(JSON: responseDict)
                //print(JSON(responseDict))
                self?.serviceModel = serviceModel //? is put after self as it is weak self.
               self?.pricingCollectionView.reloadData()
            }
           // self?.activityIndicator.stopAnimating()
            
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            //self.activityIndicator.stopAnimating()
        } // definition of error closure
    }
    
    
    
}
