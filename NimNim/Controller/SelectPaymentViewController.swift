//
//  SelectPaymentViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import SwiftyJSON


class SelectPaymentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SavedCardExpandedStateTwoCollectionViewCellDelegate2{
    
    
    //IBOutlets
    @IBOutlet weak var selectPaymentCollectionView: UICollectionView!
    var cardBaseModel : CardModel?
    var cartModel : CartModel?
    var noOfSavedCards : Int = 1// initially
    var selectedCard = true
    var selectedPickupSlot:Date?//
    var selectedDateIndexPaths:[IndexPath] = []//
    var selectedSlotIndexPaths:[IndexPath] = []
    var sortedDropKeys:[String] = []
    var dropOffDictionary:[String:[ServiceModel]] = [:]
    var dateFormatterForDate = DateFormatter()
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForPUDODates = DateFormatter()
    var Index : IndexPath?
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterForDate.dateFormat = "yyyy-MM-dd"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.timeZone = .current
        dateFormatterForTime.dateFormat = "ha"
        dateFormatterForTime.timeZone = .current
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForPUDODates.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForPUDODates.dateFormat = "yyyy-MM-dd"//ashish
        fetchSavedCards()
        registerCells()
        selectPaymentCollectionView.delegate = self
        selectPaymentCollectionView.dataSource = self
    }
    //IBActions
    
    func cardSelectedChangeUI(withIndexPath indexPath: IndexPath?) {
        if let indexPath = indexPath {
            Index = indexPath // setting of Index
            if let data = cardBaseModel?.data,data.count > indexPath.item {
                if let cardId = data[indexPath.item].id  {
                    UserDefaults.standard.set(cardId, forKey: UserDefaultKeys.savedCardId)
                }
            }
            selectPaymentCollectionView.reloadData()
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if let savedCard = cartModel?.CardId {
            if let cartModel = cartModel {
                setupPickupDateTimeInServices()
                setupDropOffDateTimeInServices()
                var modelToDictionary = cartModel.toJSON()
                print(JSON(modelToDictionary))
                activityIndicator.startAnimating()
                Events.selectedPayment()
                Events.placedOrder()
                NetworkingManager.shared.post(withEndpoint: Endpoints.order, withParams: modelToDictionary, withSuccess: { (response) in
                    if let responseDict = response as? [String:Any] {
                        print("success")
                        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                        let placeOrderVC = SB.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController") as! OrderSuccessFailureViewController
                        placeOrderVC.actualOrderStatus = "success"
                        NavigationManager.shared.push(viewController: placeOrderVC)
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: UserDefaultKeys.cartId)
                        defaults.removeObject(forKey: UserDefaultKeys.cartAlias)
                        
                    }
                    Events.orderSuccess()
                    self.activityIndicator.stopAnimating()
                    
                }) { (error) in
                    self.activityIndicator.stopAnimating()
                    if let error = error as? String {
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: UserDefaultKeys.cartId)
                        defaults.removeObject(forKey: UserDefaultKeys.cartAlias)
                        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                        let placeOrderVC = SB.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController") as! OrderSuccessFailureViewController
                        placeOrderVC.actualOrderStatus = "fail"
                        NavigationManager.shared.push(viewController: placeOrderVC)
                        
                        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    Events.orderFailure()
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "please select the card", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func setupPickupDateTimeInServices() {
        if let pickupDate = selectedPickupSlot {
            let date = dateFormatterForDate.string(from: pickupDate)
            let time = dateFormatterForTime.string(from: pickupDate)
            var pickupEndTime = ""
            if let finalEndPUDate = dateValue(byaddingHours: 2, toDate: pickupDate) {
                pickupEndTime = dateFormatterForTime.string(from: finalEndPUDate)
            }
            let finalTimeString = time + " - " + pickupEndTime
            if let services = cartModel?.services {
                for service in services {
                    service.pickupDate = date
                    service.pickUpTime = finalTimeString
                }
            }
        }
    }
    
    func setupDropOffDateTimeInServices() {
        if let pickupDate = selectedPickupSlot {
            for i in 0 ..< sortedDropKeys.count {
                let key = sortedDropKeys[i]
                let arrayOfServices = dropOffDictionary[key]
                if let turnaroundTime = Int(key) {
                    let dates = fetchValidDropOffDates(withInitialDate: pickupDate, withTurnaroundTimeInHr: turnaroundTime)
                    let selectedDate = dates[selectedDateIndexPaths[i].item]
                    let slots = fetchSlots(forDate: selectedDate)
                    let selectedSlot = slots[selectedSlotIndexPaths[i].item]
                    let date = dateFormatterForDate.string(from: selectedSlot)
                    let time = dateFormatterForTime.string(from: selectedSlot)
                    
                    var dropOffEndTime = ""
                    if let finalEndDODate = dateValue(byaddingHours: 2, toDate: selectedSlot) {
                        dropOffEndTime = dateFormatterForTime.string(from: finalEndDODate)
                    }
                    let finalTimeString = time + " - " + dropOffEndTime

                    if let services = arrayOfServices {
                        for service in services  {
                            if let cartServices = cartModel?.services {
                                for cartService in cartServices {
                                    if service.alias == cartService.alias {
                                        cartService.dropOffDate = date
                                        cartService.dropOffTime = finalTimeString
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
        
    }
    func fetchSavedCards(){
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallcard, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let cardBaseModel = Mapper<CardModel>().map(JSON: responseDict)
                self?.cardBaseModel = cardBaseModel //? is put after self as it is weak self.
                if let count = cardBaseModel?.data?.count {
                    self?.noOfSavedCards = count
                }
                if self?.Index == nil {
                                   if let data = cardBaseModel?.data, let savedCardId = UserDefaults.standard.string(forKey: UserDefaultKeys.savedCardId) {
                                       let i = data.firstIndex { (cardModel) -> Bool in
                                           return cardModel.id == savedCardId
                                       }
                                       if let val = i {
                                           self?.Index = IndexPath(item: val, section: 0)
                                           self?.cartModel?.CardId = savedCardId
                                       }
                                   }
                               }
                self?.selectPaymentCollectionView.reloadData()
            }
            self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        self.activityIndicator.stopAnimating()
        // definition of error closure
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SavedCardCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SavedCardCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "SavedCardExpandedStateTwoCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "SavedCardExpandedStateCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateCollectionViewCell")
        
    }
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0
        { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
            cell.savedLabel.text = "Saved Cards"
            cell.arrowImageView.isHidden  =  true
            if selectedCard == true {
                cell.configureCell(withExpandedState: true)
                if let number = cardBaseModel?.data?.count, number > 0
                {
                    if number == 1 {
                        cell.subTitleLabel.text = "You currrently have \(1) saved card"
                    }else {
                        cell.subTitleLabel.text = "You currrently have \(number) saved cards"
                    }
                }else {
                    cell.subTitleLabel.text = "You currrently have \(0) saved cards"
                }
            }else {
                cell.configureCell(withExpandedState: false)
            }
            return cell
        }
        else  {
            if noOfSavedCards > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell", for: indexPath) as! SavedCardExpandedStateTwoCollectionViewCell
                
                cell.noOfCards = noOfSavedCards
                cell.cardModel = cardBaseModel?.data ?? []
                cell.cardsCollectionView.reloadData()
                cell.IsDeleteToBeShown = false
                cell.cartModel = cartModel
                cell.bottomSeparator.isHidden = true
                cell.selectedIndex = Index
                cell.delegate2 = self
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateCollectionViewCell", for: indexPath) as! SavedCardExpandedStateCollectionViewCell
                cell.missingLabel.text = "No cards"
                return cell
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width:collectionView.frame.size.width , height: 50)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height: 350)
            
        }
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        fetchSavedCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
