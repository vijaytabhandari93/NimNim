//
//  PriceListViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 14/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher


class PriceListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pricingListTitlelabel: UILabel!
    
    @IBAction func windowClosed(_ sender: Any) {
           navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var priceListCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPriceListCollectionViewCell", for: indexPath) as! ItemPriceListCollectionViewCell
        return cell
    }
    
    func registerCells() {
          let bannersBaseNib = UINib(nibName: "ItemPriceListCollectionViewCell", bundle: nil)
          priceListCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "ItemPriceListCollectionViewCell")
      }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     return CGSize(width: collectionView.frame.size.width, height:58)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        priceListCollectionView.delegate =  self
        priceListCollectionView.dataSource = self
registerCells()
    }
    

}
