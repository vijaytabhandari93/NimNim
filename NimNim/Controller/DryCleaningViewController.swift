//
//  DryCleaningViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Kingfisher

class DryCleaningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NeedRushDeliveryCollectionViewCellDelegate {
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        setupCartCountLabel() 
        setupPrice()
    }
    func setupPrice() {
        if defaultStateJustNimNimIt {
            let price = "$0"
            priceLabel.text = price
            serviceModel?.servicePrice = price
        }
        else {
            if let price = serviceModel?.calculatePriceForService() {
                priceLabel.text = price
                serviceModel?.servicePrice = price
            }
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    var imageAdded : Bool = false
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var defaultStateJustNimNimIt : Bool = false
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var dryCleaningCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    
    
    @IBOutlet weak var justNimNimIt: UIButton!
    var justNimNimItSelected : Bool = false
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 5
        }
        else
        {
            return 4
        }//select from list,return hanger, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if defaultStateJustNimNimIt {
                return 0
                
            } else
            {
                return 1
            }
            
        }
        else if section == 1 {
            return 1
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectFromListOfClothesCollectionViewCell", for: indexPath) as! SelectFromListOfClothesCollectionViewCell
            cell.serviceModel = serviceModel
            return cell
            
        }
            
        else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.labelAgainsCheckbox.text = "Return Hangers"
            cell.delegate = self
            cell.configureUI(forRushDeliveryState: serviceModel?.needHangers ?? false, forIndex: indexPath)
            cell.descriptionofLabel.text = "Do you want to return the hangers? We re-cycle old hangers."
            return cell
        }
            
        else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 0 {
                if let urlValue = URL(string: ImageNames[0])
                {
                    cell.firstImage.kf.setImage(with: urlValue)
                }
                
            }
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 1 {
                if let urlValue = URL(string: ImageNames[1])
                {
                    cell.secondImage.kf.setImage(with: urlValue)
                }
            }
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 2 {
                if let urlValue = URL(string: ImageNames[2])
                {
                    cell.thirdImage.kf.setImage(with: urlValue)
                }
            }
            return cell
            
        }
            
        else if section == 3  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.delegate = self
            cell.labelAgainsCheckbox.text = "I need Rush Delivery"
            cell.configureUI(forRushDeliveryState: serviceModel?.isRushDeliverySelected ?? false, forIndex: indexPath)
            if let arrayRushOptions = serviceModel?.rushDeliveryOptions, arrayRushOptions.count == 1 {
                let firstPreference = arrayRushOptions[0]
                if let hours  = firstPreference.turnAroundTime
                    ,let extraPrice = firstPreference.price
                { cell.descriptionofLabel.text = "Under rush delivery your clothes will be delivered with in \(hours) Hours and $\(extraPrice) will be charged extra for the same" }
                return cell
            }
        }
        else if section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        registerCells()
        dryCleaningCollectionView.delegate = self
        dryCleaningCollectionView.dataSource = self
        if let name = serviceModel?.name {
            washAndFoldLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        setupAddToCartButton()
        setupCartCountLabel()
        addObservers()
        setupPrice()
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//when keyboard will come , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) //when keyboard will go , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil) //when keyboard change from one number pad to another , this notification will be called.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isHeightAdded {
                addedHeight = keyboardSize.height
                dryCleaningCollectionView.contentInset = UIEdgeInsets(top: dryCleaningCollectionView.contentInset.top, left: dryCleaningCollectionView.contentInset.left, bottom: dryCleaningCollectionView.contentInset.bottom + addedHeight, right: dryCleaningCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            dryCleaningCollectionView.contentInset = UIEdgeInsets(top: dryCleaningCollectionView.contentInset.top, left: dryCleaningCollectionView.contentInset.left, bottom: dryCleaningCollectionView.contentInset.bottom - addedHeight, right: dryCleaningCollectionView.contentInset.right)
            isHeightAdded = false
        }
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
        let type1PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        let type4PreferencesNib = UINib(nibName: "SelectFromListOfClothesCollectionViewCell", bundle: nil)
        dryCleaningCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SelectFromListOfClothesCollectionViewCell")
        
        
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
                    self?.imageAdded = true
                    self?.dryCleaningCollectionView.reloadData()
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
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func justNimNimIt(_ sender: Any) {
        defaultStateJustNimNimIt = !defaultStateJustNimNimIt
        if defaultStateJustNimNimIt {
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
        setupPrice()
        dryCleaningCollectionView.reloadData()
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        if addToCart.titleLabel?.text == "CheckOut" {
            //print("abcd")
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
    //
    //        if let alias = serviceModel?.alias {
    //            serviceParams[AddToCart.alias] = alias
    //        }
    //
    //        if let icon = serviceModel?.icon {
    //            serviceParams[AddToCart.icon] = icon
    //        }
    //
    //        if let description = serviceModel?.descrip {
    //            serviceParams[AddToCart.description] = description
    //        }
    //
    //        serviceParams[AddToCart.ordering] = 1
    //
    //        if let items = serviceModel?.items {
    //            var itemArray : [[String?:Any?]] = []
    //
    //            for item in items {
    //                if let maleCount = item.maleCount {
    //                    if maleCount > 0 {
    //                        let ItemDict:[String?:Any?] = [
    //                            "price" : item.price,
    //                            "qty" : maleCount,
    //                            "name" : item.name,
    //                            "male" : "true"
    //                        ]
    //                        itemArray.append(ItemDict)
    //                    }
    //                }
    //                if let femaleCount = item.femaleCount {
    //                    if femaleCount > 0 {
    //                        let ItemDict:[String?:Any?] = [
    //                            "price" : item.price,
    //                            "qty" : femaleCount,
    //                            "name" : item.name,
    //                            "female" : "true"
    //                        ]
    //                        itemArray.append(ItemDict)
    //
    //                    }
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
    //        if let needHangersSelected = serviceModel?.isRushDeliverySelected {
    //            serviceParams[AddToCart.needHangers] = needHangersSelected
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
    //            self?.dryCleaningCollectionView.reloadData()
    //            print("success")
    //            DispatchQueue.main.async {[weak self] in
    //                if let numberOfSections = self?.dryCleaningCollectionView.numberOfSections {
    //                    let lastSection = numberOfSections - 1
    //                    self?.dryCleaningCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
    //                }
    //            }
    //            self?.activityIndicator.stopAnimating()
    //        }) {[weak self] (error) in
    //            print("error")
    //            self?.activityIndicator.stopAnimating()
    //        }
    //    }
    
    func addServiceToCart() {
        if let serviceModel = serviceModel{
            let modelToDictionary = serviceModel.toJSON()
            var params : [String:Any] = [:]
            params[AddToCart.services] = [modelToDictionary]
            //print(JSON(params))
            activityIndicator.startAnimating()
            NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                self?.IsAddToCartTapped = true
                self?.dryCleaningCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                    self?.setupCartCountLabel()
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.dryCleaningCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.dryCleaningCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
            modelToDictionary["cart_id"] = cartId
            print(JSON(modelToDictionary))
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                
                self?.IsAddToCartTapped = true
                self?.dryCleaningCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                    self?.setupCartCountLabel()
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.dryCleaningCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.dryCleaningCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
            return CGSize(width: collectionView.frame.size.width, height:56)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 2 {
            if imageAdded  {
                return CGSize(width: collectionView.frame.size.width, height:191)
            }
            else
            {
                return CGSize(width: collectionView.frame.size.width, height:120)
            }
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
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
    //Delegate Function of TextView
    
    func textViewStartedEditingInCell(withTextField textView: UITextView) {
        activeTextView = textView
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textViewEndedEditingInCell(withTextField textView: UITextView) {
        removeTapGestures(forTextView: textView)
        if let currentText = textView.text {
            if !(currentText.caseInsensitiveCompare("Any Special Notes...") == .orderedSame) {
                serviceModel?.specialNotes = textView.text
            }
        }
    }
    //MARK: NeedRushDeliveryCellDelegate
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?) {
        if indexPath?.section == 3 {
            if let rushDeliveryState = serviceModel?.isRushDeliverySelected {
                serviceModel?.isRushDeliverySelected = !rushDeliveryState
                dryCleaningCollectionView.reloadData()
                setupPrice()
            }
        }
        else{
            if let needHangers = serviceModel?.needHangers {
                serviceModel?.needHangers = !needHangers
                dryCleaningCollectionView.reloadData()
            }
        }
    }
    
}
