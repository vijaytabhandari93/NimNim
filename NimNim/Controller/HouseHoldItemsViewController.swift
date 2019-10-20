//
//  HouseHoldItemsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class HouseHoldItemsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
    }
    @IBAction func basketTapped(_ sender: Any) {
    }
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    //IBOutlets
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var houseHoldCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerCells()
        houseHoldCollectionView.delegate = self
        houseHoldCollectionView.dataSource = self
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "HouseHoldItemCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "HouseHoldItemCollectionViewCell")
    
        let type2PreferencesNib = UINib(nibName: "HouseHoldDescriptionCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "HouseHoldDescriptionCollectionViewCell")

        let type4PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        houseHoldCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= 1 || indexPath.item <= 8  {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }
        else if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:73)
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldDescriptionCollectionViewCell", for: indexPath) as! HouseHoldDescriptionCollectionViewCell
    return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Sheets"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$15"
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Duvets"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$24"
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Pillow"
            cell.laundryRate.text = "$15"
            cell.dryCleaningRate.text = "$10"
            return cell
        }
        else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Blanket"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$15"
            return cell
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Mattress Covers"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$24"
            return cell
        }
        else if indexPath.item == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Cushion Covers"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$25-$50"
            return cell
        }
        
        else if indexPath.item == 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Table Cloth"
            cell.laundryRate.text = "$1.59/lb"
            cell.dryCleaningRate.text = "$30"
            return cell
        }
        else if indexPath.item == 8 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            cell.itemLabel.text = "Comforter"
            cell.laundryRate.text = "$30"
            cell.dryCleaningRate.text = "$30"
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }
    
}
