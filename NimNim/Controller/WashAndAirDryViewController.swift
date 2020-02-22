////
////  WashAndAirDryViewController.swift
////  NimNim
////
////  Created by Raghav Vij on 10/10/19.
////  Copyright © 2019 NimNim. All rights reserved.

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import Kingfisher

class WashAndAirDryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NoofClothesCollectionViewCellDelegate {
    

    var activeTextField : UITextField?
    var defaultStateJustNimNimIt : Bool = false
    //NoOfClothes Delegate Methods
    func textFieldStartedEditingInCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        if let text = textField.text, let intValue = Int(text) {
            serviceModel?.numberOfClothes = intValue
            UserDefaults.standard.set(intValue , forKey : "noOfClothes")
            washAndAirDryCollectionView.reloadData()
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
    
    
    
    
    //IBOutlets
    @IBOutlet weak var washAndAirDryCollectionView: UICollectionView!
    @IBOutlet weak var washAndAirDryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    
    @IBOutlet weak var justNimNimIt: UIButton!
    var justNimNimItSelected : Bool = false
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
      
        
        let type4PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        let type5PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell")
        let type6PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        washAndAirDryCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        washAndAirDryCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        washAndAirDryCollectionView.delegate = self
        washAndAirDryCollectionView.dataSource = self
        if let name = serviceModel?.name {
            washAndAirDryLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        if let priceOfService = serviceModel?.calculatePriceForService() {
            priceLabel.text = priceOfService
            serviceModel?.servicePrice = priceOfService
        }
        setupAddToCartButton()
        setupCartCountLabel()
        addObservers()
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
                washAndAirDryCollectionView.contentInset = UIEdgeInsets(top: washAndAirDryCollectionView.contentInset.top, left: washAndAirDryCollectionView.contentInset.left, bottom: washAndAirDryCollectionView.contentInset.bottom + addedHeight, right: washAndAirDryCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            washAndAirDryCollectionView.contentInset = UIEdgeInsets(top: washAndAirDryCollectionView.contentInset.top, left: washAndAirDryCollectionView.contentInset.left, bottom: washAndAirDryCollectionView.contentInset.bottom - addedHeight, right: washAndAirDryCollectionView.contentInset.right)
            isHeightAdded = false
        }
    }
    
    func setupAddToCartButton(){
        
            addToCart.setTitle("Add to Cart", for: .normal)
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
    
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        setupCartCountLabel()
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
 
                    self?.washAndAirDryCollectionView.reloadData()
                }
            }
            }, withProgress: { (progress) in
                
                print(progress?.fractionCompleted)
        }) {[weak self] (error) in
            self?.activityIndicator.stopAnimating()
            print(error)
        }
    }
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    @IBAction func justNimNimItTapped(_ sender: Any) {
        justNimNimItSelected = !justNimNimItSelected
        if justNimNimItSelected {
            justNimNimIt.backgroundColor = Colors.nimnimGreen
            justNimNimIt.setTitleColor(.white, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.extraBold16
            serviceModel?.setupNimNimItForWashAndAirDry()

        }
        else
        {
            justNimNimIt.backgroundColor = .white
            justNimNimIt.setTitleColor(Colors.nimnimGreen, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.regularFont14
            serviceModel?.undosetupNimNimItForWashAndAirDry()
            
        }
        washAndAirDryCollectionView.reloadData()
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
    //
    //        var params : [String:Any] = [:]
    //        var serviceParams : [String:Any] = [:]
    //
    //        if let name = serviceModel?.name {
    //            serviceParams[AddToCart.name] = name
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
    //        if let washes = serviceModel?.wash{
    //            var title : String?
    //            for wash in washes {
    //                if wash.isSelected == true {
    //                    title = wash.title
    //                       break
    //                }
    //            }
    //            if let title = title {
    //                serviceParams[AddToCart.wash] = ["title" : title]
    //            }
    //        }
    //        if let bleaches = serviceModel?.bleach{
    //            var title : String?
    //            for bleach in bleaches {
    //                if bleach.isSelected == true {
    //                    title = bleach.title
    //                      break
    //                }
    //
    //            }
    //            if let  title = title {
    //                serviceParams[AddToCart.bleach]  = ["title" : title]
    //            }
    //        }
    //        if let softners = serviceModel?.softner {
    //            var title : String?
    //            for softner in softners {
    //                if softner.isSelected == true {
    //                    title = softner.title
    //                    break
    //                }
    //
    //            }
    //            if let title = title {
    //                serviceParams[AddToCart.softner] = ["title" : title]
    //            }
    //        }
    //        //special notes
    //        //speical notes image
    //        //image
    //
    //        if let price = serviceModel?.price {
    //            serviceParams[AddToCart.price] = price
    //        }
    //
    //        if let pricing = serviceModel?.pricing {
    //            serviceParams[AddToCart.pricing] = pricing
    //        }
    //
    //        params[AddToCart.services] = [serviceParams]
    //        //JSON is a dictionary because of the {}. The JSON is containing key services and the value is an array of dictionary. In our case this array will be having only one dictionary because wee will be adding only one service to cart. This dictionary in our code iss service params.
    //        print(JSON(params))
    //        activityIndicator.startAnimating()
    //        NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
    //            self?.addToCart.setTitle("CheckOut", for: .normal)
    //            self?.IsAddToCartTapped = true
    //            self?.washAndAirDryCollectionView.reloadData()
    //            print("success")
    //            DispatchQueue.main.async {[weak self] in
    //                if let numberOfSections = self?.washAndAirDryCollectionView.numberOfSections {
    //                    let lastSection = numberOfSections - 1
    //                    self?.washAndAirDryCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
    //                }
    //            }
    //            self?.activityIndicator.stopAnimating()
    //        }) {[weak self] (error) in
    //            print("error")
    //            self?.activityIndicator.stopAnimating()
    //        }
    //    }
    func updateServiceInCart(withCartId cartId:String?) {
        if let serviceModel = serviceModel, let cartId = cartId{
            var modelToDictionary = serviceModel.toJSON()
            modelToDictionary["cart_id"] = cartId
            print(JSON(modelToDictionary))
            if serviceModel.validateAddToCartForService() {
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("CheckOut", for: .normal)
                self?.IsAddToCartTapped = true
                self?.washAndAirDryCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                        addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                        self?.setupCartCountLabel()
                    }
                }
                
                print("success")
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.washAndAirDryCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.washAndAirDryCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                    }
                }
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                self?.activityIndicator.stopAnimating()
            }
            }
            else {
                //  Show Alertf...
                let alert = UIAlertController(title: "Alert", message: "Please choose all the required preferences or simply click Just NimNim It.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
        }
    }
    
    func addServiceToCart() {
        if let serviceModel = serviceModel /// this is received from serviceBase collection view cells(//passing of the service model to the vc. as written)
        {
            if serviceModel.validateAddToCartForService() {
               let modelToDictionary = serviceModel.toJSON() // model in dictationary
                           activityIndicator.startAnimating()
                           var params : [String:Any] = [:]/// - dictionary
                           params[AddToCart.services] = [modelToDictionary]///the params of add to cart is key value pair. Key is "services" and value is an array of dictianary.
                           print(JSON(params))
                           NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
                               self?.addToCart.setTitle("CheckOut", for: .normal)//alamofire is conveerting dictionary to JSON
                               self?.IsAddToCartTapped = true
                               self?.washAndAirDryCollectionView.reloadData()
                               if let response = response as? [String:Any] {
                                   if let cartId = response["cart_id"] as? String {
                                       UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                                   }
                                   addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias) // to make alias
                                   self?.setupCartCountLabel()
                               }
                               print("success")
                               DispatchQueue.main.async {[weak self] in
                                   if let numberOfSections = self?.washAndAirDryCollectionView.numberOfSections {
                                       let lastSection = numberOfSections - 1
                                       self?.washAndAirDryCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                                   }
                               }
                               self?.activityIndicator.stopAnimating()
                           }) {[weak self] (error) in
                               print("error")
                               self?.activityIndicator.stopAnimating()
                           }
            }else {
                //  Show Alertf...
                let alert = UIAlertController(title: "Alert", message: "Please choose all the required preferences or simply click Just NimNim It.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }else if section == 1 {
            if let count = serviceModel?.uploadedImages.count , count  > 0  {
                return CGSize(width: collectionView.frame.size.width, height:191)
            }
            else
            {
                return CGSize(width: collectionView.frame.size.width, height:120)
            }
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
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PreferencesCollectionReusableView", for: indexPath) as! PreferencesCollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
        
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 4 }
        else
        {
            return 3 }// preferences, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
               return 3
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
                cell.titleLabel.text = "Wash"
                if let washes = serviceModel?.wash, washes.count >= 2 {
                    let firstPreference = washes[0]
                    let secondPreference = washes[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: washes)
                }
                return cell
                
            case 1 :
                cell.titleLabel.text = "Bleach"
                if let bleach = serviceModel?.bleach, bleach.count >= 2 {
                    let firstPreference = bleach[0]
                    let secondPreference = bleach[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: bleach)
                }
                return cell
            case 2 :
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
        }
        if section == 1 {
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
        else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RushDeliveryNotAvailableCollectionViewCell", for: indexPath) as! RushDeliveryNotAvailableCollectionViewCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreServicesCollectionViewCell", for: indexPath) as! AddMoreServicesCollectionViewCell
            return cell
            
        }
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
    
    
}
