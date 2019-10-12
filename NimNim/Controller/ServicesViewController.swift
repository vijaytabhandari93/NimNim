//
//  ServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 04/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prefernces: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        prefernces.delegate = self
        prefernces.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }
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
        let type1PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        prefernces.register(type1PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        prefernces.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        prefernces.register(type3PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        prefernces.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item <= 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Detergent"
                cell.leftImageView.image = UIImage(named: "scented")
                cell.leftLabel.text = "Scented"
                cell.rightImageView.image = UIImage(named: "nonScented")
                cell.rightLabel.text = "Non - Scented"
                return cell
            case 1:
                cell.titleLabel.text = "Wash"
                cell.leftImageView.image = UIImage(named: "warmWater")
                cell.leftLabel.text = "Warm Water"
                cell.rightImageView.image = UIImage(named: "coldWater")
                cell.rightLabel.text = "Cold Water"
                return cell
            case 2:
                cell.titleLabel.text = "Dry"
                cell.leftImageView.image = UIImage(named: "tshirt-1")
                cell.leftLabel.text = "Low"
                cell.rightImageView.image = UIImage(named: "tshirt")
                cell.rightLabel.text = "Medium"
                return cell
            case 3:
                cell.titleLabel.text = "Bleach"
                cell.leftImageView.image = UIImage(named: "path10")
                cell.leftLabel.text = "Yes"
                cell.rightImageView.image = UIImage(named: "noBleach")
                cell.rightLabel.text = "No"
                return cell
            case 4:
                cell.titleLabel.text = "Softer"
                cell.leftImageView.image = UIImage(named: "yes")
                cell.leftLabel.text = "Yes"
                cell.rightImageView.image = UIImage(named: "no")
                cell.rightLabel.text = "No"
                return cell
                
            default:
                cell.titleLabel.text = "Detergent"
                cell.leftImageView.image = UIImage(named: "scented")
                cell.leftLabel.text = "Scented"
                cell.rightImageView.image = UIImage(named: "nonScented")
                cell.rightLabel.text = "Non - Scented"
                return cell
            }
        }else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item <= 4 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }
        else if indexPath.item == 5
        {
            return CGSize(width: collectionView.frame.size.width, height:95)
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
