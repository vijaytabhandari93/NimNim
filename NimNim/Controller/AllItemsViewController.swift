//
//  AllItemsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 21/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import Kingfisher

class AllItemsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    //IBOutlets
    @IBOutlet weak var basketLabel:UILabel!
    @IBOutlet weak var women:UIButton!
    @IBOutlet weak var men:UIButton!
    @IBOutlet weak var orderTotalLabel:UILabel!
    @IBOutlet weak var AllItemsCollectionView: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    
    
    enum SelectionType: Int {
        case women
        case men
    }
    
    var itemArray : [ItemModel] = []
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .women {
                resetButtons()
                women.isSelected = true
                women.titleLabel?.font = Fonts.semiBold14
                women.setTitleColor(UIColor.white, for: .normal)
                itemArray = femaleItems
                AllItemsCollectionView.reloadData()
            }
            else   {
                resetButtons()
                men.isSelected = true
                men.titleLabel?.font = Fonts.semiBold14
                men.setTitleColor(UIColor.white, for: .normal)
                itemArray = maleItems
                AllItemsCollectionView.reloadData()
            }
        }
    }
    
    var maleItems:[ItemModel] = []
    var femaleItems:[ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedState = .women
        women.isSelected = true
        women.titleLabel?.font = Fonts.semiBold14
        women.setTitleColor(UIColor.white, for: .normal)
        registerCells()
        AllItemsCollectionView.delegate = self
        AllItemsCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }

    
    func resetButtons() {
        men.isSelected = false
        women.isSelected = false
        men.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        men.titleLabel?.font = Fonts.regularFont12
        women.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        women.titleLabel?.font = Fonts.regularFont12
    }
    
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func basketTapped(_UI sender: Any) {
        
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
        
    }
    
    @IBAction func womenTapped(_ sender: Any) {
        selectedState = .women
    }
    @IBAction func menTapped(_ sender: Any) {
        selectedState = .men
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
          navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SelectItemCollectionViewCell", bundle: nil)
        AllItemsCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SelectItemCollectionViewCell")
    }
    
    //MARK:Gradient Setting
    
    
    //MARK:Collection View Datasource Method
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectItemCollectionViewCell", for: indexPath) as! SelectItemCollectionViewCell
        if let selectedState = selectedState {
            if selectedState == .men {
                cell.currentGender = .male
                if let numberCount = itemArray[indexPath.row].maleCount
                {
                    cell.numberLabel.text = "\(numberCount)"
                    
                }
            }else {
                cell.currentGender = .female
                if let numberCount = itemArray[indexPath.row].femaleCount
                {
                    cell.numberLabel.text = "\(numberCount)"
                    
                }
            }
        }
        cell.model = itemArray[indexPath.row]
        
        if let name = itemArray[indexPath.row].icon
        {
            let iconURL = URL(string: name)
            cell.selectedImage.kf.setImage(with: iconURL)
        }
        
        if let name = itemArray[indexPath.row].name , let price = itemArray[indexPath.row].price
        {
            cell.selectedLabel.text = "\(name)- $\(price)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 0.5, height:219)
    }
    
}



