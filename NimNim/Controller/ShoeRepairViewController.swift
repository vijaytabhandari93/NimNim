//
//  ShoeRepairViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import SwiftyJSON

class ShoeRepairViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ShoeRepairSecondViewControllerDelegate,AddShoeRepairCollectionViewCellDelegate,ShoeTaskAddedCollectionViewCellDelegate {
    
    
    @IBOutlet weak var justNimNimItHeightConstraint: NSLayoutConstraint!
    var justNimNimItSelected : Bool = false
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    func pushSecondViewController() {
        let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"ShoeRepairSecondViewController") as? ShoeRepairSecondViewController
        secondViewController?.serviceModel = serviceModel
        NavigationManager.shared.push(viewController: secondViewController)
        secondViewController?.delegate = self
    }
    
    // we have created the push function and also created first controller as the delegate of the  first.
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        priceTotalBackgroundView.addTopShadowToView()
    }
    
    func addShoeRepairTask(withTask taskModel:TaskModel?) {
        if let taskModel = taskModel  {
            serviceModel?.tasks?.append(taskModel)
            priceValue.text = getPriceOfService()
        }
        setupScreen()
    }
    
    @IBAction func addMoreServices(_ sender: Any) {
        let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
                    let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"AllServicesViewController") as? AllServicesViewController
                    NavigationManager.shared.push(viewController: secondViewController)
    }
    
    @IBOutlet weak var addMoreService: UIButton!
    
    
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
    
    func editShoeRepairTask(withTask taskModel: TaskModel?, withindex indexPath: IndexPath) {
        if let taskModel = taskModel  {
            serviceModel?.tasks?[indexPath.section] = taskModel
            priceValue.text = getPriceOfService()
        }
        setupScreen()
    }
    
    
    
    func  getPriceOfService() ->String {
        var price = 0
        if let items =  serviceModel?.tasks {
            for item in items  {
                price = item.taskPrice  + price
            }
        }
        return "$\(price)"
        
    }
    // the task which is created in the second view controller is added in the first view controller.
    
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
        setupCartCountLabel()
        setupScreen()
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
    }
    func setupScreen(){
        if justNimNimItSelected{
            addToCart.backgroundColor = Colors.nimnimGreen
            addToCart.isEnabled = true
        }
        else
        {
            if let tasks = serviceModel?.tasks, tasks.count > 0 {
                addToCart.backgroundColor = Colors.nimnimGreen
                addToCart.isEnabled = true
                priceTotalbackgroundView.constant = 48
                justNimNimIt.isHidden = true
                totalPrice.isHidden = false
                priceValue.isHidden = false
                priceValue.text = getPriceOfService()
                justNimNimItHeightConstraint.constant = 0
                addMoreService.isHidden = false
            } else {
                addToCart.backgroundColor = Colors.addToCartUnselectable
                addToCart.isEnabled = false
                priceTotalbackgroundView.constant = 0
                totalPrice.isHidden = true
                priceValue.isHidden = true
                justNimNimItHeightConstraint.constant = 40
                addMoreService.isHidden = true
            }
            shoeRepairCollectionView.reloadData()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        setupScreen()
        setupCartCountLabel()
    }
    
    
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        let params = serviceModel?.toJSON()
        print(JSON(params))
        if addToCart.titleLabel?.text == "Check Out" {
            let orderStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
            let cartVC = orderStoryboard.instantiateViewController(withIdentifier: "OrderReviewViewController") as? OrderReviewViewController
            NavigationManager.shared.push(viewController: cartVC)
        }
        else if let cartId = UserDefaults.standard.string(forKey: UserDefaultKeys.cartId), cartId.count > 0 {
            updateServiceInCart(withCartId: cartId)
        }else
        {
            addServiceToCart()
        }
    }
    func updateServiceInCart(withCartId cartId:String?) {
        if let serviceModel = serviceModel, let cartId = cartId{
            var modelToDictionary = serviceModel.toJSON()
            modelToDictionary["cart_id"] = cartId
            print(JSON(modelToDictionary))
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("Check Out", for: .normal)
                self?.IsAddToCartTapped = true
                self?.shoeRepairCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                        addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                        self?.setupCartCountLabel()
                    }
                }
                
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.shoeRepairCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.shoeRepairCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func addServiceToCart() {
        if let serviceModel = serviceModel /// this is received from serviceBase collection view cells(//passing of the service model to the vc. as written)
        {
            let modelToDictionary = serviceModel.toJSON() // model in dictationary
            activityIndicator.startAnimating()
            var params : [String:Any] = [:]/// - dictionary
            params[AddToCart.services] = [modelToDictionary]///the params of add to cart is key value pair. Key is "services" and value is an array of dictianary.
            print(JSON(params))
            NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("Check Out", for: .normal)//alamofire is conveerting dictionary to JSON
                self?.IsAddToCartTapped = true
                self?.shoeRepairCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias) // to make alias
                    self?.setupCartCountLabel()
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.shoeRepairCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.shoeRepairCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    @IBAction func justNimNimIt(_ sender: Any) {
        
        justNimNimItSelected = !justNimNimItSelected
        if justNimNimItSelected {
            justNimNimIt.backgroundColor = Colors.nimnimGreen
            justNimNimIt.setTitleColor(.white, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.extraBold16
            
        }
        else
        {
            justNimNimIt.backgroundColor = .white
            justNimNimIt.setTitleColor(Colors.nimnimGreen, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.regularFont14
            
            
        }
        setupScreen()
        shoeRepairCollectionView.reloadData()
    }
    @IBAction func infoTapped(_ sender: Any) {
        let jnnvc = self.storyboard?.instantiateViewController(withIdentifier: "JustNimNimInfoViewController") as! JustNimNimInfoViewController
        jnnvc.titleValue = "Just Nim Nim It For \n ShoeRepair"
        jnnvc.descriptionValue = "Tap on Just NimNim It and book the best care for your shoes!"
        present(jnnvc, animated: true, completion: nil)
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
            numberOfSections = tasks.count + 2
        }else {
            numberOfSections = 2
        }
        if section == (numberOfSections - 2) {
            //Add task section
            return 1
        }
            else if section == (numberOfSections - 1){
                return 1
            }
        else {
            if let tasks = serviceModel?.tasks, tasks.count > section {
                let currentTask = tasks[section]
                return currentTask.getSelectedItems().count + 1  // the  number  of items in  section  is equal to number of  tasks and add  1.
            }
        }
        return  0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if justNimNimItSelected{
            return 0
        }  else {
            if let tasks = serviceModel?.tasks, tasks.count > 0 {
                return tasks.count + 2
            }else {
                return 2
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var numberOfSections =  0
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            numberOfSections = tasks.count + 2
        }else {
            numberOfSections = 2
        }
        if indexPath.section == (numberOfSections - 1)  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell", for: indexPath) as! RushDeliveryNotAvailableCollectionViewCell
            return cell
        }
        else if indexPath.section == (numberOfSections - 2)  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddShoeRepairCollectionViewCell", for: indexPath) as! AddShoeRepairCollectionViewCell
            cell.delegate = self
            return cell
        }
        else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeTaskAddedCollectionViewCell", for: indexPath) as! ShoeTaskAddedCollectionViewCell
                cell.delegate  = self
                cell.IndexPath = indexPath
                cell.taskNumberLabel.text  =  "\(indexPath.section + 1).  Task Added"
                
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
        
        let type6PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier:"RushDeliveryNotAvailableCollectionViewCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfSections =  0
        if let tasks = serviceModel?.tasks, tasks.count > 0 {
            numberOfSections = tasks.count + 2
        }else {
            numberOfSections = 2
        }
        if indexPath.section == (numberOfSections - 1)  {
            return CGSize(width: collectionView.frame.size.width, height:60)
        }
        else if indexPath.section == (numberOfSections - 2)  {
            return CGSize(width: collectionView.frame.size.width, height:60)
        }
        else {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.size.width, height:30)
            }else {
                return CGSize(width: collectionView.frame.size.width, height:22)
            }
        }
    }
    //Delegate functions of task
    func editTapped(withIndexPath indexPath: IndexPath?) {
        let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"ShoeRepairSecondViewController") as? ShoeRepairSecondViewController
        secondViewController?.serviceModel = serviceModel
        secondViewController?.delegate = self
        if let model = serviceModel?.tasks?[indexPath!.section] {
            secondViewController?.taskModel = model
            secondViewController?.editModeOn = true
            secondViewController?.indexPath = indexPath
            NavigationManager.shared.push(viewController: secondViewController)
        }
        
    }
    
    func deleteTapped(withIndexPath indexPath: IndexPath?) {
        if let indexPath = indexPath{
            if let _ = serviceModel?.tasks?[indexPath.section] {
                serviceModel?.tasks?.remove(at: indexPath.section)
                shoeRepairCollectionView.reloadData()
                priceValue.text = getPriceOfService()
                setupScreen()
            }
        }
    }
    
}
