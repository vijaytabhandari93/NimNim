//
//  TimeSlotsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class TimeSlotsCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var  deliverySelections : Bool = false
    var selectedIndexPath  : IndexPath?
    @IBOutlet weak var timecollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timecollectionView.contentInset = UIEdgeInsets(top: 5, left:28 , bottom: 5, right: 28)
        registerCells()
        timecollectionView.delegate = self
        timecollectionView.dataSource = self
        // Initialization code
    }
    func registerCells() {
        let TimeCollectionViewCellNib = UINib(nibName: "TimeCollectionViewCell", bundle: nil)
        timecollectionView.register(TimeCollectionViewCellNib, forCellWithReuseIdentifier: "TimeCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                let savedtime = cell.timeLabel
                if deliverySelections == false {
                    UserDefaults.standard.set(savedtime,forKey: UserDefaultKeys.timeSlotSelected)
                }
                else
                {
                    UserDefaults.standard.set(savedtime,forKey: UserDefaultKeys.deliverytimeSlotSelected)
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
        timecollectionView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewContentWidth = UIScreen.main.bounds.width-28-28
        return CGSize(width:(collectionViewContentWidth-10)/2, height: 38)
    
    }
    }



