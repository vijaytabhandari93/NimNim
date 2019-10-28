//
//  OrderReviewViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class OrderReviewViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var orderStatusCollectionView: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   registerCells()
    orderStatusCollectionView.delegate = self
    orderStatusCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func selectAddressTapped(_ sender: Any) {
        
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let selectAddressVC = orderSB.instantiateViewController(withIdentifier: "SelectAddressViewController")
        NavigationManager.shared.push(viewController: selectAddressVC)
    }
   
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "ServiceOrderStatusCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ServiceOrderStatusCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "DoYouHaveACouponCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "DoYouHaveACouponCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "ApplyWalletPointsCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "ApplyWalletPointsCollectionViewCell")
        
        
        let headerNib = UINib(nibName: "ShoppingbagSummaryCollectionReusableView", bundle: nil)
        orderStatusCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ShoppingbagSummaryCollectionReusableView")
        
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item <= 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceOrderStatusCollectionViewCell", for: indexPath) as! ServiceOrderStatusCollectionViewCell
          return cell
        }else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoYouHaveACouponCollectionViewCell", for: indexPath) as! DoYouHaveACouponCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyWalletPointsCollectionViewCell", for: indexPath) as! ApplyWalletPointsCollectionViewCell
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item <= 1 {
            return CGSize(width: collectionView.frame.size.width, height:120)
        }
        else if indexPath.item == 2
        {
            return CGSize(width: collectionView.frame.size.width, height:96)
        }
        else {
            return CGSize(width: collectionView.frame.size.width, height:149)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 83)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShoppingbagSummaryCollectionReusableView", for: indexPath) as! ShoppingbagSummaryCollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            
            let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
            let applyCouponVC = SB.instantiateViewController(withIdentifier: "CouponsViewController")
            NavigationManager.shared.push(viewController: applyCouponVC)
            
        }
        
    }
}
