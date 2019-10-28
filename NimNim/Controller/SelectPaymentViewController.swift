//
//  SelectPaymentViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SelectPaymentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    //IBOutlets
        @IBOutlet weak var selectPaymentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerCells()
        selectPaymentCollectionView.delegate = self
        selectPaymentCollectionView.dataSource = self
    }
    //IBActions
    @IBAction func placeOrder(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let placeOrderVC = SB.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController")
        NavigationManager.shared.push(viewController: placeOrderVC)
        
    }
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SavedCardCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SavedCardCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "SavedCardExpandedStateTwoCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell")
    }
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
            cell.arrowImageView.isHidden = true
            cell.bottomSeparator.isHidden = true
        return cell
    }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell", for: indexPath) as! SavedCardExpandedStateTwoCollectionViewCell
            cell.bottomSeparator.isHidden = true
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
        return CGSize(width:collectionView.frame.size.width , height: 64)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height: 257)
            
        }
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    

}
