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
    var  count : Int?
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
        
        let homeVC =  self.navigationController?.viewControllers.first(where: { (viewController) -> Bool in
            if viewController is HomeBaseViewController  {
                return true
            }else {
                return false
            }
        })
        if let homeVC = homeVC {
            self.navigationController?.popToViewController(homeVC, animated: false)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailsCollectionView.delegate =  self
        orderDetailsCollectionView.dataSource = self
        registerCells()
        
    }
    
    
    
    
    
    //MARK:UI Methods
    func registerCells() {
        let headerNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        orderDetailsCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionReusableView")
        let type2PreferencesNib = UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "OrderReviewAddressCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "OrderReviewAddressCollectionViewCell")
        let type4PreferencesNib = UINib(nibName: "OrderReviewCardCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "OrderReviewCardCollectionViewCell")
        
    }
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let service = service {
            self.count = service.count + 2
            return service.count + 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 125)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath) as! CollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == (count ?? 0) - 1{//
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderReviewCardCollectionViewCell", for: indexPath) as!
            OrderReviewCardCollectionViewCell
            return cell
        } else if indexPath.item == (count ?? 0) - 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderReviewAddressCollectionViewCell", for: indexPath) as!
            OrderReviewAddressCollectionViewCell
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! OrderDetailsCollectionViewCell
            if let serviceItem = service?[indexPath.item] {
                cell.serviceName.text = serviceItem.name
                if let dropOffTime = serviceItem.dropOffTime, let dropOffDate = serviceItem.dropOffDate {
                    cell.dropOffGTimeSlotDate.text = "\(dropOffTime)  \(dropOffDate)"
                }
                cell.amountPayable.text = "To be calculated"
                cell.noOfProducts.text = "Total Items: \(serviceItem.productQuantity())"
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == (count ?? 0) - 1{//
            return CGSize(width: collectionView.frame.size.width, height:158)
        } else if indexPath.item == (count ?? 0) - 2 {
            return CGSize(width: collectionView.frame.size.width, height:100)
        } else
        {
            return CGSize(width: collectionView.frame.size.width, height:128)
        }
        
        
}
}
