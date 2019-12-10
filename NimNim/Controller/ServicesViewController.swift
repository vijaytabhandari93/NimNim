//
//  ServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 04/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ServicesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,NoofClothesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NeedRushDeliveryCollectionViewCellDelegate{
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        prefernces.delegate = self
        prefernces.dataSource = self
        if let name = serviceModel?.name {
            washAndFoldLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        if let priceOfService = serviceModel?.price {
            priceLabel.text = "\(priceOfService)"
        }
        
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
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
        addServiceToCart()
    }
    
    func addServiceToCart() {
        var params:[String:Any] = [:]
        var serviceParams:[String:Any] = [:]
        if let name = serviceModel?.name {
            serviceParams[AddToCart.name] = name
        }
        if let alias = serviceModel?.alias {
            serviceParams[AddToCart.alias] = alias
        }
        if let icon = serviceModel?.icon {
            serviceParams[AddToCart.icon] = icon
        }
        if let description = serviceModel?.descrip {
            serviceParams[AddToCart.description] = description
        }
        serviceParams[AddToCart.ordering] = 1
        
        if let detergents = serviceModel?.detergents {
            var title:String?
            
            for detergent in detergents {
                if detergent.isSelected == true {
                    title = detergent.title
                }
                break
            }
            
            if let title = title {
                serviceParams[AddToCart.detergents] = [
                    "title":title
                ]
            }
        }
        
        if let wash = serviceModel?.wash {
            var title:String?
            
            for item in wash {
                if item.isSelected == true {
                    title = item.title
                }
                break
            }
            
            if let title = title {
                serviceParams[AddToCart.wash] = [
                    "title":title
                ]
            }
        }
        
        if let drying = serviceModel?.drying {
            var title:String?
            
            for item in drying {
                if item.isSelected == true {
                    title = item.title
                }
                break
            }
            
            if let title = title {
                serviceParams[AddToCart.drying] = [
                    "title":title
                ]
            }
        }
        
        if let bleach = serviceModel?.bleach {
            var title:String?
            
            for item in bleach {
                if item.isSelected == true {
                    title = item.title
                }
                break
            }
            
            if let title = title {
                serviceParams[AddToCart.bleach] = [
                    "title":title
                ]
            }
        }
        
        if let softner = serviceModel?.softner {
            var title:String?
            
            for item in softner {
                if item.isSelected == true {
                    title = item.title
                }
                break
            }
            
            if let title = title {
                serviceParams[AddToCart.softner] = [
                    "title":title
                ]
            }
        }
        
        if let price = serviceModel?.price {
            serviceParams[AddToCart.price] = price
        }
        
        if let pricing = serviceModel?.pricing {
            serviceParams[AddToCart.pricing] = pricing
        }
        
        if let rushDeliveryOptions = serviceModel?.rushDeliveryOptions, rushDeliveryOptions.count > 0 {
            let firstOption = rushDeliveryOptions[0]
            if let turnAroundTime = firstOption.turnAroundTime, let price = firstOption.price {
                let rushDict:[String:Any] = [
                    "turn_around_time":turnAroundTime,
                    "price":price
                ]
                serviceParams[AddToCart.rushDeliveryOptions] = [rushDict] // array of rush delivery options
            }
        }
        
        if let isRushDeliverySelected = serviceModel?.isRushDeliverySelected {
            serviceParams[AddToCart.needRushDelivery] = isRushDeliverySelected
        }
        
            params[AddToCart.services] = [serviceParams]
        
        activityIndicator.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.addToCart, withParams: params, withSuccess: {[weak self] (response) in
            self?.addToCart.setTitle("CheckOut", for: .normal)
            self?.IsAddToCartTapped = true
            self?.prefernces.reloadData()
            DispatchQueue.main.async {[weak self] in
                if let numberOfSections = self?.prefernces.numberOfSections {
                    let lastSection = numberOfSections - 1
                    self?.prefernces.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                }
            }
            self?.activityIndicator.stopAnimating()
        }) {[weak self] (error) in
            
            self?.activityIndicator.stopAnimating()
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
        
        let type5PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        prefernces.register(type5PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        prefernces.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if IsAddToCartTapped{
            return 5
        }
        else
        {
            return 4
            
        }//number of clothes, preferences, special notes, rush delivery, add more services
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 5
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoofClothesCollectionViewCell", for: indexPath) as! NoofClothesCollectionViewCell
            if let numberOfClothes = serviceModel?.numberOfClothes {
                cell.noOfPieces.text = "\(numberOfClothes)"
            }
            cell.delegate = self
            return cell
        }else if section == 1 {
            
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
        }else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            return cell
        }else if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.delegate = self
            cell.labelAgainsCheckbox.text = "I need Rush Delivery"
            cell.configureUI(forRushDeliveryState: serviceModel?.isRushDeliverySelected ?? false)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:58)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }else if section == 2 {
            return CGSize(width: collectionView.frame.size.width, height:134)
        }else if section == 3 {
            return CGSize(width: collectionView.frame.size.width, height:95)
        }else if section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:48)
        }
        return CGSize(width: collectionView.frame.size.width, height:0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 92)
        }
        return CGSize(width: collectionView.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 1 {
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
    func rushDeliveryTapped() {
        if let rushDeliveryState = serviceModel?.isRushDeliverySelected {
            serviceModel?.isRushDeliverySelected = !rushDeliveryState
            prefernces.reloadData()
        }
    }
}
