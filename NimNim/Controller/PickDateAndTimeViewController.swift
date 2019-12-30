//
//  PickDateAndTimeViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView

class PickDateAndTimeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var pickDateandTimeScreenCollectionView: UICollectionView!
    
    
    @IBAction func pickDeliverySlot(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let DropVC = SB.instantiateViewController(withIdentifier: "PickDeliveryTimeSlotsViewController")
        NavigationManager.shared.push(viewController: DropVC)
        
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        pickDateandTimeScreenCollectionView.delegate = self
        pickDateandTimeScreenCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
       
    }
    
    //MARK:UI Methods
    func registerCells() {
        let PickUpDropServiveNameAndTatTimeCollectionViewCellNib = UINib(nibName: "PickUpDropServiveNameAndTatTimeCollectionViewCell", bundle: nil)
    pickDateandTimeScreenCollectionView.register(PickUpDropServiveNameAndTatTimeCollectionViewCellNib, forCellWithReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell")
        
        let MonthAndDateBaseCollectionViewCellNib = UINib(nibName: "MonthAndDateBaseCollectionViewCell", bundle: nil)
        pickDateandTimeScreenCollectionView.register(MonthAndDateBaseCollectionViewCellNib, forCellWithReuseIdentifier: "MonthAndDateBaseCollectionViewCell")
        
        let TimeSlotsCollectionViewCellNib = UINib(nibName: "TimeSlotsCollectionViewCell", bundle: nil)
        pickDateandTimeScreenCollectionView.register(TimeSlotsCollectionViewCellNib, forCellWithReuseIdentifier: "TimeSlotsCollectionViewCell")
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickUpDropServiveNameAndTatTimeCollectionViewCell", for: indexPath) as! PickUpDropServiveNameAndTatTimeCollectionViewCell
        return cell
    }
    else if indexPath.item == 1 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthAndDateBaseCollectionViewCell", for: indexPath) as! MonthAndDateBaseCollectionViewCell
        return cell
    }
    else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
        return cell
    }
    
    }
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.item == 0 {
        return CGSize(width: self.view.frame.width, height:70)
    }
    else if indexPath.item == 1
    {
        return CGSize(width: self.view.frame.width, height:70)
    }
    else
    {
        return CGSize(width: self.view.frame.width, height:260)
    }
}

}
