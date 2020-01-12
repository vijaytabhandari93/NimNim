//
//  AllServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NimNimViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NeedRushDeliveryCollectionViewCellDelegate {
    
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?) {
        
    }
    
   
    @IBOutlet weak var collectionView: UICollectionView!
   
    //TODO: Replace this everywhere...
    var servicesModel = ServiceBaseModel.fetchFromUserDefaults()
    var services:[ServiceModel] = []

    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        collectionView.reloadData()
        
    }
   
    @IBAction func selectAddressTapped(_ sender: Any) {

    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        services = servicesModel?.data ?? []
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    
    func registerCells(){
        let type1PreferencesNib = UINib(nibName: "ServiceCollectionViewCell", bundle: nil)
        collectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
              collectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
              collectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
    navigationController?.popViewController(animated: true)
    
    }
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
            if let servicesModel = ServiceBaseModel.fetchFromUserDefaults() {
                if let services = servicesModel.data {
                    cell.serviceName.text = services[indexPath.row].name
                    cell.serviceDescription.text = services[indexPath.row].descrip
                    cell.alias = services[indexPath.row].alias
                    if let url = services[indexPath.row].icon {
                        if let urlValue = URL(string: url)
                        {
                            cell.serviceImage.kf.setImage(with: urlValue)
                        }
                    }
                }
                
                return cell
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            return cell
        }
    }
       
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0  {
            return CGSize(width: collectionView.frame.size.width/2 - 25, height:266)
        }else if indexPath.section == 1  {
            return CGSize(width: collectionView.frame.size.width, height :95)
        }else  {
            return CGSize(width:collectionView.frame.size.width,height:134)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        }else {
            return UIEdgeInsets.zero
        }
    }
    
}
