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


class SelectPaymentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
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
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterForDate.dateFormat = "dd MMM YYYY"
        dateFormatterForTime.dateFormat = "hh:mm"
        dateFormatterForPUDODates.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForPUDODates.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//ashish
        fetchSavedCards()
        registerCells()
        selectPaymentCollectionView.delegate = self
        selectPaymentCollectionView.dataSource = self
    }
    //IBActions
    @IBAction func placeOrder(_ sender: Any) {
        if let savedCard = cartModel?.CardId {
            if let cartModel = cartModel {
                setupPickupDateTimeInServices()
                setupDropOffDateTimeInServices()
                var modelToDictionary = cartModel.toJSON()
                print(JSON(modelToDictionary))
                activityIndicator.startAnimating()
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
                    self.activityIndicator.stopAnimating()
                    
                }) { (error) in
                    self.activityIndicator.stopAnimating()
                    if let error = error as? String {
                        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                        let placeOrderVC = SB.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController") as! OrderSuccessFailureViewController
                        placeOrderVC.actualOrderStatus = "fail"
                        NavigationManager.shared.push(viewController: placeOrderVC)
                        
                    }
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
            let startPickupDate = dateFormatterForPUDODates.string(from: pickupDate)
            var endPickupDate:String?
            if let finalEndPUDate = dateValue(byaddingHours: 2, toDate: pickupDate) {
                endPickupDate = dateFormatterForPUDODates.string(from: finalEndPUDate)
            }
            let date = dateFormatterForDate.string(from: pickupDate)
            let time = dateFormatterForTime.string(from: pickupDate)
            if let services = cartModel?.services {
                for service in services {
                    service.pickupDate = date
                    service.pickUpTime = time
                    service.pickupStartDate = startPickupDate
                    if let endDate = endPickupDate{
                        service.pickupEndDate = endDate
                    }
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
                    let startDateForDropOff = dateFormatterForPUDODates.string(from: selectedSlot)
                    
                    var endDropOffDate:String?
                    if let finalEndPUDate = dateValue(byaddingHours: 2, toDate: selectedSlot) {
                        endDropOffDate = dateFormatterForPUDODates.string(from: finalEndPUDate)
                    }
                    if let services = arrayOfServices {
                        for service in services  {
                            if let cartServices = cartModel?.services {
                                for cartService in cartServices {
                                    if service.alias == cartService.alias {
                                        cartService.dropOffDate = date
                                        cartService.dropOffTime = time
                                        cartService.dropOffStartDate = startDateForDropOff
                                        if let endDate = endDropOffDate {
                                            cartService.dropOffEndDate = endDate
                                        }
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
            return CGSize(width:collectionView.frame.size.width , height: 64)
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
