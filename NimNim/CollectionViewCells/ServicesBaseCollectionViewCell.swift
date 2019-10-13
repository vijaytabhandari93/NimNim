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

class ServicesBaseCollectionViewCell : UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var serviceBannerCollectionView: UICollectionView!
    
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
    
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
        if indexPath.item == 0 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Wash + Fold") //This will set the title label/service name label inside the ServiceCollectionViewCell dequed above in this function...we will setup the value of that label on the basis of the indexPath...
        }else if indexPath.item == 1 {
            cell.backgroundCurvedView.backgroundColor = Colors.nimnimServicesGreen
            cell.configureCell(withTitle: "Wash + Air Dry")
        }else if indexPath.item == 2 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Wash + Pressed Shirts")
        }else if indexPath.item == 3 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Dry Cleaning")
        }else if indexPath.item == 4 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Rug Cleaning")
        }else if indexPath.item == 5 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Shoe Repair")
        }else if indexPath.item == 6 {
            cell.backgroundCurvedView.backgroundColor = Colors.nimnimServicesGreen
            cell.configureCell(withTitle: "Tailoring")
        }else if indexPath.item == 7 {
            cell.backgroundCurvedView.backgroundColor = UIColor.white
            cell.configureCell(withTitle: "Household Items")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let servicesStoryboard = UIStoryboard(name: "Services", bundle: nil)
        if indexPath.item == 0 {
            let washAndFoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "ServicesViewController")
            NavigationManager.shared.push(viewController: washAndFoldVC)
        }else if indexPath.item == 1 {
            let washAndAirDryVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashAndAirDryViewController")
            NavigationManager.shared.push(viewController: washAndAirDryVC)
        }else if indexPath.item == 2 {
            let washPressedVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashPressedShirtsViewController")
            NavigationManager.shared.push(viewController: washPressedVC)
        }else if indexPath.item == 3 {
            let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "DryCleaningViewController")
            NavigationManager.shared.push(viewController: dryCleaningVC)
        }else if indexPath.item == 4 {
            
        }else if indexPath.item == 5 {
            let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "ShoeRepairViewController")
            NavigationManager.shared.push(viewController: dryCleaningVC)
        }else if indexPath.item == 6 {
            
        }else if indexPath.item == 7 {
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 228)
        
    }
}

