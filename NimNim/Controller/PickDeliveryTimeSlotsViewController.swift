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
    
    var deliverySelections : Bool = true
    var cartModel : CartModel?
    var dropOffDictionary:[String:[ServiceModel]] = [:]
    var sortedDropKeys:[String] = []
    var selectedPickupSlot:Date?
    var selectedDateIndexPaths:[IndexPath] = []
    var selectedSlotIndexPaths:[IndexPath] = []
    
    @IBOutlet weak var PickDeliveryTimeSlotsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        PickDeliveryTimeSlotsCollectionView.delegate = self
        PickDeliveryTimeSlotsCollectionView.dataSource = self
        setupDropOffDictionary()
    }
    
    func setupDropOffDictionary() {
        if let services = cartModel?.services {
            if let serviceDict = Dictionary(grouping: services, by: {$0.finalTurnaroundTime}) as? [String:[ServiceModel]] {
                //the final type of this dictionary is Key - String, Value - array of service models... hence [String:[ServiceModel]]
                self.dropOffDictionary = serviceDict
                print(serviceDict) // ["24": [<NimNim.ServiceModel: 0x7fb08111e910>, <NimNim.ServiceModel: 0x7fb08111ec30>], "12": [<NimNim.ServiceModel: 0x7fb08111e780>, <NimNim.ServiceModel: 0x7fb08111eaa0>, <NimNim.ServiceModel: 0x7fb08111edc0>]]
                self.sortedDropKeys = serviceDict.keys.sorted() //  this will give us an array of keys of the above dictionary such that they are sorted... we will use the keys of this array to show the sections sorted by turnaround time... ["12","24"]
            }
        }
        for _ in 0 ..< sortedDropKeys.count {
            selectedDateIndexPaths.append(IndexPath(item: 0, section: 0))
            selectedSlotIndexPaths.append(IndexPath(item: 0, section: 0))
        }
    }
    
    
    @IBAction func selectPaymentTapped(_ sender: Any) {
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let DropVC = SB.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        DropVC.cartModel = cartModel
        NavigationManager.shared.push(viewController: DropVC)
    }
    
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        return sortedDropKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let turnAroundTimeOfSection = sortedDropKeys[indexPath.section]
        let arrayOfServiceModelOfSection = dropOffDictionary[turnAroundTimeOfSection]
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell", for: indexPath) as! PickUpDropServiveNameAndTatTimeCollectionViewCell
            if let arrayOfServiceModelOfSection = arrayOfServiceModelOfSection {
                //Map function is looping over all the elements of c and $0 represents the service model that is currently in iteration...so we are basically creating an array of name properties of all the service models inside arrayOfServiceModelOfSection...
                if let arrayOfServiceNamesInThisSection = arrayOfServiceModelOfSection.map ({$0.name}) as? [String] {
                    print(arrayOfServiceNamesInThisSection)
                    let servicesString = arrayOfServiceNamesInThisSection.joined(separator: ", ")
                    cell.label.text = "Drop Off date and time slot for \(servicesString). Only available after \(turnAroundTimeOfSection) hours."
                }
            }
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthAndDateBaseCollectionViewCell", for: indexPath) as! MonthAndDateBaseCollectionViewCell
            cell.selectedIndexPath = selectedDateIndexPaths[indexPath.section]
            cell.currentIndexPath = indexPath
            if let selectedPickupSlot = selectedPickupSlot, let turnAroundTime = Int(turnAroundTimeOfSection) {
                cell.dates = fetchValidDropOffDates(withInitialDate: selectedPickupSlot, withTurnaroundTimeInHr: turnAroundTime)
            }
            cell.delegate = self
            cell.monthandDatecollectionView.reloadData()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
            cell.selectedDateIndexPath = selectedDateIndexPaths[indexPath.section] // which date the useer has chosen....through this the tme slots will be made
            cell.currentIndexPath = indexPath
            cell.selectedIndexPath = selectedSlotIndexPaths[indexPath.section]
            if let selectedPickupSlot = selectedPickupSlot, let turnAroundTime = Int(turnAroundTimeOfSection) {
                cell.dates = fetchValidDropOffDates(withInitialDate: selectedPickupSlot, withTurnaroundTimeInHr: turnAroundTime)
            }
            cell.delegate = self
            cell.timecollectionView.reloadData()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: self.view.frame.width, height:90)
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

extension PickDeliveryTimeSlotsViewController: MonthAndDateBaseCollectionViewCellDelegate  {
    func selectedDate(forIndexPath indexPath: IndexPath?, withDateIndexPath dateIndexPath: IndexPath?) {
        if let currentIndexPath = indexPath, let dateIndexPath = dateIndexPath  {
            selectedDateIndexPaths[currentIndexPath.section] = dateIndexPath
            PickDeliveryTimeSlotsCollectionView.reloadData()
        }
    }
}

extension PickDeliveryTimeSlotsViewController: TimeSlotsCollectionViewCellDelegate {
    func selectedTimeSlot(forIndexPath indexPath: IndexPath?, withTimeSlotIndexPath slotIndexPath: IndexPath?) {
        if let currentIndexPath = indexPath, let slotIndexPath = slotIndexPath  {
            selectedSlotIndexPaths[currentIndexPath.section] = slotIndexPath
            PickDeliveryTimeSlotsCollectionView.reloadData()
        }
    }
}
