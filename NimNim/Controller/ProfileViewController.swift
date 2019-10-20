//
//  ProfileViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 17/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //IBOutlets
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var noOfSavedCards : Int = 5
    var noOfSavedAdderess : Int = 4
    var selectedCard : Bool = false
    var selectedAddress : Bool = false
    
    
    @IBAction func editTapped(_ sender: Any) {
    }
    var isFirstSectionSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerCells()
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
        
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
                if noOfSavedCards != 0 {
                    return CGSize(width: collectionView.frame.size.width, height:257)
                }
                else{
                    return CGSize(width: collectionView.frame.size.width, height:320)
                }
            }
            
        }
        else if indexPath.section == 2 {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.size.width, height:64)
            }
            else {
                if noOfSavedCards != 0 {
                    return CGSize(width: collectionView.frame.size.width, height:257)
                }
                else{
                    return CGSize(width: collectionView.frame.size.width, height:320)
                }
            }
            
        }
        else  {
            return CGSize(width: collectionView.frame.size.width, height:64)
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
            if selectedCard == true
            {
                return 2
            }
            else
            { return 1
            }
        }
        else if section == 2 {
            if selectedAddress == true
            {
                return 2
            }
            else
            {return 1
            }
        }
        else
        { return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            return cell
        }
        else if indexPath.section == 1 {
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
                cell.savedLabel.text = "Saved Cards"
                return cell
                
            }
            else  {
                if noOfSavedCards > 0
                {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell", for: indexPath) as! SavedCardExpandedStateTwoCollectionViewCell
                    cell.titleLable.text = "You have \(noOfSavedCards) saved cards"
                    cell.noOfCards = noOfSavedCards
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
            if indexPath.item == 0
            { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
                       cell.savedLabel.text = "Saved Address"
                return cell
                
            }
            else  {
                if noOfSavedAdderess > 0
                {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedAddressCollectionViewCell", for: indexPath) as! SavedAddressCollectionViewCell
                    cell.addressLabel.text = "You have \(noOfSavedAdderess) saved address"
                    return cell
                    
                }
                else
                {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateCollectionViewCell", for: indexPath) as! SavedCardExpandedStateCollectionViewCell
                                cell.missingLabel.text = "No addresses"
                    return cell
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

