////
////  WashAndAirDryViewController.swift
////  NimNim
////
////  Created by Raghav Vij on 10/10/19.
////  Copyright © 2019 NimNim. All rights reserved.

import UIKit

class WashAndAirDryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var washAndAirDryCollectionView: UICollectionView!
    @IBOutlet weak var washAndAirDryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "SelectFromListOfClothesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SelectFromListOfClothesCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        let type5PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell")
        let type6PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        washAndAirDryCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        washAndAirDryCollectionView.delegate = self
        washAndAirDryCollectionView.dataSource = self
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        
    }
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func basketTapped(_ sender: Any) {
    }
    
    @IBAction func justNimNimItTapped(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:82)
        }
        else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.size.width, height:56)
        }
        else if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.size.width, height:104)
            
        }
        else if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }
        else if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }
            
        else if indexPath.item == 5 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }
        else if indexPath.item == 6 {
            return CGSize(width: collectionView.frame.size.width, height:60)
        }
        else {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
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
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.separatorView.alpha = 0
            cell.titleLabel.text = "Number of Clothes"
            cell.counterType = "Clothes"
            cell.configureCounterLabel()
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectFromListOfClothesCollectionViewCell", for: indexPath) as! SelectFromListOfClothesCollectionViewCell
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            cell.titleLabel.text = "Wash"
            cell.leftImageView.image = UIImage(named: "warmWater")
            cell.leftLabel.text = "Warm Water"
            cell.rightImageView.image = UIImage(named: "coldWater")
            cell.rightLabel.text = "Cold Water"
            return cell
            
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            cell.titleLabel.text = "Bleach"
            cell.leftImageView.image = UIImage(named: "path10")
            cell.leftLabel.text = "Yes"
            cell.rightImageView.image = UIImage(named: "noBleach")
            cell.rightLabel.text = "No"
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            cell.titleLabel.text = "Softer"
            cell.leftImageView.image = UIImage(named: "yes")
            cell.leftLabel.text = "Yes"
            cell.rightImageView.image = UIImage(named: "no")
            cell.rightLabel.text = "No"
            return cell
        }
            
        else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            return cell
        }
        else if indexPath.item == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell", for: indexPath) as! RushDeliveryNotAvailableCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }
}
