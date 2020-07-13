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

class RugCleaningViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NoofClothesCollectionViewCellDelegate {
    

    var activeTextField : UITextField?
    var justNimNimItSelected : Bool = false
    
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
            rugCleaningCollectionView.reloadData()
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
    @IBOutlet weak var rugCleaningCollectionView: UICollectionView!
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
    
    //MARK:UI Methods
    func registerCells() {
        let type2PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        let type6PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier:"AddMoreServicesCollectionViewCell")
        
        let type5PreferencesNib = UINib(nibName: "RushDeliveryNotAvailableCollectionViewCell", bundle: nil)
        rugCleaningCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier:"RushDeliveryNotAvailableCollectionViewCell")
        
//        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
//        rugCleaningCollectionView.register(headerNib, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier:"PreferencesCollectionReusableView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        rugCleaningCollectionView.delegate = self
        rugCleaningCollectionView.dataSource = self
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
        if let isNimNimItSelected = serviceModel?.isSelectedForNimNimIt {
            justNimNimItSelected = isNimNimItSelected
            setupUIForNimNimIt()
        }else {
            justNimNimItSelected = false
            setupUIForNimNimIt()
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
        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            isHeightAdded = false
            addedHeight = 0
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isHeightAdded {
                addedHeight = keyboardSize.height
                rugCleaningCollectionView.contentInset = UIEdgeInsets(top: rugCleaningCollectionView.contentInset.top, left: rugCleaningCollectionView.contentInset.left, bottom: addedHeight, right: rugCleaningCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            rugCleaningCollectionView.contentInset = UIEdgeInsets(top: rugCleaningCollectionView.contentInset.top, left: rugCleaningCollectionView.contentInset.left, bottom: 0, right: rugCleaningCollectionView.contentInset.right)
            isHeightAdded = false
        }
    }
    
    func setupAddToCartButton(){
        if let alias = serviceModel?.alias {
            if checkIfInCart(withAlias: alias) {
                addToCart.setTitle("Done", for: .normal)
            }else {
                addToCart.setTitle("Add to Cart", for: .normal)
            }
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
     
                    self?.rugCleaningCollectionView.reloadData()
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
    
    func setupUIForNimNimIt() {
        if justNimNimItSelected {
            justNimNimIt.backgroundColor = Colors.nimnimGreen
            justNimNimIt.setTitleColor(.white, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.extraBold16
            serviceModel?.isSelectedForNimNimIt = true
        }
        else
        {
            justNimNimIt.backgroundColor = .white
            justNimNimIt.setTitleColor(Colors.nimnimGreen, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.regularFont14
            serviceModel?.isSelectedForNimNimIt = false
        }
    }
    
    @IBAction func justNimNimItTapped(_ sender: Any) {
        justNimNimItSelected = !justNimNimItSelected
        if justNimNimItSelected {
            justNimNimIt.backgroundColor = Colors.nimnimGreen
            justNimNimIt.setTitleColor(.white, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.extraBold16
            serviceModel?.isSelectedForNimNimIt = true
            serviceModel?.numberOfClothes = 0
        }
        else
        {
            justNimNimIt.backgroundColor = .white
            justNimNimIt.setTitleColor(Colors.nimnimGreen, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.regularFont14
            serviceModel?.isSelectedForNimNimIt = false
        }
        rugCleaningCollectionView.reloadData()
    }
    @IBAction func infoTapped(_ sender: Any) {
        let jnnvc = self.storyboard?.instantiateViewController(withIdentifier: "JustNimNimInfoViewController") as! JustNimNimInfoViewController
        jnnvc.titleValue = "Just NimNim It \n Carpet Cleaning"
        jnnvc.descriptionValue = "Tap here to choose this option and we’ll take care of everything, from counting the number of rugs, folding them up, and replacing them on delivery"
        present(jnnvc, animated: true, completion: nil)
    }
    
    
    @IBAction func addToCartTapped(_ sender: Any) {
        if addToCart.titleLabel?.text == "Check Out" {
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
  
    func updateServiceInCart(withCartId cartId:String?) {
        if let serviceModel = serviceModel, let cartId = cartId{
            var modelToDictionary = serviceModel.toJSON()
            modelToDictionary["cart_id"] = cartId
            print(JSON(modelToDictionary))
            if serviceModel.validateAddToCartForService() {
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: modelToDictionary, withSuccess: {[weak self] (response) in
                self?.addToCart.setTitle("Check Out", for: .normal)
                self?.IsAddToCartTapped = true
                self?.rugCleaningCollectionView.reloadData()
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                        addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias)
                        self?.setupCartCountLabel()
                    }
                }
                
                print("success")
                Events.fireAddedToCart(withType: serviceModel.alias)
                DispatchQueue.main.async {[weak self] in
                    if let numberOfSections = self?.rugCleaningCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.rugCleaningCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
                let alert = UIAlertController(title: "Alert", message: "Please enter the rug quantity or simply choose Just NimNim It.", preferredStyle: .alert)
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
                               self?.addToCart.setTitle("Check Out", for: .normal)//alamofire is conveerting dictionary to JSON
                               self?.IsAddToCartTapped = true
                               self?.rugCleaningCollectionView.reloadData()
                               if let response = response as? [String:Any] {
                                   if let cartId = response["cart_id"] as? String {
                                       UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                                   }
                                   addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias) // to make alias
                                   self?.setupCartCountLabel()
                               }
                               print("success")
                            Events.fireAddedToCart(withType: serviceModel.alias)
                               DispatchQueue.main.async {[weak self] in
                                   if let numberOfSections = self?.rugCleaningCollectionView.numberOfSections {
                                       let lastSection = numberOfSections - 1
                                       self?.rugCleaningCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                                   }
                               }
                               self?.activityIndicator.stopAnimating()
                           }) {[weak self] (error) in
                               print("error")
                               self?.activityIndicator.stopAnimating()
                           }
            }else {
                //  Show Alertf...
                let alert = UIAlertController(title: "Alert", message: "Please enter the rug quantity or simply choose Just NimNim It.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:88)
        }else if section == 1 {
         if let count = serviceModel?.uploadedImages.count , count  > 0{
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
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 1 {
//            return CGSize(width: collectionView.frame.size.width, height: 92)
//        }
//        return CGSize(width: collectionView.frame.size.width, height: 0)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PreferencesCollectionReusableView", for: indexPath) as! PreferencesCollectionReusableView
//            return headerView
//        default:
//            let view = UICollectionReusableView()
//            return view
//        }
//
//    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 4 }
        else
        {
            return 3 }//number of clothes, preferences, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if justNimNimItSelected {
                return 0
                
            } else
            {
                return 1
            }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            cell.titleLabel.text = "Number of Rugs"
            cell.delegate = self
            cell.noOfPieces.text = UserDefaults.standard.object(forKey: "noOfClothes") as? String
            return cell
        }
            
        else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            cell.firstImage.alpha = 0
            cell.secondImage.alpha = 0
            cell.thirdImage.alpha = 0
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 0 {
                if let urlValue = URL(string: ImageNames[0])
                {
                    cell.firstImage.alpha = 1
                    cell.firstImage.kf.setImage(with: urlValue)
                }
                
            }
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 1 {
                if let urlValue = URL(string: ImageNames[1])
                {
                    cell.secondImage.alpha = 1
                    cell.secondImage.kf.setImage(with: urlValue)
                }
            }
            if let ImageNames =  serviceModel?.uploadedImages, ImageNames.count > 2 {
                if let urlValue = URL(string: ImageNames[2])
                {
                    cell.thirdImage.alpha = 1
                    cell.thirdImage.kf.setImage(with: urlValue)
                }
            }
            if let notes = serviceModel?.specialNotes {
                cell.notesTextBox.text = notes
            }else {
                cell.notesTextBox.text = cell.placeholderText
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
        return UICollectionViewCell()
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
        let alert = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Choose from Photo Library", style: .default) {[weak self] (action) in
            self?.choosePhotoFromLibrary()
        }
        
        let cameraAction = UIAlertAction(title: "Click with Camera", style: .default) {[weak self] (action) in
            self?.clickPhotoWithCamera()
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(cameraAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func clickPhotoWithCamera() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .camera
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

