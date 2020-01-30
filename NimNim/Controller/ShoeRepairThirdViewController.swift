////
////  ShoeRepairViewController.swift
////  NimNim
////
////  Created by Raghav Vij on 13/10/19.
////  Copyright © 2019 NimNim. All rights reserved.
////
//
//import UIKit
//import NVActivityIndicatorView
//
//class ShoeRepairThirdViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
//    
//    //MARK: IBOutlets
//    @IBOutlet weak var basketLabel: UILabel!
//    @IBOutlet weak var priceTotalBackgroundView: UIView!
//    @IBOutlet weak var shoeRepairCollectionView: UICollectionView!
//    @IBOutlet weak var shoeRepairLabel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
//    
//    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
//    
//    //MARK:View Controller
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        registerCells()
//        shoeRepairCollectionView.delegate = self
//        shoeRepairCollectionView.dataSource = self
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        applyHorizontalNimNimGradient()
//  
//    }
//    
//    
//    
//    //MARK: IBActions
//    @IBAction func previousTapped(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func justNimNimIt(_ sender: Any) {
//    }
//    
//    @IBAction func basketTapped(_ sender: Any) {
//        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
//        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
//        NavigationManager.shared.push(viewController: orderReviewVC)
//    }
//    
//    
//    
//    
//    //MARK:Collection View Datasource Methods
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            
//            return 2
//            
//        } else
//        {
//            return 1
//        }
//        
//    }
//    
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddShoeRepairCollectionViewCell", for: indexPath) as! AddShoeRepairCollectionViewCell
//            
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeTaskAddedCollectionViewCell", for: indexPath) as! ShoeTaskAddedCollectionViewCell
//            
//            return cell
//            
//        }
//        
//    }
//    //MARK:UI Methods
//    func registerCells() {
//        let noOfClothesNib = UINib(nibName: "ShoeTaskAddedCollectionViewCell", bundle: nil)
//        shoeRepairCollectionView.register(noOfClothesNib, forCellWithReuseIdentifier: "ShoeTaskAddedCollectionViewCell")
//        
//        let noOfClothesNib2 = UINib(nibName: "AddShoeRepairCollectionViewCell", bundle: nil)
//        shoeRepairCollectionView.register(noOfClothesNib2, forCellWithReuseIdentifier: "AddShoeRepairCollectionViewCell")
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 {
//              return CGSize(width: collectionView.frame.size.width, height:100)
//        } else {
//              return CGSize(width: collectionView.frame.size.width, height:48)
//        }
//      
//        
//    }
//    
//    
//    
//    
//}
