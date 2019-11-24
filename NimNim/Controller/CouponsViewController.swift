//
//  CouponsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper

class CouponsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
     //IBOutlets
    @IBOutlet weak var applyCouponCode : UITextField!
    @IBOutlet weak var couponsCollectionView : UICollectionView!
    
    var CouponBaseModelObject : CouponBaseModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        couponsCollectionView.delegate = self
        couponsCollectionView.dataSource = self
        fetchCoupons()
    }
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponsCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func applyTapped(_ sender: Any) {
        
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:100)
    }
    
    //MARK: Networking Call
    func fetchCoupons() {
        
        NetworkingManager.shared.get(withEndpoint: Endpoints.promocodes, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let couponBaseModel = Mapper<CouponBaseModel>().map(JSON: responseDict)
                self?.CouponBaseModelObject = couponBaseModel
                //? is put after self as it is weak self.
                self?.couponsCollectionView.reloadData()
            }
            
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } // definition of error closure
    }
    //MARK:Collection View Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        if let ModelObjectArray = CouponBaseModelObject?.data{
            return ModelObjectArray.count
        }
            
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        //TODO: Replace with small O
        if let Object = CouponBaseModelObject?.data?[indexPath.row] {
            cell.configure(model: Object)
            return cell
        }
        return cell
    }

}
