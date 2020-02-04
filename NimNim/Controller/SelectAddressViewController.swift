//
//  SelectAddressViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import NVActivityIndicatorView

class SelectAddressViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AddressNameCollectionViewCellDelegate,deliverynotesCollectionViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var activeTextView : UITextView?
    var cartModel : CartModel?
    var Index : IndexPath?
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    func addressSelectedChangeUI(withIndexPath indexPath: IndexPath?) {
        Index = indexPath
        selectAddressCollectionView.reloadData()
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
                    self?.cartModel?.deliveryRelatedUploadedImages.append(imagePath)
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
    //IBOutlets
    @IBOutlet weak var selectAddressCollectionView:UICollectionView!
    //IBActions
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var addressBaseModel : AddressModel?
    var noOfSavedAdderess : Int = 0 //initially
    
    
    @IBAction func selectTimeSlots(_ sender: Any) {
        cartModel?.deliveryPreference = UserDefaults.standard.object(forKey: UserDefaultKeys.pickUpDropOfPreferences) as! String
        if let savedAddress = cartModel?.addressId {
            let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                   let pickAndDropVC = SB.instantiateViewController(withIdentifier: "PickDateAndTimeViewController") as! PickDateAndTimeViewController
                   pickAndDropVC.cartModel = cartModel
                   NavigationManager.shared.push(viewController: pickAndDropVC)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "please select the address", preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                          self.present(alert, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        selectAddressCollectionView.delegate = self
        selectAddressCollectionView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        fetchSavedAddress()
        selectAddressCollectionView.reloadData()
        
    }
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    @objc func backViewTapped() {
           view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
       }
    func removeTapGestures(forTextView textView:UITextView) {
        // This function first checks if the textView that is passed is the currently active TextView or Not...if the user will tap somewhere outside then the textView passed will be equal to the activeTextView...but if the user will tap on another textView and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextView = activeTextView, activeTextView == textView {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
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
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "showSavedUserInfoCollectionViewCell", bundle: nil)
        selectAddressCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "showSavedUserInfoCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "AddressNameCollectionViewCell", bundle: nil)
        selectAddressCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "AddressNameCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "SavedAddressCollectionViewCell", bundle: nil)
        selectAddressCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SavedAddressCollectionViewCell")
        
        let type4PreferencesNib = UINib(nibName: "deliverynotesCollectionViewCell", bundle: nil)
               selectAddressCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "deliverynotesCollectionViewCell")
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
                cartModel?.deliveryNotes = textView.text
            }
        }
    }
    func fetchSavedAddress(){
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallAddrress, withParams: nil, withSuccess: {
            [weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let addressBaseModel = Mapper<AddressModel>().map(JSON: responseDict)
                self?.addressBaseModel = addressBaseModel //? is put after self as it is weak self.
                print(JSON(responseDict))
                if let count = addressBaseModel?.data?.count {
                    self?.noOfSavedAdderess = count
                }
                self?.selectAddressCollectionView.reloadData()
            }
             self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           self.activityIndicator.stopAnimating()
        } // definition of error closure
    }
    
    
    
    //MARK:Collection View Datasource Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = addressBaseModel?.data?.count {
            return count + 1 + 1 + 1 // addresses  + header + add new address cell + delivery note...
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showSavedUserInfoCollectionViewCell", for: indexPath) as! showSavedUserInfoCollectionViewCell
            if let number = addressBaseModel?.data?.count, number > 0
            {
                if number == 1 {
                    cell.noOfSavedAddress.text = "You currrently have \(1) saved address"
                }else {
                    cell.noOfSavedAddress.text = "You currrently have \(number) saved addresses"
                }
            }else {
                cell.noOfSavedAddress.text = "You currrently have \(0) saved addresses"
            }
            return cell
        }else if(indexPath.item == (numberOfItems  - 2)) {
            let savedAddressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedAddressCollectionViewCell", for: indexPath) as! SavedAddressCollectionViewCell
            savedAddressCell.bottomSeparator.isHidden = true
            return savedAddressCell
        }
            else if(indexPath.item == (numberOfItems  - 1)) {
            let savedAddressCell = collectionView.dequeueReusableCell(withReuseIdentifier: "deliverynotesCollectionViewCell", for: indexPath) as! deliverynotesCollectionViewCell
            savedAddressCell.delegate = self
            return savedAddressCell
            
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddressNameCollectionViewCell", for: indexPath) as! AddressNameCollectionViewCell
            if indexPath.item == addressBaseModel?.data?.count ?? 0{
                cell.bottomSeparator.isHidden = true
            }
            cell.delegate = self
            cell.cartModel = cartModel
            if Index == indexPath
            {
                cell.configureUI(forSelected: true, forIndex: indexPath)
            }
            else{
                cell.configureUI(forSelected: false, forIndex: indexPath)
            }
            let addressIndex = indexPath.item - 1
            cell.addressModel = self.addressBaseModel?.data?[addressIndex]  // main step where we are sending the address model to the small cell
            cell.locationLabel.text = self.addressBaseModel?.data?[addressIndex].label?.capitalized // to extract label
            var finalAddressString = ""
            if let house = self.addressBaseModel?.data?[addressIndex].house, house.count > 0 {
                finalAddressString = house
            }
            if let street = self.addressBaseModel?.data?[addressIndex].street, street.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(street)"
                }else {
                    finalAddressString = street
                }
            }
            if let area = self.addressBaseModel?.data?[addressIndex].area, area.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(area)"
                }else {
                    finalAddressString = area
                }
            }
            if let landmark = self.addressBaseModel?.data?[addressIndex].landmark, landmark.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(landmark)"
                }else {
                    finalAddressString = landmark
                }
            }
            if let city = self.addressBaseModel?.data?[addressIndex].city, city.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(city)"
                }else {
                    finalAddressString = city
                }
            }
            if let state = self.addressBaseModel?.data?[addressIndex].state, state.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(state)"
                }else {
                    finalAddressString = state
                }
            }
            if let pincode = self.addressBaseModel?.data?[addressIndex].pincode, pincode.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(pincode)"
                }else {
                    finalAddressString = pincode
                }
            }
            if let phone = self.addressBaseModel?.data?[addressIndex].phone, phone.count > 0 {
                if finalAddressString.count > 0 {
                    finalAddressString = "\(finalAddressString), \(phone)"
                }else {
                    finalAddressString = phone
                }
            }
            cell.addressLabel.text = finalAddressString
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.size.width, height:60)
        }
        else if(indexPath.item == (numberOfItems  - 2)) {
            return CGSize(width: collectionView.frame.size.width, height:50)
        }
            else if(indexPath.item == (numberOfItems  - 1)) {
                return CGSize(width: collectionView.frame.size.width, height:175)
            }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height:90)
        }
    }
    
}
