//
//  SelectAddressViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SelectAddressViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //IBOutlets
    @IBOutlet weak var selectAddressCollectionView:UICollectionView!
    //IBActions
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func selectTimeSlots(_ sender: Any) {
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let pickAndDropVC = SB.instantiateViewController(withIdentifier: "PickDateAndTimeViewController")
        NavigationManager.shared.push(viewController: pickAndDropVC)
       
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        selectAddressCollectionView.delegate = self
        selectAddressCollectionView.dataSource = self

    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "showSavedUserInfoCollectionViewCell", bundle: nil)
        selectAddressCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "showSavedUserInfoCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "AddressNameCollectionViewCell", bundle: nil)
        selectAddressCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "AddressNameCollectionViewCell")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:95)}
        else
        {
            return CGSize(width: collectionView.frame.size.width, height:150)}
        
    }
    
    //MARK:Collection View Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return 3}
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showSavedUserInfoCollectionViewCell", for: indexPath) as! showSavedUserInfoCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressNameCollectionViewCell", for: indexPath) as! AddressNameCollectionViewCell
            return cell
            
        }
    
    
    }
    
}
