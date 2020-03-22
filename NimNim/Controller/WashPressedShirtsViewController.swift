//
//  WashPressedShirtsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 12/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Kingfisher

class WashPressedShirtsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NeedRushDeliveryCollectionViewCellDelegate,NoofClothesCollectionViewCellDelegate,BoxedCollectionViewCellDelegate{
 
    var defaultStateJustNimNimIt : Bool = false
    var activeTextField : UITextField?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    //NoOfClothes Delegate Methods
    func textFieldStartedEditingInCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        if let text = textField.text, let intValue = Int(text) {
            serviceModel?.numberOfClothes = intValue
            WashPressedShirtCollectionView.reloadData()
            setupPrice()
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
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var WashAndPressedShirtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var WashPressedShirtCollectionView: UICollectionView!
    @IBOutlet weak var PriceTotalBackgroundView: UIView!
    
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    var serviceModel:ServiceModel?
    var IsAddToCartTapped : Bool = false
    var activeTextView : UITextView?
    @IBOutlet weak var justNimNimIt: UIButton!
    
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    //IBActions
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
    
    func setupNimNimItButton() {
        if defaultStateJustNimNimIt {
            justNimNimIt.backgroundColor = Colors.nimnimGreen
            justNimNimIt.setTitleColor(.white, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.extraBold16
            serviceModel?.setupNimNimItForWashPressedShirts()
            serviceModel?.isSelectedForNimNimIt = true
        }
        else
        {
            justNimNimIt.backgroundColor = .white
            justNimNimIt.setTitleColor(Colors.nimnimGreen, for: .normal)
            justNimNimIt.titleLabel?.font = Fonts.regularFont14
            serviceModel?.undoSetupNimNimItForWashPressedShirts()
            serviceModel?.isSelectedForNimNimIt = false
        }
    }
    
    @IBAction func justNimNimIt(_ sender: Any) {
        defaultStateJustNimNimIt = !defaultStateJustNimNimIt
        setupNimNimItButton()
        setupPrice()
        WashPressedShirtCollectionView.reloadData()
    }
    @IBAction func infoTapped(_ sender: Any) {
        let jnnvc = self.storyboard?.instantiateViewController(withIdentifier: "JustNimNimInfoViewController") as! JustNimNimInfoViewController
        jnnvc.titleValue = "Just Nim Nim It For \n Laundered Shirts"
        jnnvc.descriptionValue = "Choose Just NimNim It and we will take care of everything from counting shirts to delivering them on hangers."
        present(jnnvc, animated: true, completion: nil)
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
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
    
    func setupPrice() {
        if defaultStateJustNimNimIt {
            let price = "@Pricelist"
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
    //        if let detergents = serviceModel?.detergents {
    //            var title:String?
    //
    //            for detergent in detergents {
    //                if detergent.isSelected == true {
    //                    title = detergent.title
    //                    break
    //                }
    //
    //            }
    //
    //            if let title = title {
    //                serviceParams[AddToCart.detergents] = [
    //                    "title":title  // In this statement we are setting the "detergents" key of the serviceparam. The value to which it is set is itself a dictionary.
    //                ]
    //            }
    //        }
    //
    //        if let starch = serviceModel?.starch {
    //            var title:String?
    //
    //            for item in starch {
    //                if item.isSelected == true {
    //                    title = item.title
    //                    break
    //                }
    //
    //            }
    //
    //            if let title = title {
    //                serviceParams[AddToCart.starch] = [
    //                    "title":title
    //                ]
    //            }
    //        }
    //
    //        if let returnPreferences = serviceModel?.returnPreferences {
    //            var title:String?
    //
    //            for item in returnPreferences {
    //                if item.isSelected == true {
    //                    title = item.title
    //                    break
    //                }
    //
    //            }
    //
    //            if let title = title {
    //                serviceParams[AddToCart.drying] = [
    //                    "title":title
    //                ]
    //            }
    //        }
    //
    //
    //
    //        if let price = serviceModel?.price {
    //            serviceParams[AddToCart.price] = price
    //        }
    //
    //        if let pricing = serviceModel?.costPerPiece {
    //            serviceParams[AddToCart.pricing] = pricing
    //        }
    //        if let pricingPerBox = serviceModel?.costPerPieceBox{
    //                serviceParams[AddToCart.pricingBox] = pricingPerBox
    //        }
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
    //            self?.WashPressedShirtCollectionView.reloadData()
    //            print("success")
    //            DispatchQueue.main.async {[weak self] in
    //                if let numberOfSections = self?.WashPressedShirtCollectionView.numberOfSections {
    //                    let lastSection = numberOfSections - 1
    //                    self?.WashPressedShirtCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
                self?.addToCart.setTitle("Check Out", for: .normal)
                self?.IsAddToCartTapped = true
                self?.WashPressedShirtCollectionView.reloadData()
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
                    if let numberOfSections = self?.WashPressedShirtCollectionView.numberOfSections {
                        let lastSection = numberOfSections - 1
                        self?.WashPressedShirtCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
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
                let alert = UIAlertController(title: "Alert", message: "Please enter the number of shirts and choose all the required preferences or simply click Just NimNim It.", preferredStyle: .alert)
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
                               self?.WashPressedShirtCollectionView.reloadData()
                               if let response = response as? [String:Any] {
                                   if let cartId = response["cart_id"] as? String {
                                       UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                                   }
                                   addServiceToCartAliasinUserDefaults(withAlias: serviceModel.alias) // to make alias
                                   self?.setupCartCountLabel()
                               }
                            Events.fireAddedToCart(withType: serviceModel.alias)
                               print("success")
                               DispatchQueue.main.async {[weak self] in
                                   if let numberOfSections = self?.WashPressedShirtCollectionView.numberOfSections {
                                       let lastSection = numberOfSections - 1
                                       self?.WashPressedShirtCollectionView.scrollToItem(at: IndexPath(item: 0, section: lastSection), at: .centeredVertically, animated: true)
                                   }
                               }
                               self?.activityIndicator.stopAnimating()
                           }) {[weak self] (error) in
                               print("error")
                               self?.activityIndicator.stopAnimating()
                           }
            }else {
                //  Show Alertf...
                let alert = UIAlertController(title: "Alert", message: "Please enter the number of shirts and choose all the required preferences or simply click Just NimNim It.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
            }
           
        }
    }
    
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "NoofClothesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "NoofClothesCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "WashAndFoldPreferencesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "AddMoreServicesCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "AddMoreServicesCollectionViewCell")
        
        let type5PreferencesNib = UINib(nibName: "NeedRushDeliveryCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "NeedRushDeliveryCollectionViewCell")
        
        let type6PreferencesNib = UINib(nibName: "BoxedCollectionViewCell", bundle: nil)
        WashPressedShirtCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "BoxedCollectionViewCell")
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        WashPressedShirtCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
        
    }
    
