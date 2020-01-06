//
//  MonthAndDateBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/12/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
protocol MonthAndDateBaseCollectionViewCellDelegate:class {
    func selectedDate(forIndexPath indexPath:IndexPath?, withDateIndexPath dateIndexPath:IndexPath?)
}

class MonthAndDateBaseCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var deliverySelections : Bool = false
    var selectedIndexPath:IndexPath? = IndexPath(item: 0, section: 0) // iske andar
    var currentIndexPath:IndexPath? // agli screen ke andar yeh sections repeat honge.
    var second  : Bool = false
    var dateFormatter = DateFormatter()///date related
    var dates:[Date] = []
    
    weak var delegate:MonthAndDateBaseCollectionViewCellDelegate?
    
    @IBOutlet weak var monthandDatecollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        monthandDatecollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        registerCells()
        monthandDatecollectionView.delegate = self
        monthandDatecollectionView.dataSource = self
        dateFormatter.dateFormat = "dd MMM YYYY" ///date related
        // Initialization code
    }
    func registerCells() {
        let DateTimeCollectionViewCellNib = UINib(nibName: "DateTimeCollectionViewCell", bundle: nil)
        monthandDatecollectionView.register(DateTimeCollectionViewCellNib, forCellWithReuseIdentifier: "DateTimeCollectionViewCell")
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count  //  no of cells will be the no of pickup dates. ///date related
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateTimeCollectionViewCell", for: indexPath) as! DateTimeCollectionViewCell
        let pickupDates = dates /// date related
        let date = pickupDates[indexPath.item] /// date related
        cell.dateLabel.text = dateFormatter.string(from: date) /// date related
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                cell.configureCell(forSelectedState:true)
            }else {
                cell.configureCell(forSelectedState:false)
            }
        } else  {
            cell.configureCell(forSelectedState:false)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath // 3 cell
        monthandDatecollectionView.reloadData() //  to make it green
        delegate?.selectedDate(forIndexPath: currentIndexPath, withDateIndexPath: indexPath)
        DispatchQueue.main.async {[weak self] in
            if let selectedDateIndexPath = self?.selectedIndexPath {
                self?.monthandDatecollectionView.scrollToItem(at: selectedDateIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
}

