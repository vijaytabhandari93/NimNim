//
//  ShoeRepairViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class ShoeRepairViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var shoeRepairCollectionView: UICollectionView!
    @IBOutlet weak var shoeRepairLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    
    enum SelectionType: Int {
        case women
        case men
    }
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .women {
                resetButtons()
                womenButton.isSelected = true
                womenButton.titleLabel?.font = Fonts.semiBold16
                womenButton.setTitleColor(UIColor.white, for: .normal)
                shoeRepairCollectionView.reloadData()
            }else {
                resetButtons()
                menButton.isSelected = true
                menButton.titleLabel?.font = Fonts.semiBold16
                menButton.setTitleColor(UIColor.white, for: .normal)
                shoeRepairCollectionView.reloadData()
            }
        }
    }
    //MARK:View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        shoeRepairCollectionView.delegate = self
        shoeRepairCollectionView.dataSource = self
        selectedState = .women
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }
    
    func resetButtons() {
        menButton.isSelected = false
        womenButton.isSelected = false
        menButton.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        menButton.titleLabel?.font = Fonts.regularFont12
        womenButton.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        womenButton.titleLabel?.font = Fonts.regularFont12
    }
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    @IBAction func basketTapped(_ sender: Any) {
    }
    
    @IBAction func womenTapped(_ sender: Any) {
        selectedState = .women
    }
    
    @IBAction func menTapped(_ sender: Any) {
        selectedState = .men
    }
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.separatorView.alpha = 1
            cell.titleLabel.text = "Number of Shoes"
            cell.counterType = "Shoes"
            cell.configureCounterLabel()
            return cell
        }else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
                cell.actionLabel.text = (selectedState == SelectionType.men) ? "Regular Shine" : "Replace Small Heel"
                cell.priceLabel.text = "$18"
                return cell }
                
            else if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
                cell.actionLabel.text = (selectedState == SelectionType.men) ? "Suede Loafers" : "Replace Large Heel"
                cell.priceLabel.text = "$25"
                return cell
            }
                
            else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
                cell.actionLabel.text = (selectedState == SelectionType.men) ? "Replace Rubber Heel + Shine" : "Replace Leather Toe"
                cell.priceLabel.text = "$25"
                return cell
                
            }
            else if indexPath.item == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
                cell.actionLabel.text = (selectedState == SelectionType.men) ? "Replace Full Rubber Heel" : "Replace Sole + Toe + Heel"
                cell.priceLabel.text = "$85"
                return cell
            }
            else if indexPath.item == 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
                cell.actionLabel.text = (selectedState == SelectionType.men) ? "Mens Insole Full" : "Women Insole"
                cell.priceLabel.text = "$25"
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
                return cell
            }
        }
    }
    //MARK:UI Methods
    func registerCells() {
        let noOfClothesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(noOfClothesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        let type1PreferencesNib = UINib(nibName: "ShoeRepairCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ShoeRepairCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        shoeRepairCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:96)
        }else {
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
