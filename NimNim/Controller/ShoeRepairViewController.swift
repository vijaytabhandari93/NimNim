//
//  ShoeRepairViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ShoeRepairViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = "Replace Small Heel"
            cell.priceLabel.text = "$18"
            return cell }
            
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = "Replace Large Heel"
            cell.priceLabel.text = "$25"
            return cell
        }
            
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = "Replace Leather Toe"
            cell.priceLabel.text = "$25"
            return cell
            
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = "Replace Sole + Toe + Heel"
            cell.priceLabel.text = "$85"
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = "Women Insole"
            cell.priceLabel.text = "$25"
            return cell
        }
            
            else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "ShoeRepairCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ShoeRepairCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        shoeRepairCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        shoeRepairCollectionView.delegate = self
        shoeRepairCollectionView.dataSource = self
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
priceTotalBackgroundView.addTopShadowToView()
        
    }
    
    
    
     //IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var shoeRepairCollectionView: UICollectionView!
    @IBOutlet weak var shoeRepairLabel: UILabel!
    @IBAction func previousTapped(_ sender: Any) {
    }
        //MARK: IBActions
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    @IBAction func basketTapped(_ sender: Any) {
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }
        else if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }
            
        else if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.size.width, height:73)
            
        }
        else if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }
        else if indexPath.item == 4 {
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

}
