//
//  TimeSlotsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

protocol TimeSlotsCollectionViewCellDelegate:class {
    func selectedTimeSlot(forIndexPath indexPath:IndexPath?, withTimeSlotIndexPath slotIndexPath:IndexPath?)
}

class TimeSlotsCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var  deliverySelections : Bool = false
    var selectedIndexPath:IndexPath? = IndexPath(item: 0, section: 0)
    var cartModel : CartModel?
    var second  : Bool = false
    var selectedDateIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    var currentIndexPath:IndexPath?
    var dates:[Date] = []
    weak var delegate:TimeSlotsCollectionViewCellDelegate?
    
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
        if dates.count > selectedDateIndexPath.item {
            let validDates = dates // an array of dates
            let date = validDates[selectedDateIndexPath.item] // pcking each date item
            let validSlots = fetchSlots(forDate: date)
            return validSlots.count //  valid slot is the array containing the possible time slots of that date
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        let validDates = dates // an array of dates
        let date = validDates[selectedDateIndexPath.item]
        let validSlots = fetchSlots(forDate: date)
        let currentSlot = validSlots[indexPath.item]
        cell.timeLabel.text = slotString(forDateSlot: currentSlot)
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                cell.configureCell(forSelectedState:true)
            }else {
                cell.configureCell(forSelectedState:false)
            }
        }else {
            cell.configureCell(forSelectedState:false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
        delegate?.selectedTimeSlot(forIndexPath: currentIndexPath, withTimeSlotIndexPath: indexPath)
        DispatchQueue.main.async {[weak self] in
            if let selectedIndexPath = self?.selectedIndexPath {
                self?.timecollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewContentWidth = UIScreen.main.bounds.width-28-28
        return CGSize(width:(collectionViewContentWidth-10)/2, height: 38)
    }
}



