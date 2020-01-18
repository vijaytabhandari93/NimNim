//
//  OrderStatusViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import NVActivityIndicatorView


class OrderStatusViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var trackOrderCollectionViiew: UICollectionView!
  

    var orderArrayModel : OrderBaseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        trackOrderCollectionViiew.delegate =  self
        trackOrderCollectionViiew.dataSource = self
        registerCells()
        fetchOrderHistory()
       
        // Do any additional setup after loading the view.
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    func fetchOrderHistory() {
 
        NetworkingManager.shared.get(withEndpoint: Endpoints.orderhistory, withParams: nil, withSuccess: {[weak self] (response) in
            if let responseDict = response as? [[String:Any]]{
                let dict = ["data":responseDict]
                print(responseDict)
                let orderModel = Mapper<OrderBaseModel>().map(JSON: dict)
                self?.orderArrayModel = orderModel //? is put after self as it is weak self.
                self?.trackOrderCollectionViiew.reloadData()
            }
   
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
          
        }
    }
    
    //MARK:UI Methods
       func registerCells() {
           let type1PreferencesNib = UINib(nibName: "OrderNumberCollectionViewCell", bundle: nil)
        trackOrderCollectionViiew.register(type1PreferencesNib, forCellWithReuseIdentifier: "OrderNumberCollectionViewCell")
        
    }
//IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = orderArrayModel?.data
        {
           return model.count
        }
        return 0
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderNumberCollectionViewCell", for: indexPath) as! OrderNumberCollectionViewCell
       
        if let arrayItem = orderArrayModel?.data?[indexPath.item]
        {
            if let number = arrayItem.orderNumber
        {
                   cell.orderNumber.text =  "\(number)"
        }
            cell.orderStatus.text = arrayItem.orderStatus
            cell.service = arrayItem.services
            cell.date.text = arrayItem.date
            return cell
        }
        
       return  cell
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height:121)
        }
       

}
