//
//  PickDeliveryTimeSlotsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class PickDeliveryTimeSlotsViewController:
UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var  deliverySelections : Bool = true
    @IBOutlet weak var PickDeliveryTimeSlotsCollectionView: UICollectionView!
    
    @IBAction func selectPaymentTapped(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let DropVC = SB.instantiateViewController(withIdentifier: "SelectPaymentViewController")
        NavigationManager.shared.push(viewController: DropVC)
        
    }
    
    
    @IBAction func previousTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
    PickDeliveryTimeSlotsCollectionView.delegate = self
    PickDeliveryTimeSlotsCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyHorizontalNimNimGradient()
}
    
    //MARK:UI Methods
    func registerCells() {
    let PickUpDropServiveNameAndTatTimeCollectionViewCellNib = UINib(nibName: "PickUpDropServiveNameAndTatTimeCollectionViewCell", bundle: nil)
    PickDeliveryTimeSlotsCollectionView.register(PickUpDropServiveNameAndTatTimeCollectionViewCellNib, forCellWithReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell")
    
    let MonthAndDateBaseCollectionViewCellNib = UINib(nibName: "MonthAndDateBaseCollectionViewCell", bundle: nil)
    PickDeliveryTimeSlotsCollectionView.register(MonthAndDateBaseCollectionViewCellNib, forCellWithReuseIdentifier: "MonthAndDateBaseCollectionViewCell")
    
    let TimeSlotsCollectionViewCellNib = UINib(nibName: "TimeSlotsCollectionViewCell", bundle: nil)
    PickDeliveryTimeSlotsCollectionView.register(TimeSlotsCollectionViewCellNib, forCellWithReuseIdentifier: "TimeSlotsCollectionViewCell")
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0 {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell", for: indexPath) as! PickUpDropServiveNameAndTatTimeCollectionViewCell
        cell.label.text = "Pick Drop Off date and time slot for Dry Cleaning,Laundered Shirt and Air Dry. Only available after 24 hours"
   
        return cell
    }
    else if indexPath.item == 1 {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthAndDateBaseCollectionViewCell", for: indexPath) as! MonthAndDateBaseCollectionViewCell
        cell.deliverySelections = true
    return cell
    }
    else {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
         cell.deliverySelections = true
    return cell
    }
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: self.view.frame.width, height:70)
        }
        else if indexPath.item == 1
        {
            return CGSize(width: self.view.frame.width, height:70)
        }
        else
        {
            return CGSize(width: self.view.frame.width, height:260)
        }
    }

    
}
