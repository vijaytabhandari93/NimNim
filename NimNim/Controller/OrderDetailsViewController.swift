//
//  OrderDetailsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import NVActivityIndicatorView

class OrderDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var service : [ServiceModel]?
    
    //MARK:Gradient Setting
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           applyHorizontalNimNimGradient()
       }
    
    @IBOutlet weak var orderDetailsCollectionView: UICollectionView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeTapped(_ sender: Any) {
    }
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailsCollectionView.delegate =  self
        orderDetailsCollectionView.dataSource = self
        registerCells()
      
    }
    



  
    //MARK:UI Methods
       func registerCells() {
           let type1PreferencesNib = UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        
    }
//IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let service = service {
             return service.count
        }
       return 0
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! OrderDetailsCollectionViewCell
        if let serviceItem = service?[indexPath.item] {
            cell.serviceName.text = serviceItem.name
            if let pickupTime = serviceItem.pickUpTime, let pickupDate = serviceItem.pickupDate {
                cell.pickUpTimeSlotDate.text = "\(pickupTime)  \(pickupDate)"
            }
            if let dropOffTime = serviceItem.dropOffTime, let dropOffDate = serviceItem.dropOffDate {
                cell.dropOffGTimeSlotDate.text = "\(dropOffTime)  \(dropOffDate)"
            }
            cell.amountPayable.text = "To be calculated"
            cell.noOfProducts.text = "Total Items: \(serviceItem.productQuantity())"
        }
       return cell
        
       }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height:135)
        }
       

}
