//
//  WashPressedShirtsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 12/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class WashPressedShirtsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

        //IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var WashAndPressedShirtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var WashPressedShirtCollectionView: UICollectionView!
    @IBOutlet weak var PriceTotalBackgroundView: UIView!
        //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func basketTapped(_ sender: Any) {
    }
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")

       let type4PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let type5PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
      
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        WashPressedShirtCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        WashAndPressedShirtLabel.text = "Wash & Pressed Shirts"
        descriptionLabel.text = "Place your shirts inside the bag and Just NimNim It below, we will deliver them on hangers for only $2.75 per shirt "
        WashPressedShirtCollectionView.delegate = self
        WashPressedShirtCollectionView.dataSource = self
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        PriceTotalBackgroundView.addTopShadowToView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PreferencesCollectionReusableView", for: indexPath) as! PreferencesCollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
        
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            return cell }
            
        
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            cell.titleLabel.text = "Starch"
            cell.leftImageView.image = UIImage(named: "starchLight")
            cell.leftLabel.text = "Light"
            cell.rightImageView.image = UIImage(named: "starchHeavy")
            cell.rightLabel.text = "Heavy"
            return cell
            
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            cell.titleLabel.text = "Boxed"
            cell.leftImageView.image = UIImage(named: "packing")
            cell.leftLabel.text = "Boxed"
            cell.rightImageView.image = UIImage(named: "shirt")
            cell.rightLabel.text = "Unboxed"
            return cell
        }
       
            
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:50)
        }
        else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }
            
        else if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.size.width, height:104)
            
        }
        else if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }
        else if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }
            
    
        else {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
    }
}
    
    

    

