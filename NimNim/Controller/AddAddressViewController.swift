//
//  AddAddressViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var addAddressCollectionView: UICollectionView!
    
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var office: UIButton!
    

        
    enum SelectionType: Int {
        case house
        case office
    }
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .house {
                resetButtons()
                home.isSelected = true
                home.titleLabel?.font = Fonts.semiBold16
                home.setTitleColor(UIColor.white, for: .normal)
                addAddressCollectionView.reloadData()
            }else {
                resetButtons()
                office.isSelected = true
                office.titleLabel?.font = Fonts.semiBold16
                office.setTitleColor(UIColor.white, for: .normal)
                addAddressCollectionView.reloadData()
            }
        }
    }
    
    func resetButtons() {
        home.isSelected = false
        office.isSelected = false
        home.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        office.titleLabel?.font = Fonts.regularFont12
        home.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        office.titleLabel?.font = Fonts.regularFont12
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        selectedState = .house
    }
    @IBAction func officeTapped(_ sender: Any) {
        selectedState = .office
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        addAddressCollectionView.delegate = self
        addAddressCollectionView.dataSource = self
    }
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "AddAddressCollectionViewCell", bundle: nil)
        addAddressCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AddAddressCollectionViewCell")
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height:71)
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER STREET ADDRESS"
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER HOUSE/BLOCK NUMBER"
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "CITY"
            return cell
            
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "STATE"
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ZIPCODE"
            return cell
        }
            
        else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER LANDMARK"
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "PHONE NUMBER"
            return cell
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
