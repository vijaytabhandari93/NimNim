//
//  AllItemsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 21/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AllItemsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
   
    //IBOutlets
    @IBOutlet weak var basketLabel:UILabel!
        @IBOutlet weak var women:UIButton!
        @IBOutlet weak var men:UIButton!
        @IBOutlet weak var household:UIButton!
    
    
    @IBOutlet weak var orderTotalLabel:UILabel!
    @IBOutlet weak var AllItemsCollectionView: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
 
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    enum SelectionType: Int {
        case women
        case men
        case household
        }
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .women {
                resetButtons()
                women.isSelected = true
                women.titleLabel?.font = Fonts.semiBold14
                women.setTitleColor(UIColor.white, for: .normal)
                AllItemsCollectionView.reloadData()
            }else if selectedState == .men  {
                resetButtons()
                men.isSelected = true
                men.titleLabel?.font = Fonts.semiBold14
                men.setTitleColor(UIColor.white, for: .normal)
                AllItemsCollectionView.reloadData()
            }
            else{
                resetButtons()
                household.isSelected = true
                household.titleLabel?.font = Fonts.semiBold14
                household.setTitleColor(UIColor.white, for: .normal)
                AllItemsCollectionView.reloadData()
                
            }
            
        }
    }
        
        func resetButtons() {
            men.isSelected = false
            women.isSelected = false
            household.isSelected = false
            men.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
            men.titleLabel?.font = Fonts.regularFont12
            women.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
            women.titleLabel?.font = Fonts.regularFont12
            household.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
            household.titleLabel?.font = Fonts.regularFont12
            
        }
        
    @IBAction func basketTapped(_UI sender: Any) {
        
            let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
            let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
            NavigationManager.shared.push(viewController: orderReviewVC)
            
        
    }
    @IBAction func womenTapped(_ sender: Any) { selectedState = .women}
    @IBAction func menTapped(_ sender: Any) { selectedState = .men}
    @IBAction func houseHoldItemsTapped(_ sender: Any) {selectedState = .household}
    @IBAction func addToCartTapped(_ sender: Any) {}
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        AllItemsCollectionView.delegate = self
        AllItemsCollectionView.dataSource = self

     
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SelectItemCollectionViewCell", bundle: nil)
        AllItemsCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SelectItemCollectionViewCell")
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
priceTotalBackgroundView.addTopShadowToView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 0.5, height:219)
    }
    
    
    
    //MARK:Collection View Datasource Methods
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectItemCollectionViewCell", for: indexPath) as! SelectItemCollectionViewCell
        cell.selectedImage.image = UIImage(named: "tshirt")
        cell.numberLabel.text = String(0)
        cell.selectedLabel.text = "polo"
        
            return cell
        }
    
    
}



