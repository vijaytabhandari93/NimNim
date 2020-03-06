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


class TailoringPricingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            var count =  serviceModel?.data?.count
                if let count = count ,count > 0 {
                    for i in 0...count {
                        if let arrayOfservices = serviceModel?.data
                        {
                            if arrayOfservices[i].alias == "tailoring"
                            {
                                if let arrayOfItem = arrayOfservices[i].items
                                { var j = 1
                                var count = arrayOfItem.count
                                 for k in 1...count{
                                    print(count)
                                    if let type = arrayOfItem[k-1].garment {
                                        if type == "pantsandjeans"
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
        else if section == 1 {
            var count =  serviceModel?.data?.count
                if let count = count ,count > 0 {
                    for i in 0...count {
                            if let arrayOfservices = serviceModel?.data
                            {
                                if arrayOfservices[i].alias == "tailoring"
                                {
                                    if let arrayOfItem = arrayOfservices[i].items
                                    { var j = 1
                                    var count = arrayOfItem.count
                                     for k in 1...count{
                                        print(count)
                                        if let type = arrayOfItem[k-1].garment {
                                            if type == "blouse"
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
        else if section == 2 {
            var count =  serviceModel?.data?.count
                if let count = count ,count > 0 {
                    for i in 0...count {
                            if let arrayOfservices = serviceModel?.data
                            {
                                if arrayOfservices[i].alias == "tailoring"
                                {
                                    if let arrayOfItem = arrayOfservices[i].items
                                    { var j = 1
                                    var count = arrayOfItem.count
                                     for k in 1...count{
                                        print(count)
                                        if let type = arrayOfItem[k-1].garment {
                                            if type == "dress"
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
        else if section == 3 {
            var count =  serviceModel?.data?.count
                if let count = count ,count > 0 {
                    for i in 0...count {
                            if let arrayOfservices = serviceModel?.data
                            {
                                if arrayOfservices[i].alias == "tailoring"
                                {
                                    if let arrayOfItem = arrayOfservices[i].items
                                    { var j = 1
                                    var count = arrayOfItem.count
                                     for k in 1...count{
                                        print(count)
                                        if let type = arrayOfItem[k-1].garment {
                                            if type == "shirt"
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
        else if section == 4 {
            var count =  serviceModel?.data?.count
                if let count = count ,count > 0 {
                    for i in 0...count {
                            if let arrayOfservices = serviceModel?.data
                            {
                                if arrayOfservices[i].alias == "tailoring"
                                {
                                    if let arrayOfItem = arrayOfservices[i].items
                                    { var j = 1
                                    var count = arrayOfItem.count
                                     for k in 1...count{
                                        print(count)
                                        if let type = arrayOfItem[k-1].garment {
                                            if type == "shorts"
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
                                if arrayOfservices[i].alias == "tailoring"
                                {
                                    if let arrayOfItem = arrayOfservices[i].items
                                    { var j = 1
                                    var count = arrayOfItem.count
                                     for k in 1...count{
                                        print(count)
                                        if let type = arrayOfItem[k-1].garment {
                                            if type == "jacket"
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
                cell.menItems.text = "Pants/Jeans"
            }
            else if indexPath.section == 1 {
                cell.menItems.text = "Blouse"
            }
            else if indexPath.section == 2 {
                cell.menItems.text = "Dress"
                      }
            else if indexPath.section == 3 {
                cell.menItems.text = "Shirt"
                      }
            else if indexPath.section == 4 {
                cell.menItems.text = "Shorts"
                          }
            else  {
                cell.menItems.text = "Jacket"
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPriceListCollectionViewCell", for: indexPath) as! ItemPriceListCollectionViewCell
            var count =  serviceModel?.data?.count
            if let count = count ,count > 0 {
                for i in 0...count-1 {
                    if let arrayOfservices = serviceModel?.data
                    {
                        if arrayOfservices[i].alias == "tailoring"
                        {
                            if let arrayOfItem = arrayOfservices[i].items
                            {
                            cell.label.text = arrayOfItem[indexPath.item].name
                                if let price = arrayOfItem[indexPath.item].price {
                            cell.labelPrice.text = "$\(price)"
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

