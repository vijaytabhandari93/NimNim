//
//  RugCleaningViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class RugCleaningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
        //IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var rugCleaning: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rugCleaningCollectionView: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UICollectionView!
    
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func basketTapped(_ sender: Any) {
    }
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
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
        rugCleaningCollectionView.delegate = self
        rugCleaningCollectionView.dataSource = self
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        rugCleaningCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")

    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:82)
        }
        else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.size.width, height:82)
        }
        else if indexPath.item == 2 {
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.separatorView.alpha = 0
            cell.titleLabel.text = "Number of Rugs"
            cell.counterType = "Rugs"
            cell.configureCounterLabel()
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.separatorView.alpha = 0
            cell.titleLabel.text = "Number of Rugs"
            cell.counterType = "Rugs"
            cell.configureCounterLabel()
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell", for: indexPath) as! RushDeliveryNotAvailableCollectionViewCell
              return cell
            }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }

}
