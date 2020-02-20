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
    
    var dateOfOrderCreation : String?
    var orderArrayModel : OrderBaseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        trackOrderCollectionViiew.delegate =  self
        trackOrderCollectionViiew.dataSource = self
        trackOrderCollectionViiew.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
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
               print(JSON(dict))
                let orderModel = Mapper<OrderBaseModel>().map(JSON: dict)
                self?.orderArrayModel = orderModel //? is put after self as it is weak self.
                print(self?.orderArrayModel?.toJSON())
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
            
            if let price = arrayItem.orderAmount {
                cell.price = "$\(price)"
            }
            
            if let address = arrayItem.addressId
                       {
                        cell.address = address
                       }
            if let cardId = arrayItem.CardId
                                 {
                                  cell.cardId = cardId
                                 }
            cell.orderModel = arrayItem
            if let date = arrayItem.createdAt
            {
                print(date)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let finalDate = dateFormatter.date(from:date) {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month,.day], from: finalDate)
                    if let DateTobeShown = calendar.date(from:components){
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM, YYYY"
                        cell.date.text = formatter.string(from: DateTobeShown)
                        print(formatter.string(from: DateTobeShown))
                        self.dateOfOrderCreation = formatter.string(from: DateTobeShown)
                    }
                    
                    
                }
                
            }
            cell.orderStatus.text = arrayItem.orderStatus
            cell.service = arrayItem.services
            return cell
        }
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:121)
    }
    
    
}
