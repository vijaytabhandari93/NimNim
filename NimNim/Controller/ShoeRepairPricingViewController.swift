//
//  ShoeRepairPricingViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 28/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher

class ShoeRepairPricingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var serviceModel : ServiceBaseModel?
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
        registerCells()
        fetchServices()
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "PricingSubHeadingCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "PricingSubHeadingCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "ItemPriceListCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "ItemPriceListCollectionViewCell")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if indexPath.item == 0
        {
            return CGSize(width: collectionView.frame.size.width, height:35)
        } else{
            return CGSize(width: collectionView.frame.size.width, height:20)
        }
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            var count =  serviceModel?.data?.count
            if let count = count ,count > 0 {
                for i in 0...count {
                    if let arrayOfservices = serviceModel?.data
                    {
                        if arrayOfservices[i].alias == "shoe-repair"
                        {
                            if let arrayOfItem = arrayOfservices[i].items
                            { var j = 1
                                var count = arrayOfItem.count
                                for k in 1...count{
                                    print(count)
                                    if let type = arrayOfItem[k-1].genders {
                                        if type == "male"
                                        {
                                            j = j + 1
                                        }
                                    }
                                    
                                }
                                return j
                                break
                            }
                        }
                    }
                }
                return 0
            }
        }
        else {
            var count =  serviceModel?.data?.count
            if let count = count ,count > 0 {
                for i in 0...count {
                    if let arrayOfservices = serviceModel?.data
                    {
                        if arrayOfservices[i].alias == "shoe-repair"
                        {
                            if let arrayOfItem = arrayOfservices[i].items
                            { var j = 1
                                var count = arrayOfItem.count
                                for k in 1...count{
                                    print(count)
                                    if let type = arrayOfItem[k-1].genders {
                                        if type == "female"
                                        {
                                            j = j + 1
                                        }
                                    }
                                    
                                }
                                return j
                                break
                            }
                        }
                    }
                }
                return 0
            }
            
        }
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  indexPath.item  == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingSubHeadingCollectionViewCell", for: indexPath) as! PricingSubHeadingCollectionViewCell
            if indexPath.section == 0 {
                cell.menItems.text = "Male Items"
            }
            else  {
                cell.menItems.text = "Female Items"
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPriceListCollectionViewCell", for: indexPath) as! ItemPriceListCollectionViewCell
            var count =  serviceModel?.data?.count
            if let count = count ,count > 0 {
                for i in 0...count-1 {
                    if let arrayOfservices = serviceModel?.data
                    {
                        if arrayOfservices[i].alias == "shoe-repair"
                        {
                            if let arrayOfItem = arrayOfservices[i].items{
                                if indexPath.section == 0 {
                                    let maleModel = arrayOfItem.filter { (itemModel) -> Bool in
                                        if let garment = itemModel.gender, garment == "male" {
                                            return true
                                        }else {
                                            return false
                                        }
                                    }
                                    cell.label.text = maleModel[indexPath.item - 1].name
                                    if let price = maleModel[indexPath.item - 1].price {
                                        cell.labelPrice.text = "$\(price)"
                                    }
                                    
                                    
                                }
                                else   {
                                    let maleModel = arrayOfItem.filter { (itemModel) -> Bool in
                                        if let garment = itemModel.gender, garment == "female" {
                                            return true
                                        }else {
                                            return false
                                        }
                                    }
                                    cell.label.text = maleModel[indexPath.item - 1].name
                                    if let price = maleModel[indexPath.item - 1].price {
                                        cell.labelPrice.text = "$\(price)"
                                    }
                                    
                                    
                                }
                                return cell
                            }
                        }
                    }
                    
                }
            }
            return cell
        }
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



