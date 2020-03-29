//
//  AllServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NimNimViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NeedRushDeliveryCollectionViewCellDelegate,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activeTextView : UITextView?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var isRushDeliverySelected = false
    
    //TODO: Replace this everywhere...
    var servicesModel = ServiceBaseModel.fetchFromUserDefaults()
    var services:[ServiceModel] = []
    var uploadedImages:[String] = []
    var specialNotes:String?
    
    ///Delegate Function of TextView
    let acceptedAliases:[String] = [
        "wash-and-air-dry",
        "laundered-shirts",
        "household-items",
        "dry-cleaning",
        "wash-and-fold"
    ]
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
        addObservers()
    }
    
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
    
    func textViewEndedEditingInCell(withTextField textView: UITextView) {
        removeTapGestures(forTextView: textView)
        if let currentText = textView.text {
            if !(currentText.caseInsensitiveCompare("Any Special Notes...") == .orderedSame) {
                specialNotes = textView.text
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
    
    
    func upload(image:UIImage?) {
        guard let image = image else {
            return
        }
        let uploadModel = UploadModel()
        uploadModel.data = image.jpegData(compressionQuality: 1.0)
        uploadModel.name = "image"
        uploadModel.fileName = "jpg"
        uploadModel.mimeType = .imageJpeg
        activityIndicator?.startAnimating()
        NetworkingManager.shared.upload(withEndpoint: Endpoints.uploadImage, withModel: uploadModel, withSuccess: {[weak self] (response) in
            self?.view.showToast(message: "Image uploaded successfully")
            if let responseDict = response as? [String:Any] {
                if let imagePath = responseDict["path"] as? String, imagePath.count > 0 {
                    self?.uploadedImages.append(imagePath)
                    self?.collectionView.reloadData()
                }
            }
            self?.activityIndicator?.stopAnimating()
            }, withProgress: { (progress) in
                
                print(progress?.fractionCompleted)
        }) {[weak self] (error) in
            print(error)
            self?.activityIndicator?.stopAnimating()
        }
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        services = fetchServicesToShow() //main function
        collectionView.reloadData()
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        // add to cart...and open order review screen.
        
            
        addToCart(withServiceModels: services)
    }
    
    func addToCart(withServiceModels services:[ServiceModel]?) {
        if let services = services {
            let selectedServices = services.filter { (serviceModel) -> Bool in
                return serviceModel.isSelectedForNimNimIt
            }
            if selectedServices.count < 1  {
                let alert = UIAlertController(title: "Alert", message: "Please select atleast one service", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                               self.present(alert, animated: true, completion: nil)
            }
            var finalArray:[[String:Any]] = []
            for service in selectedServices {
                if service.alias == "wash-and-air-dry" {
                    service.setupNimNimItForWashAndAirDry()
                }else if service.alias == "wash-and-fold" {
                    service.setupNimNimItForWashAndFold()
                }else if service.alias == "laundered-shirts" {
                    service.setupNimNimItForWashPressedShirts()
                }
                service.isRushDeliverySelected = isRushDeliverySelected
                service.specialNotes = specialNotes
                service.uploadedImages = uploadedImages
                let priceOfService = service.calculatePriceForService()
                service.servicePrice = priceOfService
                let jsonDict = service.toJSON()
                finalArray.append(jsonDict)
            }
            if let cartId = UserDefaults.standard.string(forKey: UserDefaultKeys.cartId), cartId.count > 0 {
                updateCart(fromArray: finalArray, withCartId: cartId)
            }
            else
                {
                if let firstItem = finalArray.first  {
                    addServicesToCart(withArray: [firstItem])
                }
            }
        }
    }
    
    func updateCart(fromArray array:[[String:Any]], withCartId  cartId:String?) {
        if let cartId = cartId {
            let dispatchGroup = DispatchGroup()
            for item in array  {
                dispatchGroup.enter()
                updateServicesInCart(withCartId: cartId, andService: item, withDispatchGroup: dispatchGroup)
            }
            dispatchGroup.notify(queue: .main) {[weak self] in
                self?.openOrderReview()
            }
        }
    }
    
    func updateServicesInCart(withCartId cartId:String?, andService service:[String:Any], withDispatchGroup dispatchGroup:DispatchGroup?) {
        if let cartId = cartId{
            var service = service
            service["cart_id"] = cartId
            activityIndicator.startAnimating()
            NetworkingManager.shared.put(withEndpoint: Endpoints.updateCart, withParams: service, withSuccess: {[weak self] (response) in
                if let response = response as? [String:Any] {
                    if let cartId = response["cart_id"] as? String {
                        UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    }
                    if let services = self?.services  {
                        let selectedServices = services.filter { (serviceModel) -> Bool in
                            return serviceModel.isSelectedForNimNimIt
                        }
                        let aliases = selectedServices.map { (serviceModel) -> String in
                            return serviceModel.alias ?? ""
                        }
                        for alias in aliases  {
                            addServiceToCartAliasinUserDefaults(withAlias: alias) // to make alias
                        }
                    }
                }
                Events.fireAddedToCart(withType: "NimNimIt")
                dispatchGroup?.leave()
                self?.activityIndicator.stopAnimating()
            }) {[weak self] (error) in
                print("error")
                dispatchGroup?.leave()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func addServicesToCart(withArray array:[[String:Any]]) {
        activityIndicator.startAnimating()
        var params : [String:Any] = [:]/// - dictionary
        params[AddToCart.services] = array///the params of add to cart is key value pair. Key is "services" and value is an array of dictianary.
        NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
            if let response = response as? [String:Any] {
                if let cartId = response["cart_id"] as? String {
                    UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    if let services = self?.services  {
                        let selectedServices = services.filter { (serviceModel) -> Bool in
                            return serviceModel.isSelectedForNimNimIt // the sserviceson which user has tapped
                        }
                        let aliases = selectedServices.map { (serviceModel) -> String in
                            return serviceModel.alias ?? ""
                        }
                        for alias in aliases  {
                            addServiceToCartAliasinUserDefaults(withAlias: alias) // to make alias
                        }
                        let selectedServicesBarringFirst = Array(selectedServices.dropFirst()) //  to eliminate first
                        
                        self?.addToCart(withServiceModels: selectedServicesBarringFirst)
                        
                        Events.fireAddedToCart(withType: "NimNimIt")
                    }
                }
                
            }
            self?.activityIndicator.stopAnimating()
        }) {[weak self] (error) in
            print("error")
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func openOrderReview() {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)

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
                collectionView.contentInset = UIEdgeInsets(top: collectionView.contentInset.top, left: collectionView.contentInset.left, bottom: addedHeight, right: collectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            collectionView.contentInset = UIEdgeInsets(top: collectionView.contentInset.top, left: collectionView.contentInset.left, bottom: 0, right: collectionView.contentInset.right)
            isHeightAdded = false
        }
    }
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?)
    {
        isRushDeliverySelected  = !isRushDeliverySelected
        collectionView.reloadData()
    }
    
    func registerCells(){
        let type1PreferencesNib = UINib(nibName: "ServiceCollectionViewCell", bundle: nil)
        collectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        let type2PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        collectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        collectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        }
    
    func fetchServicesToShow() -> [ServiceModel] {
        var servicesData:[ServiceModel] = []
        if let services =  servicesModel?.data  {
            let resultArray = services.filter { (service) -> Bool in
                if let isNimNimItAvailable = service.isNimNimItAvailable, let alias = service.alias {
                    if isNimNimItAvailable == true && !checkIfInCart(withAlias: alias) && acceptedAliases.contains(alias)  {
                        return true
                    }else{
                        return false
                    }
                }
                return false
            }
            servicesData = resultArray
        }
        return servicesData
    } //the above function basically first gets all the services from the backend.  It then creates a result array of the services to be shown in justNimNimIt by using the filter functioon.
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return services.count
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
            if services.count > indexPath.item {
                let service = services[indexPath.item]
                cell.serviceName.text = services[indexPath.item].name
                cell.serviceDescription.text = services[indexPath.item].descrip
                cell.alias = services[indexPath.row].alias
                if let url = services[indexPath.row].icon {
                    if let urlValue = URL(string: url)
                    {
                        cell.serviceImage.kf.setImage(with: urlValue)
                    }
                }
                
                if service.isSelectedForNimNimIt {
                    cell.serviceName.textColor = UIColor.white
                    cell.serviceDescription.textColor = UIColor.white
                    cell.backgroundCurvedView.backgroundColor = Colors.nimnimServicesColor
                    cell.selectLabel.backgroundColor = UIColor.white
                    cell.selectLabel.text = "Edit"
                    cell.selectLabel.textColor = Colors.nimnimServicesColor
                } else {
                    cell.serviceName.textColor = UIColor.black
                    cell.serviceDescription.textColor = UIColor.black
                    cell.selectLabel.backgroundColor = Colors.nimnimServicesColor
                    cell.backgroundCurvedView.backgroundColor = UIColor.white
                    cell.selectLabel.text = "Select"
                    cell.selectLabel.textColor = UIColor.white
                }
            }
            
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.configureUI(forRushDeliveryState: isRushDeliverySelected, forIndex: indexPath)
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            cell.firstImage.alpha = 0
            cell.secondImage.alpha = 0
            cell.thirdImage.alpha = 0
            if uploadedImages.count > 0 {
                if let urlValue = URL(string: uploadedImages[0])
                {
                    cell.firstImage.kf.setImage(with: urlValue)
                    cell.firstImage.alpha = 1
                }}
                if uploadedImages.count > 1 {
                if let urlValue = URL(string: uploadedImages[1])
                {
                    cell.secondImage.kf.setImage(with: urlValue)
                    cell.secondImage.alpha = 1
                    }}
               if uploadedImages.count > 2 {
                 if let urlValue = URL(string: uploadedImages[2])
                {
                    cell.thirdImage.kf.setImage(with: urlValue)
                    cell.thirdImage.alpha = 1
                }
            }
            cell.notesTextBox.text = specialNotes
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0  {
            return CGSize(width: collectionView.frame.size.width/2 - 25, height:266)
        }else if indexPath.section == 1  {
            return CGSize(width: collectionView.frame.size.width, height :95)
        }else  {
            if uploadedImages.count  > 0 {
                 return CGSize(width:collectionView.frame.size.width,height:191)
            }
            else {
              return CGSize(width:collectionView.frame.size.width,height:120)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  indexPath.section == 0
        {
            if services.count > indexPath.item {
                let service = services[indexPath.item]
                service.isSelectedForNimNimIt = !service.isSelectedForNimNimIt
                collectionView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        }else {
            return UIEdgeInsets.zero
        }
    }
    
}