    func preferenceTapped(){
        setupPrice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        
        if let name = serviceModel?.name {
            WashAndPressedShirtLabel.text = "\(name)"
        }
        if let description = serviceModel?.descrip {
            descriptionLabel.text = "\(description)"
        }
        WashPressedShirtCollectionView.delegate = self
        WashPressedShirtCollectionView.dataSource = self
        setupAddToCartButton()
        setupCartCountLabel()
        addObservers()
        if let isNimNimItSelected = serviceModel?.isSelectedForNimNimIt {
            defaultStateJustNimNimIt = isNimNimItSelected
            setupNimNimItButton()
        }else {
            defaultStateJustNimNimIt = false
            setupNimNimItButton()
        }
        setupPrice()
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
                WashPressedShirtCollectionView.contentInset = UIEdgeInsets(top: WashPressedShirtCollectionView.contentInset.top, left: WashPressedShirtCollectionView.contentInset.left, bottom: addedHeight, right: WashPressedShirtCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            WashPressedShirtCollectionView.contentInset = UIEdgeInsets(top: WashPressedShirtCollectionView.contentInset.top, left: WashPressedShirtCollectionView.contentInset.left, bottom: 0, right: WashPressedShirtCollectionView.contentInset.right)
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
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        PriceTotalBackgroundView.addTopShadowToView()
        setupCartCountLabel() 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
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
            return 5 }
        else
        {
            return 4 }//number of clothes, preferences, special notes, rush delivery, add more services
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if defaultStateJustNimNimIt {
                return 0
                
            } else
            {
                return 1
            }
        }else if section == 1 {
            return 2
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
            cell.delegate = self
            cell.titleLabel.text = "Number of Clothes"
            if let noOfClothes = serviceModel?.numberOfClothes {
                cell.noOfPieces.text = "\(noOfClothes)"
            }
            else {
                cell.noOfPieces.text = nil
            }
            return cell
            
        }
        else if section == 1 {
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
                cell.titleLabel.text = "Starch"
                if let starch = serviceModel?.starch, starch.count >= 2 {
                    let firstPreference = starch[0]
                    let secondPreference = starch[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: starch)
                }
                return cell
            case 1 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoxedCollectionViewCell", for: indexPath) as! BoxedCollectionViewCell
                cell.titleLabel.text = "Return Preference"
                cell.delegate = self
                if let returnPreferences = serviceModel?.returnPreferences,
                    returnPreferences.count == 2 {
                    
                    let firstPreference = returnPreferences[0]
                    let secondPreference = returnPreferences[1]
                    cell.leftLabel.text = firstPreference.title
                    cell.rightLabel.text = secondPreference.title
                    cell.configureCell(withPreferenceModelArray: returnPreferences)
                }
                if let boxPrice  = serviceModel?.costPerPieceBox , let piecePrice = serviceModel?.costPerPiece  {
                  var diff =  boxPrice - piecePrice
                  var cents = diff*100
                  var roundedCents = Int(cents)
                  cell.subLabel.text = " \(roundedCents) cents extra per shirt."
                }
             
                
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WashAndFoldPreferencesCollectionViewCell", for: indexPath) as! WashAndFoldPreferencesCollectionViewCell
                cell.titleLabel.text = "Detergent"
                cell.leftImageView.image = UIImage(named: "scented")
                cell.leftLabel.text = "Scented"
                cell.rightImageView.image = UIImage(named: "nonScented")
                cell.rightLabel.text = "Non - Scented"
                return cell
                
            }
        }
        if section == 2 {
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
        if section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.delegate = self
            cell.labelAgainsCheckbox.text = "I need Rush Delivery"
            cell.configureUI(forRushDeliveryState: serviceModel?.isRushDeliverySelected ?? false, forIndex: indexPath)
            if let arrayRushOptions = serviceModel?.rushDeliveryOptions, arrayRushOptions.count == 1 {
                let firstPreference = arrayRushOptions[0]
                if let hours  = firstPreference.turnAroundTime
                    ,let extraPrice = firstPreference.price
                { cell.descriptionofLabel.text = "Under rush delivery your clothes will be delivered with in \(hours) Hours"// and $\(extraPrice) will be charged extra for the same"
                    
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
            return CGSize(width: collectionView.frame.size.width, height:88)
        }else if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:104)
        }else if section == 2 {
             if let count = serviceModel?.uploadedImages.count , count  > 0 {
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
                    self?.WashPressedShirtCollectionView.reloadData()
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
    //MARK: NeedRushDeliveryCellDelegate
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?) {
        if let rushDeliveryState = serviceModel?.isRushDeliverySelected {
            serviceModel?.isRushDeliverySelected = !rushDeliveryState
            WashPressedShirtCollectionView.reloadData()
            setupPrice()
        }
    }
}





