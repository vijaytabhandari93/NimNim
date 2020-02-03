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
    
    @IBOutlet weak var basketLabel: UILabel!
    //TODO: Replace this everywhere...
    var servicesModel = ServiceBaseModel.fetchFromUserDefaults()
    var services:[ServiceModel] = []

    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        collectionView.reloadData()
        setupCartCountLabel()
    }
    func setupCartCountLabel() {
        let cartCount = fetchNoOfServicesInCart()
        if cartCount > 0 {
            basketLabel.text = "\(cartCount)"
            basketLabel.isHidden = false
        }else {
            basketLabel.text = "0"
            basketLabel.isHidden = true
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        services = servicesModel?.data ?? []
        registerCells()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 12)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCartCountLabel()
    }
    
    @IBAction func basketTapped(_ sender: Any){
        let cartCount = fetchNoOfServicesInCart()
        if cartCount > 0 {
            let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
            let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
            NavigationManager.shared.push(viewController: orderReviewVC)
        }else {
            let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
            let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "EmptyCartViewController")
            NavigationManager.shared.push(viewController: orderReviewVC)
        }
        
    }
    
    func registerCells(){
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
            if Model.count >= 5  {
                return 5
            }else {
                return Model.count
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        if let servicesModel = ServiceBaseModel.fetchFromUserDefaults() {
            if let services = servicesModel.data {
                cell.serviceName.text = services[indexPath.row].name
                cell.serviceDescription.text = services[indexPath.row].descrip
                cell.serviceDescription.numberOfLines = 4
                cell.alias = services[indexPath.row].alias
                if let alias = services[indexPath.row].alias {
                var inAlias = checkIfInCart(withAlias: alias)
                if inAlias == false {
                    cell.serviceName.textColor = UIColor.black
                    cell.serviceDescription.textColor = UIColor.black
                    cell.selectLabel.backgroundColor = Colors.nimnimServicesColor
                    cell.backgroundCurvedView.backgroundColor = UIColor.white
                    cell.selectLabel.text = "Select"
                    cell.selectLabel.textColor = UIColor.white
                } else {
                    cell.serviceName.textColor = UIColor.white
                    cell.serviceDescription.textColor = UIColor.white
                    cell.backgroundCurvedView.backgroundColor = Colors.nimnimServicesColor
                    cell.selectLabel.backgroundColor = UIColor.white
                    cell.selectLabel.text = "Edit"
                    cell.selectLabel.textColor = Colors.nimnimServicesColor
                    
                }
                }
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2 - 18, height:266)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let servicesStoryboard = UIStoryboard(name: "Services", bundle: nil)
        if services[indexPath.row].alias == "wash-and-fold" {
            let washAndFoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
            washAndFoldVC.serviceModel = services[indexPath.row] //passing of the service model to the vc.
            NavigationManager.shared.push(viewController: washAndFoldVC)
            
        }else if services[indexPath.row].alias == "wash-and-air-dry" {
            let washAndAirDryVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashAndAirDryViewController") as! WashAndAirDryViewController
            
            washAndAirDryVC.serviceModel = services[indexPath.row]
            NavigationManager.shared.push(viewController: washAndAirDryVC)
        }else if services[indexPath.row].alias == "laundered-shirts" {
            let washPressedVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashPressedShirtsViewController") as!WashPressedShirtsViewController
            
            washPressedVC.serviceModel = services[indexPath.row]
            NavigationManager.shared.push(viewController: washPressedVC)
        }else if services[indexPath.row].alias == "household-items" {
            let houseHoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController") as! HouseHoldItemsViewController
            houseHoldVC.serviceModel = services[indexPath.row]
            NavigationManager.shared.push(viewController: houseHoldVC)
        }else if services[indexPath.row].alias == "dry-cleaning" {
            
            let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "DryCleaningViewController") as! DryCleaningViewController
            
            dryCleaningVC.serviceModel = services[indexPath.row]  //refers to 4th element
            NavigationManager.shared.push(viewController: dryCleaningVC)
            
            
        }else if services[indexPath.row].alias == "shoe-repair" {
            let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "ShoeRepairViewController") as! ShoeRepairViewController
            dryCleaningVC.serviceModel = services[indexPath.row]  //refers to 4th element
            NavigationManager.shared.push(viewController: dryCleaningVC)
        }else if services[indexPath.row].alias == "tailoring" {
            
        }else if services[indexPath.row].alias == "carpet-cleaning" {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController")
            NavigationManager.shared.push(viewController: householdVC)
        }
        else if services[indexPath.row].alias == "leather-and-special-care-items" {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController")
            NavigationManager.shared.push(viewController: householdVC)
            
        }
        else {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController")
            NavigationManager.shared.push(viewController: householdVC)
            
            
            
        }
    }
}
