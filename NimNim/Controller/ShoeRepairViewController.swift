//
//  ShoeRepairViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ShoeRepairViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ShoeRepairSecondViewControllerDelegate,AddShoeRepairCollectionViewCellDelegate {
    
    var serviceModel:ServiceModel?
    
    
    func pushSecondViewController() {
        let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"ShoeRepairSecondViewController") as? ShoeRepairSecondViewController
        secondViewController?.serviceModel = serviceModel
        NavigationManager.shared.push(viewController: secondViewController)
        secondViewController?.delegate = self
    }
    
    
    func addShoeRepairTask(withTask taskModel:TaskModel?) {
        if let taskModel = taskModel  {
            if serviceModel?.tasks == nil  {
                serviceModel?.tasks = []
            }
            serviceModel?.tasks?.append(taskModel)
        }
        shoeRepairCollectionView.reloadData()
    }
    
    
    //MARK: IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var shoeRepairCollectionView: UICollectionView!
    @IBOutlet weak var shoeRepairLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceTotalbackgroundView: NSLayoutConstraint!
    @IBOutlet weak var justNimNimIt: UIButton!
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    //MARK:View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        shoeRepairCollectionView.delegate = self
        shoeRepairCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            addToCart.backgroundColor = Colors.addToCartUnselectable
            priceTotalbackgroundView.constant = 0
            totalPrice.isHidden = true
            priceValue.isHidden = true
            
        } else {
            addToCart.backgroundColor = Colors.nimnimGreen
            priceTotalbackgroundView.constant = 48
            justNimNimIt.isHidden = true
            totalPrice.isHidden = false
            priceValue.isHidden = false
        }
       
        shoeRepairCollectionView.reloadData()
        
    }
    
    
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    @IBAction func basketTapped(_ sender: Any) {
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

    //MARK:Collection View Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfSections =  0
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            numberOfSections = tasks.count + 1
        }else {
            numberOfSections = 1
        }
        if section == (numberOfSections - 1) {
            //Add task section
            return 1
        }else {
            if let tasks = serviceModel?.tasks, tasks.count > section {
                let currentTask = tasks[section]
                return currentTask.getSelectedItems().count + 1
            }
        }
        return  0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            return tasks.count + 1
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var numberOfSections =  0
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            numberOfSections = tasks.count + 1
        }else {
            numberOfSections = 1
        }
        if indexPath.section == (numberOfSections - 1)  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddShoeRepairCollectionViewCell", for: indexPath) as! AddShoeRepairCollectionViewCell
            cell.delegate = self
            return cell
        }
        else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeTaskAddedCollectionViewCell", for: indexPath) as! ShoeTaskAddedCollectionViewCell
                
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedTasksCollectionViewCell", for: indexPath) as! SelectedTasksCollectionViewCell
                if let tasks = serviceModel?.tasks, tasks.count > indexPath.section {
                    let currentTask = tasks[indexPath.section]
                    let selectedItems = currentTask.getSelectedItems()
                    if selectedItems.count  > indexPath.item - 1 {
                        let currentItem = selectedItems[indexPath.item - 1]
                        cell.taskTitleCell.text = currentItem.name
                    }
                    if indexPath.item == (collectionView.numberOfItems(inSection: indexPath.section) -  1) {
                        cell.separatorView.isHidden = false
                    }else {
                        cell.separatorView.isHidden = true
                    }
                }
                return cell
            }
        }
    }
    
    //MARK:UI Methods
    func registerCells() {
        let noOfClothesNib = UINib(nibName: "AddShoeRepairCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(noOfClothesNib, forCellWithReuseIdentifier: "AddShoeRepairCollectionViewCell")
        
        let noOfClothesNib1 = UINib(nibName: "ShoeTaskAddedCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(noOfClothesNib1, forCellWithReuseIdentifier: "ShoeTaskAddedCollectionViewCell")
        
        let noOfClothesNib2 = UINib(nibName: "SelectedTasksCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(noOfClothesNib2, forCellWithReuseIdentifier: "SelectedTasksCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:60)
    }
    
    
    
    
}
