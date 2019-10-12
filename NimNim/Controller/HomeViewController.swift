//
//  HomeViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 26/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:IBOutlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    //MARK:UI Methods
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "BannersBaseCollectionViewCell", bundle: nil)
        homeCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "BannersBaseCollectionViewCell")
        let servicesBaseNib = UINib(nibName: "ServicesBaseCollectionViewCell", bundle: nil)
        homeCollectionView.register(servicesBaseNib, forCellWithReuseIdentifier: "ServicesBaseCollectionViewCell")
        let headerNib = UINib(nibName: "ServicesHeaderCollectionReusableView", bundle: nil)
        homeCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ServicesHeaderCollectionReusableView")
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannersBaseCollectionViewCell", for: indexPath) as! BannersBaseCollectionViewCell
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesBaseCollectionViewCell", for: indexPath) as! ServicesBaseCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height:150)
        }
        else
        {
            return CGSize(width: self.view.frame.width, height:228)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 85)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServicesHeaderCollectionReusableView", for: indexPath) as! ServicesHeaderCollectionReusableView
            return headerView
            
        default:
            let view = UICollectionReusableView()
            return view
        }
    }
}

