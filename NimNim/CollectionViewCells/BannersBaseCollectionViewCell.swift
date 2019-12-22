//
//  BannersBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class BannersBaseCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var bannersCollectionView: UICollectionView!
    
    var banners:[BannerModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bannersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        registerCells()
        bannersCollectionView.delegate = self
        bannersCollectionView.dataSource = self
    }
    
    func configureCell(withModel model : BannersBaseModel? ) {
        if let bannerData = model?.data {
            banners = bannerData
        }
        bannersCollectionView.reloadData()
    }
    
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "BannerCollectionViewCell", bundle: nil)
        bannersCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "BannerCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        cell.lable1.text = banners[indexPath.row].name
        cell.label2.text = banners[indexPath.row].banner
        cell.label3.text = banners[indexPath.row].id
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: 150)
        
    }
    
}
