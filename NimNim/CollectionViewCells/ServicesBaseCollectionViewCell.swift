//
//  ServicesBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 03/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

//
//  BannersBaseCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 28/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import Kingfisher

class ServicesBaseCollectionViewCell : UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var serviceBannerCollectionView: UICollectionView!
    
    var services:[ServiceModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceBannerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        registerCells()
        serviceBannerCollectionView.delegate = self
        serviceBannerCollectionView.dataSource = self
    }
    
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "ServiceCollectionViewCell", bundle: nil)
        serviceBannerCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "ServiceCollectionViewCell")
    }
    
    func configureCell(withModel model : ServiceBaseModel? ) {
        if let serviceData = model?.data {
            services = serviceData
            
        }
        serviceBannerCollectionView.reloadData()
    }
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if services.count >= 5 {
            return 2
        }else{
            return services.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        cell.serviceName.text = services[indexPath.item].name
        cell.serviceDescription.text = services[indexPath.item].descrip
        cell.serviceDescription.numberOfLines = 2
        cell.alias = services[indexPath.item].alias
        if let alias = services[indexPath.item].alias
        {
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
        cell.imageURL = services[indexPath.item].icon
        if let url = services[indexPath.item].icon {
            if let urlValue = URL(string: url)
            {
                cell.serviceImage.kf.setImage(with: urlValue)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let servicesStoryboard = UIStoryboard(name: "Services", bundle: nil)
        if services[indexPath.item].alias == "wash-and-fold" {
            let washAndFoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
            washAndFoldVC.serviceModel = services[indexPath.item] //passing of the service model to the vc.
            NavigationManager.shared.push(viewController: washAndFoldVC)
            
        }else if services[indexPath.item].alias == "wash-and-air-dry" {
            let washAndAirDryVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashAndAirDryViewController") as! WashAndAirDryViewController
            
            washAndAirDryVC.serviceModel = services[indexPath.item]
            NavigationManager.shared.push(viewController: washAndAirDryVC)
        }else if services[indexPath.item].alias == "laundered-shirts" {
            let washPressedVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashPressedShirtsViewController") as!WashPressedShirtsViewController
            
            washPressedVC.serviceModel = services[indexPath.item]
            NavigationManager.shared.push(viewController: washPressedVC)
        }else if services[indexPath.item].alias == "household-items" {
            let houseHoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController") as! HouseHoldItemsViewController
            houseHoldVC.serviceModel = services[indexPath.item]
            NavigationManager.shared.push(viewController: houseHoldVC)
        }else if services[indexPath.item].alias == "dry-cleaning" {
            
            let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "DryCleaningViewController") as! DryCleaningViewController
            
            dryCleaningVC.serviceModel = services[indexPath.item]  //refers to 4th element
            NavigationManager.shared.push(viewController: dryCleaningVC)
            
            
        }else if services[indexPath.item].alias == "shoe-repair" {
            let shoeRepairVC = servicesStoryboard.instantiateViewController(withIdentifier: "ShoeRepairViewController") as! ShoeRepairViewController
            shoeRepairVC.serviceModel = services[indexPath.item]
            NavigationManager.shared.push(viewController: shoeRepairVC)
        }else if services[indexPath.item].alias == "tailoring" {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "RugCleaningViewController")
            NavigationManager.shared.push(viewController: householdVC)
        }else if services[indexPath.item].alias == "carpet-cleaning" {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "RugCleaningViewController")
            NavigationManager.shared.push(viewController: householdVC)
        }
        else if services[indexPath.item].alias == "leather-and-special-care-items" {
            let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController")
            NavigationManager.shared.push(viewController: householdVC)
            
        }
        else {let householdVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController")
            NavigationManager.shared.push(viewController: householdVC)
            
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 228)
        
    }
}

