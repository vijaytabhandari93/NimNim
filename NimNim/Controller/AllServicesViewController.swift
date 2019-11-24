//
//  AllServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AllServicesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //TODO: Replace this everywhere...
    var servicesModel = ServiceBaseModel.fetchFromUserDefaults()
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerCells()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    @IBAction func basketTapped(_ sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
        
    }
    
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "ServiceCollectionViewCell", bundle: nil)
        collectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ServiceCollectionViewCell")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let servicesModel = ServiceBaseModel.fetchFromUserDefaults()
        //TODO: Small M
        if let Model = servicesModel?.data {
            return Model.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        if let servicesModel = ServiceBaseModel.fetchFromUserDefaults() {
            if let services = servicesModel.data {
                cell.serviceName.text = services[indexPath.row].name
                if let url = services[indexPath.row].icon {
                    if let urlValue = URL(string: url)
                    {
                        cell.serviceImage.kf.setImage(with: urlValue)
                    }
                }
                cell.serviceDescription.text = services[indexPath.row].id
            }
            return cell
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2 - 18, height:266)
    }
    
    
    
}
