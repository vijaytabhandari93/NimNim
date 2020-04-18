//
//  TrackOrderViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 18/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class TrackOrderViewController: UIViewController {

    @IBOutlet weak var trackOrderCollectionView: UICollectionView!
    var timelineModel:[TimelineModel] =  []
    var service:[ServiceModel]?
    var date :String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trackOrderCollectionView.delegate = self
        trackOrderCollectionView.dataSource = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "TrackOrderCollectionViewCell", bundle: nil)
        trackOrderCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "TrackOrderCollectionViewCell")
        let headerNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        trackOrderCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionReusableView")
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension TrackOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackOrderCollectionViewCell", for: indexPath) as! TrackOrderCollectionViewCell
        let model = timelineModel[indexPath.item]
        if indexPath.item == 0 {
            cell.configureCell(withTitle: model.service, withSubTitle: model.value, withStatusImage: "current")
        }else {
            cell.configureCell(withTitle: model.service, withSubTitle: model.value, withStatusImage: "done")
        }
        cell.topview.isHidden = false
        cell.bottomview.isHidden = false
        if indexPath.item == 0 {
            cell.topview.isHidden = true
        }else if indexPath.item == (timelineModel.count - 1) {
            cell.bottomview.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 120)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath) as! CollectionReusableView
            if let count = service?.count {
                if count == 1
                {
                    headerView.noOfItems.text = "\(count) Service"
                }else {
                    headerView.noOfItems.text = "\(count) Services"
                }
                
            }
            if let serviceItem = service?.first {
                if let pickUpTime = serviceItem.pickUpTime, let pickUpDate = serviceItem.pickupDate {
                    headerView.pickUpDateAndTime.text = "\(pickUpTime) \(pickUpDate)"
                }
            }
            headerView.trackOrderButton.isHidden = true
            headerView.orderCreatedDate.text = date
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
        
    }
    
    
}
