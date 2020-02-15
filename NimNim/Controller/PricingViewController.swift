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
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
    }
    
    var selectedWashAndFold  : Bool  = false
    var selectedWashAndAirDry  : Bool  = false
    var selectedLaunderedShirts  : Bool  = false
    var selectedDryCleaning  : Bool  = false
    var selectedHouseholdItems  : Bool  = false
    
    
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
            return CGSize(width: collectionView.frame.size.width, height:45)
        }
        else if indexPath.item == 1  {
            return CGSize(width: collectionView.frame.size.width, height:15)
        }
        else {
            var text = ""
            if indexPath.section == 0 {
                if indexPath.item == 2 {
                    text = "Minimum - 10 lbs"
                }
                if indexPath.item == 3 {
                    text = "Clothes will be washed and folded"
                }
                if indexPath.item == 4 {
                    text = "Delivered Within 24 hours, Rush service Available"
                }
            }else if indexPath.section == 1 {
                if indexPath.item == 2 {
                    text = "No Minimum, items are billed per piece"
                }
                if indexPath.item == 3 {
                    text = "Order will be delivered Within 24 hours, Rush service available"
                }
            }else if indexPath.section == 2 {
                if indexPath.item == 2 {
                    text = "Shirts are washed and pressed and returned on Wooden hangers"
                }
                if indexPath.item == 3 {
                    text = "Customer can select preference as Boxed Shirts vs. shirts on hanger or choose light/medium/heavy or no starch"
                }
                if indexPath.item == 4 {
                    text = "1 Male Laundered Shirt"
                }
                if indexPath.item == 5 {
                    text = "Delivered within 24 hours, Rush service Available"
                }
            }else if indexPath.section == 3 {
                if indexPath.item == 2 {
                    text = "All Items List and Price"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours, Rush service Available"
                }
            }else if indexPath.section == 4 {
                if indexPath.item == 2 {
                    text = "All Items List and Price"
                }
                if indexPath.item == 3 {
                    text = "Delivered within 24 hours, Rush service Available"
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
            if selectedWashAndFold == true{
                return 5
            }
            else{
                return 1
            }
        }
        else if section == 1 {
            if selectedWashAndAirDry == true{
                return 4
            }
            else{
                return 1
            }
        }
        else if section == 2 {
            if selectedLaunderedShirts == true{
                return 6
            }
            else{
                return 1
            }
        }
        else if section == 3 {
            if selectedHouseholdItems == true{
                return 3
            }
            else{
                return 1
            }
        }
        else  {
            if selectedDryCleaning == true{
                return 3
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
                cell.priceLabel.text  = "$1.75/lb"
                return cell
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Minimum - 10 lbs"
                return cell
            }
            else if indexPath.item == 3
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Clothes will be washed and folded"
                return cell
            }
            else  if indexPath.item == 4
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered Within 24 hours, Rush service Available"
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
                cell.priceLabel.text = "$3/lb"
                return cell
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "No Minimum, items are billed per piece"
                return cell
            }
            else if indexPath.item == 2
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Order will be delivered Within 24 hours, Rush service available"
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
                cell.priceLabel.text = "$2.69/shirt"
                return cell
            }
            else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Shirts are washed and pressed and returned on Wooden hangers"
                return cell
            }
                
            else if indexPath.item == 3
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Customer can select preference as Boxed Shirts vs. shirts on hanger or choose light/medium/heavy or no starch"
                return cell
            }
            else if indexPath.item == 4
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "1 Male Laundered Shirt"
                return cell
            }
            else if indexPath.item == 5
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text  = "Delivered within 24 hours, Rush service Available"
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
                cell.label.text = "All Items List and Price"
                cell.screenType  = "Household Items"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 24 hours, Rush service Available"
                return cell
            }
        }
        else {
            if indexPath.item == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                cell.servicelabel.text  = "Dry Cleaning"
                return cell
            }
            else if indexPath.item == 1  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceViewListCollectionViewCell", for: indexPath) as! PriceViewListCollectionViewCell
                cell.label.text = "All Items List and Price"
                cell.screenType  = "Dry Cleaning"
                return cell
            }
            else
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                cell.label.text = "Delivered within 24 hours, Rush service Available "
                return cell
            }
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
        cell.label.text = "Delivered within 24 hours, Rush service Available "
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
        }
        else {
            selectedDryCleaning = !selectedDryCleaning
        }
        pricingCollectionView.reloadData()
        
    }
    
    
    
}
