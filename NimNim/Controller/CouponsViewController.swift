//
//  CouponsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class CouponsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
     //IBOutlets
    @IBOutlet weak var applyCouponCode : UITextField!
    @IBOutlet weak var couponsCollectionView : UICollectionView!
    
    //IBActions
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func applyTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        couponsCollectionView.delegate = self
        couponsCollectionView.dataSource = self
        

    }
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponsCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:100)
    }
    //MARK:Collection View Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        
        
        return cell
    }

}
