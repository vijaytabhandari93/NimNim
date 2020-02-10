//
//  WalletViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 10/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher

class WalletViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
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
  
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        { if indexPath.item == 0  {
            return CGSize(width: collectionView.frame.size.width, height:84)
        }
        else   {
            return CGSize(width: collectionView.frame.size.width, height:88)
        }
        
        }
        
        
        //MARK:Collection View Datasource Methods
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 3
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                if indexPath.item == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PricingHeaderCollectionViewCell", for: indexPath) as! PricingHeaderCollectionViewCell
                 return cell
                }
               
                else
                { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
                    cell.label.text = "Delivered within 24 hours, Rush service Available "
                    return cell
                }
                
        
        
}
    
}
