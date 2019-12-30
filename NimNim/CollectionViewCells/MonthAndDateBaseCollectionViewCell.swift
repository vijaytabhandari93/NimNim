//
//  MonthAndDateBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class MonthAndDateBaseCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var  deliverySelections : Bool = false
    var selectedIndexPath  : IndexPath?
    @IBOutlet weak var monthandDatecollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        monthandDatecollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        registerCells()
        monthandDatecollectionView.delegate = self
        monthandDatecollectionView.dataSource = self
        // Initialization code
    }
    func registerCells() {
        let DateTimeCollectionViewCellNib = UINib(nibName: "DateTimeCollectionViewCell", bundle: nil)
        monthandDatecollectionView.register(DateTimeCollectionViewCellNib, forCellWithReuseIdentifier: "DateTimeCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateTimeCollectionViewCell", for: indexPath) as! DateTimeCollectionViewCell
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                let savedDate = cell.dateLabel
                if deliverySelections == false {
                    UserDefaults.standard.set(savedDate,forKey: UserDefaultKeys.dateSelected)
                }
                else
                {
                    UserDefaults.standard.set(savedDate,forKey: UserDefaultKeys.deliverydateSelected)
                }
                cell.configureCell(forSelectedState:true)
            }
            else
            {
                cell.configureCell(forSelectedState:false)
            }
        } else  {
            cell.configureCell(forSelectedState:false)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        
        monthandDatecollectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
}

