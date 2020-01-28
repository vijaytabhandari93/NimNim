//
//  HouseHoldItemsPriceViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper

class HouseHoldItemsPriceViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var serviceModel : ServiceBaseModel?
    
    @IBAction func crossButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var titleOfList: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  serviceModel?.data?.count
        if let count = count ,count > 0 {
            for i in 0...count {
                if let arrayOfservices = serviceModel?.data
                {
                    if arrayOfservices[i].alias == "household-items"
                    {
                        if let arrayOfItem = arrayOfservices[i].items
                        {
                            return arrayOfItem.count
                            break
                        }
                    }
                }
                
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPriceListCollectionViewCell", for: indexPath) as! ItemPriceListCollectionViewCell
        var count =  serviceModel?.data?.count
        if let count = count ,count > 0 {
            for i in 0...count-1 {
                if let arrayOfservices = serviceModel?.data
                {
                    if arrayOfservices[i].alias == "household-items"
                    {
                        if let arrayOfItem = arrayOfservices[i].items
                        {
                            cell.label.text = arrayOfItem[indexPath.item].name
                            if let price = arrayOfItem[indexPath.item].dryCleaningPrice {
                                cell.labelPrice.text = "\(price)"
                            }
                            if let price = arrayOfItem[indexPath.item].laundryPrice {
                                cell.extraPrice.text = "\(price)"
                            }
                            
                            
                            return cell
                        }
                    }
                }
                
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 20)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchServices()
        collectionView.delegate = self
        collectionView.dataSource = self
        titleOfList.text = "HouseholdItems"
    }
    
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "ItemPriceListCollectionViewCell", bundle: nil)
        collectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "ItemPriceListCollectionViewCell")
    }
    
    
    func fetchServices() {
        //activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.services, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let serviceModel = Mapper<ServiceBaseModel>().map(JSON: responseDict)
                //print(JSON(responseDict))
                self?.serviceModel = serviceModel //? is put after self as it is weak self.
                self?.collectionView.reloadData()
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
