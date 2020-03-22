//
//  PickDateAndTimeViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView

class PickDateAndTimeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var pickDateandTimeScreenCollectionView: UICollectionView!
    var cartModel : CartModel?
    var selectedDateIndex = IndexPath(item: 0, section: 0)
    var selectedSlotIndexPath = IndexPath(item: 0, section: 0)
    @IBAction func pickDeliverySlot(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let dropVC = SB.instantiateViewController(withIdentifier: "PickDeliveryTimeSlotsViewController") as! PickDeliveryTimeSlotsViewController
        dropVC.cartModel = cartModel
        let validDates = fetchValidPickupDates() // an array of dates
        let date = validDates[selectedDateIndex.item]
        let validSlots = fetchSlots(forDate: date)
        let currentSlot = validSlots[selectedSlotIndexPath.item]
        dropVC.selectedPickupSlot = currentSlot// this line is sending  the selected date and time slot to the drop off screen.
        NavigationManager.shared.push(viewController: dropVC)
        Events.selectedPickup()
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        pickDateandTimeScreenCollectionView.delegate = self
        pickDateandTimeScreenCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    //MARK:UI Methods
    func registerCells() {
        let PickUpDropServiveNameAndTatTimeCollectionViewCellNib = UINib(nibName: "PickUpDropServiveNameAndTatTimeCollectionViewCell", bundle: nil)
        pickDateandTimeScreenCollectionView.register(PickUpDropServiveNameAndTatTimeCollectionViewCellNib, forCellWithReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell")
        
        let MonthAndDateBaseCollectionViewCellNib = UINib(nibName: "MonthAndDateBaseCollectionViewCell", bundle: nil)
        pickDateandTimeScreenCollectionView.register(MonthAndDateBaseCollectionViewCellNib, forCellWithReuseIdentifier: "MonthAndDateBaseCollectionViewCell")
        
        let TimeSlotsCollectionViewCellNib = UINib(nibName: "TimeSlotsCollectionViewCell", bundle: nil)
        pickDateandTimeScreenCollectionView.register(TimeSlotsCollectionViewCellNib, forCellWithReuseIdentifier: "TimeSlotsCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell", for: indexPath) as! PickUpDropServiveNameAndTatTimeCollectionViewCell
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthAndDateBaseCollectionViewCell", for: indexPath) as! MonthAndDateBaseCollectionViewCell
            cell.selectedIndexPath = selectedDateIndex
            cell.currentIndexPath = indexPath
            cell.dates = fetchValidPickupDates()
            cell.delegate = self
            cell.monthandDatecollectionView.reloadData()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
            cell.selectedDateIndexPath = selectedDateIndex // which date the useer has chosen....through this the tme slots will be made
            cell.selectedIndexPath = selectedSlotIndexPath
            cell.cartModel = cartModel
            cell.dates = fetchValidPickupDates()
            cell.delegate = self
            cell.timecollectionView.reloadData()
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


extension PickDateAndTimeViewController: TimeSlotsCollectionViewCellDelegate {
    func selectedTimeSlot(forIndexPath indexPath:IndexPath?, withTimeSlotIndexPath slotIndexPath:IndexPath?) {
        if let slotIndexPath = slotIndexPath {
            selectedSlotIndexPath = slotIndexPath
        }
        pickDateandTimeScreenCollectionView.reloadData()
    }
}

extension PickDateAndTimeViewController: MonthAndDateBaseCollectionViewCellDelegate {
    func selectedDate(forIndexPath indexPath: IndexPath?, withDateIndexPath dateIndexPath: IndexPath?) {
        if let dateIndexPath = dateIndexPath {
            selectedDateIndex = dateIndexPath
            selectedSlotIndexPath = IndexPath(item: 0, section: 0)  // to make first time slot green when we are changing the date.
        }
        pickDateandTimeScreenCollectionView.reloadData()
    }
}
