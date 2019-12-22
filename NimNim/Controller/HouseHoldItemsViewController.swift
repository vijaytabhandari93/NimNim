//
//  HouseHoldItemsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class HouseHoldItemsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NeedRushDeliveryCollectionViewCellDelegate,HouseHoldItemCollectionViewCellDelegate {

    var activeTextField : UITextField?
    //NoOfClothes Delegate Methods
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    func removeTapGestures(forTextField textField:UITextField) {
        // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextField = activeTextField, activeTextField == textField {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    
    
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    //IBOutlets
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var houseHoldCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        setupCartCountLabel() 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        houseHoldCollectionView.delegate = self
        houseHoldCollectionView.dataSource = self
        if let name = serviceModel?.name {
            washAndFoldLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        setupAddToCartButton()
        setupCartCountLabel()
    }
    
    func setupAddToCartButton(){
        if let cartId = UserDefaults.standard.string(forKey: UserDefaultKeys.cartId), cartId.count > 0 {
            addToCart.setTitle("Update Cart", for: .normal)
        }else {
            addToCart.setTitle("Add to Cart", for: .normal)
        }
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
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "HouseHoldItemCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "HouseHoldItemCollectionViewCell")
    
        let type2PreferencesNib = UINib(nibName: "HouseHoldDescriptionCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "HouseHoldDescriptionCollectionViewCell")

        let type4PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        let type5PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        houseHoldCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
    }
    
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func basketTapped(_ sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
    }
    @IBAction func justNimNimIt(_ sender: Any) {
        
        
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        if addToCart.titleLabel?.text == "CheckOut" {
            print("abcd")
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
    
//    func addServiceToCart() {
//        var params:[String:Any] = [:]
//        var serviceParams:[String:Any] = [:]
//        if let name = serviceModel?.name {
//            serviceParams[AddToCart.name] = name  // if name is there then set it. "[AddToCart.name]" is the key. "name" is the value
//        }
//        if let alias = serviceModel?.alias {
//            serviceParams[AddToCart.alias] = alias
//        }
//        if let icon = serviceModel?.icon {
//            serviceParams[AddToCart.icon] = icon
//        }
//        if let description = serviceModel?.descrip {
//            serviceParams[AddToCart.description] = description
//        }
//        serviceParams[AddToCart.ordering] = 1
//        
//       
//        if let items = serviceModel?.items {
//            var itemArray : [[String?:Any?]] = []
//            
//            for item in items {
//                if item.IfLaundered == true {
//                    let ItemDict:[String?:Any?] = [
//                        "price" : item.laundryPrice,
//                        "qty" : item.qty,
//                        "if_laundered" : "true",
//                        "name" : item.name,
//                        "if_dryCleaned" : "false",
//                    ]
//                    itemArray.append(ItemDict)
//                    
//                } else if item.IfDrycleaned == true {
//                    let ItemDict:[String?:Any?] = [
//                        "price" : item.dryCleaningPrice,
//                        "qty" : item.qty,
//                        "if_laundered" : "false",
//                        "name" : item.name,
//                        "if_dryCleaned" : "true",
//                    ]
//                    itemArray.append(ItemDict)
//                }
//            }
//            serviceParams[AddToCart.items] = itemArray
//        }
//
//        if let rushDeliveryOptions = serviceModel?.rushDeliveryOptions, rushDeliveryOptions.count > 0 {
//            let firstOption = rushDeliveryOptions[0]
//            if let turnAroundTime = firstOption.turnAroundTime, let price = firstOption.price {
//                let rushDict:[String:Any] = [
//                    "turn_around_time":turnAroundTime,
//                    "price":price
//                ]
//                serviceParams[AddToCart.rushDeliveryOptions] = [rushDict] // array of rush delivery options
//            }
//        }
//        
//        if let isRushDeliverySelected = serviceModel?.isRushDeliverySelected {
//            serviceParams[AddToCart.needRushDelivery] = isRushDeliverySelected
//        }
//        
//        params[AddToCart.services] = [serviceParams]// JSON is a dictionary because of the {}. The JSON is containing key services and the value is an array of dictionary. In our case this array will be having only one dictionary because wee will be adding only one service to cart. This dictionary in our code iss service params.
//        
//        print(JSON(params))
//        
//        activityIndicator.startAnimating()
//        NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
//            self?.addToCart.setTitle("CheckOut", for: .normal)
//            self?.IsAddToCartTapped = true
//            self?.houseHoldCollectionView.reloadData()
//            print("success")
//            DispatchQueue.main.async {[weak self] in
//                if let numberOfSections = self?.houseHoldCollectionView.numberOfSections {
//                    let lastSection = numberOfSections - 1
//                    self?.houseHoldCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
//                }
//            }
//            self?.activityIndicator.stopAnimating()
//        }) {[weak self] (error) in
//            print("error")
//            self?.activityIndicator.stopAnimating()
//        }
//    }
//
    func addServiceToCart() {
        if let serviceModel = serviceModel{
            let modelToDictionary = serviceModel.toJSON()
            var params : [String:Any] = [:]
            params[AddToCart.services] = [modelToDictionary]
            print(JSON(params))
            activityIndicator.startAnimating()
            NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                self?.IsAddToCartTapped = true
                self?.houseHoldCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                    self?.setupCartCountLabel()
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.houseHoldCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.houseHoldCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    func updateServiceInCart(withCartId cartId:String?) {
        if let serviceModel = serviceModel, let cartId = cartId{
            var modelToDictionary = serviceModel.toJSON()
            modelToDictionary["cart_id"] = cartId //to send the cart id along with the other params
            print(JSON(modelToDictionary))
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                self?.IsAddToCartTapped = true
                self?.houseHoldCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                        addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                        self?.setupCartCountLabel()
                    }
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.houseHoldCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.houseHoldCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:73)
        }else if section == 2 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
  
    
   

    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 5
        }
        else
        {
            return 4
        }//description, item, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return serviceModel?.items?.count ?? 0
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }else if section == 4 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldDescriptionCollectionViewCell", for: indexPath) as! HouseHoldDescriptionCollectionViewCell
           return cell
        }
        else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseHoldItemCollectionViewCell", for: indexPath) as! HouseHoldItemCollectionViewCell
            if let items = serviceModel?.items
            {
                cell.delegate = self
                cell.itemLabel.text = items[indexPath.row].name
                if let laundryRate = items[indexPath.row].laundryPrice , let dryCleaningRate = items[indexPath.row].dryCleaningPrice {
                    cell.laundryRate.text = "$\(String(describing: laundryRate))"
                    cell.dryCleaningRate.text = "$\(String(describing: dryCleaningRate))"
                }
                let itemModel = items[indexPath.item]
                cell.configureUI(withModel: itemModel, withIndexPath: indexPath)
            }
            return cell
        }
        if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
                        cell.delegate = self
            return cell
        }
        else if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.delegate = self
            cell.labelAgainsCheckbox.text = "I need Rush Delivery"
            cell.configureUI(forRushDeliveryState: serviceModel?.isRushDeliverySelected ?? false, forIndex: indexPath)
            if let arrayRushOptions = serviceModel?.rushDeliveryOptions, arrayRushOptions.count == 1 {
                let firstPreference = arrayRushOptions[0]
                if let hours  = firstPreference.turnAroundTime
                    ,let extraPrice = firstPreference.price
                {
                    cell.descriptionofLabel.text = "Under rush delivery your clothes will be delivered with in \(hours) Hours and $\(extraPrice) will be charged extra for the same"
                }
                return cell
            }
        }
        else if section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
        }
        return UICollectionViewCell()
    }
   
    
    func removeTapGestures(forTextView textView:UITextView) {
        // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextView = activeTextView, activeTextView == textView {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    // Function of ImageView
    func upload(image:UIImage?) {
        guard let image = image else {
            return
        }
        let uploadModel = UploadModel()
        uploadModel.data = image.jpegData(compressionQuality: 1.0)
        uploadModel.name = "image"
        uploadModel.fileName = "jpg"
        uploadModel.mimeType = .imageJpeg
        activityIndicator.startAnimating()
        NetworkingManager.shared.upload(withEndpoint: Endpoints.uploadImage, withModel: uploadModel, withSuccess: {[weak self] (response) in
            self?.view.showToast(message: "Image uploaded successfully")
            self?.activityIndicator.stopAnimating()
            if let responseDict = response as? [String:Any] {
                if let imagePath = responseDict["path"] as? String, imagePath.count > 0 {
                    self?.serviceModel?.uploadedImages.append(imagePath)
                }
            }
            }, withProgress: { (progress) in
                
                print(progress?.fractionCompleted)
        }) {[weak self] (error) in
            self?.activityIndicator.stopAnimating()
            print(error)
        }
    }
    func sendImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    ///MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        upload(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: NeedRushDeliveryCellDelegate
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?) {
        if let rushDeliveryState = serviceModel?.isRushDeliverySelected {
            serviceModel?.isRushDeliverySelected = !rushDeliveryState
            houseHoldCollectionView.reloadData()
        }
    }

    //MARK: HouseHoldItemsCollectionViewCellDelegate Methods
    func ifLaunderedTapped(withIndexPath indexPath : IndexPath) {
        if let ifLaunderedTapped = serviceModel?.items?[indexPath.row].IfLaundered
        {
            serviceModel?.items?[indexPath.row].IfLaundered = !ifLaunderedTapped
            houseHoldCollectionView.reloadData()
        }
        
    }
    
    func ifDryCleanedTapped(withIndexPath indexPath : IndexPath) {
        if let ifDryCleanedTapped = serviceModel?.items?[indexPath.row].IfLaundered
        {
            serviceModel?.items?[indexPath.row].IfLaundered = !ifDryCleanedTapped
            houseHoldCollectionView.reloadData()
        }
    }
    
    func textFieldStartedEditingInCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        
    }
    
    func textViewStartedEditingInCell(withTextField textView: UITextView) {
        activeTextView = textView
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textViewEndedEditingInCell(withTextField textView: UITextView) {
        removeTapGestures(forTextView: textView)
    }
}
