//
//  ServicesBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 03/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

//
//  BannersBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ServicesBaseCollectionViewCell : UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var serviceBannerCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceBannerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        registerCells()
        serviceBannerCollectionView.delegate = self
        serviceBannerCollectionView.dataSource = self
    }
    
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "ServiceCollectionViewCell", bundle: nil)
        serviceBannerCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "ServiceCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        if indexPath.row == 0 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
        }
        else{
            cell.backgroundCurvedView.backgroundColor = Colors.nimnimServicesGreen
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 228)
        
    }
}

