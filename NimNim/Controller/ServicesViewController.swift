//
//  ServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 04/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView

class ServicesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,NoofClothesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,NeedRushDeliveryCollectionViewCellDelegate{
    //IBOutlets
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prefernces: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel! 
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var serviceModel:ServiceModel? 
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    var activeTextField : UITextField?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addObservers()
        registerCells()
        prefernces.delegate = self
        prefernces.dataSource = self
        if let name = serviceModel?.name {
            washAndFoldLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        if let priceOfService = serviceModel?.calculatePriceForService() {
            priceLabel.text = priceOfService
        }
        setupAddToCartButton()
        setupCartCountLabel()
       
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
                prefernces.contentInset = UIEdgeInsets(top: prefernces.contentInset.top, left: prefernces.contentInset.left, bottom: prefernces.contentInset.bottom + addedHeight, right: prefernces.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            prefernces.contentInset = UIEdgeInsets(top: prefernces.contentInset.top, left: prefernces.contentInset.left, bottom: prefernces.contentInset.bottom - addedHeight, right: prefernces.contentInset.right)
            isHeightAdded = false
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
    
    func setupAddToCartButton(){
        if let cartId = UserDefaults.standard.string(forKey: UserDefaultKeys.cartId), cartId.count > 0 {
            addToCart.setTitle("Update Cart", for: .normal)
        }else {
            addToCart.setTitle("Add to Cart", for: .normal)
        }
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        setupCartCountLabel()
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
        serviceModel?.setupNimNimItForWashAndFold()
        prefernces.reloadData()
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if addToCart.titleLabel?.text == "CheckOut" {
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
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                self?.IsAddToCartTapped = true
                self?.prefernces.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                        addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                        self?.setupCartCountLabel()
                    }
                }
                
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.prefernces.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.prefernces.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
            NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)//alamofire is conveerting dictionary to JSON
               self?.IsAddToCartTapped = true
                self?.prefernces.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias) // to make alias
                    self?.setupCartCountLabel()
                }
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.prefernces.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.prefernces.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
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
            self?.activityIndicator.stopAnimating()
            
        }, withProgress: { (progress) in
            
            print(progress?.fractionCompleted)
        }) {[weak self] (error) in
            self?.activityIndicator.stopAnimating()
            print(error)
        }
    }
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        prefernces.register(type1PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        prefernces.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        prefernces.register(type3PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        prefernces.register(type4PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        prefernces.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 4
        }
        else
        {
            return 3
            
        }//number of clothes, preferences, special notes, rush delivery, add more services
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        if section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Detergent"
                if let detergents = serviceModel?.detergents, detergents.count >= 2 {
                    let firstPreference = detergents[0]
                    let secondPreference = detergents[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: detergents)
                }
                return cell
            case 1:
                cell.titleLabel.text = "Wash"
                if let washes = serviceModel?.wash, washes.count >= 2 {
                    let firstPreference = washes[0]
                    let secondPreference = washes[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: washes)
                }
                return cell
            case 2:
                cell.titleLabel.text = "Dry"
                if let drys = serviceModel?.drying, drys.count >= 2 {
                    let firstPreference = drys[0]
                    let secondPreference = drys[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: drys)
                }
                return cell
            case 3:
                cell.titleLabel.text = "Bleach"
                if let bleach = serviceModel?.bleach, bleach.count >= 2 {
                    let firstPreference = bleach[0]
                    let secondPreference = bleach[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: bleach)
                }
                return cell
            case 4:
                cell.titleLabel.text = "Softner"
                if let softner = serviceModel?.softner, softner.count >= 2 {
                    let firstPreference = softner[0]
                    let secondPreference = softner[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: softner)
                }
                return cell
                
            default:
                cell.titleLabel.text = "Detergent"
                cell.leftImageView.image = UIImage(named: "scented")
                cell.leftLabel.text = "Scented"
                cell.rightImageView.image = UIImage(named: "nonScented")
                cell.rightLabel.text = "Non - Scented"
                return cell
            }
        }else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            return cell
        }else if section == 2 {
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
        else if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }
        else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }else if section == 2 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 92)
        }
        return CGSize(width: collectionView.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PreferencesCollectionReusableView", for: indexPath) as! PreferencesCollectionReusableView
                return headerView
            default:
                let view = UICollectionReusableView()
                return view
            }
            
        }
        return UICollectionReusableView()
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
    func removeTapGestures(forTextField textField:UITextField) {
        // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextField = activeTextField, activeTextField == textField {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    ///Delegate Function of TextView
    func sendImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
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
    //NoOfClothes Delegate Methods
    func textFieldStartedEditingInCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        if let text = textField.text, let intValue = Int(text) {
            serviceModel?.numberOfClothes = intValue
            prefernces.reloadData()
        }
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
            prefernces.reloadData()
        }
    }
}
