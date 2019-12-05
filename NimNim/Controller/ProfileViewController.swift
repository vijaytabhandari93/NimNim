//
//  ProfileViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 17/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var noOfSavedCards : Int = 0
    var noOfSavedAdderess : Int = 0
    var selectedCard : Bool = false
    var selectedAddress : Bool = false
    var walletBalance : Int?
    var cardBaseModel : CardModel?
    var addressBaseModel : AddressModel?
    
    @IBAction func editTapped(_ sender: Any) {
    }
    var isFirstSectionSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        registerCells()
        fetchWalletPoints()
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    
    //Networking Call
    func fetchSavedCards(){
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallcard, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let cardBaseModel = Mapper<CardModel>().map(JSON: responseDict)
                self?.cardBaseModel = cardBaseModel //? is put after self as it is weak self.
                if let count = cardBaseModel?.data?.count {
                    self?.noOfSavedCards = count
                    
                }
                self?.profileCollectionView.reloadData()
            }
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } // definition of error closure
    }
    func fetchSavedAddress(){
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallAddrress, withParams: nil, withSuccess: {
            [weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let addressBaseModel = Mapper<AddressModel>().map(JSON: responseDict)
                self?.addressBaseModel = addressBaseModel //? is put after self as it is weak self.
                if let count = addressBaseModel?.data?.count {
                    self?.noOfSavedAdderess = count
                }
                self?.profileCollectionView.reloadData()
            }
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } // definition of error closure
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        fetchSavedCards()
        fetchSavedAddress()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        profileCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "SavedCardCollectionViewCell", bundle: nil)
        profileCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "SavedCardCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "ReferAFriendCollectionViewCell", bundle: nil)
        profileCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "ReferAFriendCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "SavedCardExpandedStateCollectionViewCell", bundle: nil)
        profileCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateCollectionViewCell")
        
        let type5PreferencesNib = UINib(nibName: "SavedCardExpandedStateTwoCollectionViewCell", bundle: nil)
        profileCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell")
        let type6PreferencesNib = UINib(nibName: "SavedAddressCollectionViewCell", bundle: nil)
        profileCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "SavedAddressCollectionViewCell")
        
        let type7PreferencesNib = UINib(nibName: "AddressCollectionViewCell", bundle: nil)
        profileCollectionView.register(type7PreferencesNib, forCellWithReuseIdentifier: "AddressCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:320)
        }
        else if indexPath.section == 1 {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.size.width, height:64)
            }
            else {
                if noOfSavedCards > 0 {
                    return CGSize(width: collectionView.frame.size.width, height:257)
                }
                else{
                    return CGSize(width: collectionView.frame.size.width, height:280)
                }
            }
            
        }
        else if indexPath.section == 2 {
            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
            if indexPath.item == 0
            {
                return CGSize(width: collectionView.frame.size.width, height:64)
            }else if indexPath.item == (numberOfItems - 1) {
                return CGSize(width: collectionView.frame.size.width, height:64)
            }else {
                if noOfSavedAdderess > 0 {
                    return CGSize(width: collectionView.frame.size.width, height:80)
                }else {
                    return CGSize(width: collectionView.frame.size.width, height:81)
                }
            }
        }else if indexPath.section == 3{
            return CGSize(width: collectionView.frame.size.width, height:64)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
    }
    //MARK: Network Requests
    
    func fetchWalletPoints() {
        
        NetworkingManager.shared.get(withEndpoint: Endpoints.fetchwalletbalance, withParams: nil, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let walletBalance = responseDict["balance"] as? Int {
                    self.walletBalance = walletBalance
                    self.profileCollectionView.reloadData()
                }
            }
            
        }) { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            if selectedCard == true{
                return 2
            }
            else{
                return 1
            }
        }
        else if section == 2 {
            if selectedAddress == true{
                if noOfSavedAdderess > 0 {
                    return 1 + noOfSavedAdderess + 1 // no of saved addresses + add address label
                }else {
                    return 2 // for state where saved address are 0.
                }
            }
            else{
                return 1   // for state where selectedAddress in not selected.
            }
        }
        else  // for refer and earn.
        {
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            if let userModel = UserModel.fetchFromUserDefaults() {
                //TODO: Add last name
                if let a = userModel.firstName , let b = userModel.lastName {
                    cell.userName.text = "\(a.capitalized) \(b.capitalized)"
                    cell.userLabel.text  = "\(a.prefix(1).capitalized) \(b.prefix(1).capitalized)"
                }
                cell.userEmailAddress.text = userModel.email
                cell.userPhoneNumber.text = userModel.phone
            }
            if let wallet = walletBalance {
                cell.userPoints.text = "\(wallet)"
            }
            return cell
        }
        else if indexPath.section == 1 {
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
                cell.savedLabel.text = "Saved Cards"
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
        else if indexPath.section == 2 {
            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
                cell.savedLabel.text = "Saved Address"
                if selectedAddress == true {
                    cell.configureCell(withExpandedState: true)
                    if let number = addressBaseModel?.data?.count, number > 0
                    {
                        if number == 1 {
                            cell.subTitleLabel.text = "You currrently have \(1) saved address"
                        }else {
                            cell.subTitleLabel.text = "You currrently have \(number) saved addresses"
                        }
                    }else {
                        cell.subTitleLabel.text = "You currrently have \(0) saved addresses"
                    }
                }else {
                    cell.configureCell(withExpandedState: false)
                }
                return cell
                
            }else if indexPath.item == (numberOfItems - 1) {
                let savedAddressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedAddressCollectionViewCell", for: indexPath) as! SavedAddressCollectionViewCell
                return savedAddressCell
            }else {
                if noOfSavedAdderess > 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressCollectionViewCell", for: indexPath) as! AddressCollectionViewCell
                    let addressIndex = indexPath.item - 1
                    cell.titleLabel.text = self.addressBaseModel?.data?[addressIndex].label?.capitalized
                    var finalAddressString = ""
                    if let house = self.addressBaseModel?.data?[addressIndex].house, house.count > 0 {
                        finalAddressString = house
                    }
                    if let street = self.addressBaseModel?.data?[addressIndex].street, street.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(street)"
                        }else {
                            finalAddressString = street
                        }
                    }
                    if let area = self.addressBaseModel?.data?[addressIndex].area, area.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(area)"
                        }else {
                            finalAddressString = area
                        }
                    }
                    if let landmark = self.addressBaseModel?.data?[addressIndex].landmark, landmark.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(landmark)"
                        }else {
                            finalAddressString = landmark
                        }
                    }
                    if let city = self.addressBaseModel?.data?[addressIndex].city, city.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(city)"
                        }else {
                            finalAddressString = city
                        }
                    }
                    if let state = self.addressBaseModel?.data?[addressIndex].state, state.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(state)"
                        }else {
                            finalAddressString = state
                        }
                    }
                    if let pincode = self.addressBaseModel?.data?[addressIndex].pincode, pincode.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(pincode)"
                        }else {
                            finalAddressString = pincode
                        }
                    }
                    if let phone = self.addressBaseModel?.data?[addressIndex].phone, phone.count > 0 {
                        if finalAddressString.count > 0 {
                            finalAddressString = "\(finalAddressString), \(phone)"
                        }else {
                            finalAddressString = phone
                        }
                    }
                    cell.subTitleLabel.text = finalAddressString
                    return cell
                }
                    
                else {
                    let noAdresssCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell", for: indexPath) as! SavedCardExpandedStateTwoCollectionViewCell
                    return noAdresssCell
                }
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReferAFriendCollectionViewCell", for: indexPath) as! ReferAFriendCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.item == 0 {
            selectedCard = !selectedCard
        }
            
        else if indexPath.section == 2 && indexPath.item == 0 {
            selectedAddress = !selectedAddress
        }
        profileCollectionView.reloadData()
    }
    
    
    
}

