//
//  AllServicesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 15/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NimNimViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NeedRushDeliveryCollectionViewCellDelegate,SpecialNotesCollectionViewCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var activeTextView : UITextView?
    
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
                //serviceModel?.specialNotes = textView.text
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
//          guard let image = image else {
//              return
//          }
//          let uploadModel = UploadModel()
//          uploadModel.data = image.jpegData(compressionQuality: 1.0)
//          uploadModel.name = "image"
//          uploadModel.fileName = "jpg"
//          uploadModel.mimeType = .imageJpeg
//          activityIndicator.startAnimating()
//          NetworkingManager.shared.upload(withEndpoint: Endpoints.uploadImage, withModel: uploadModel, withSuccess: {[weak self] (response) in
//              self?.view.showToast(message: "Image uploaded successfully")
//              self?.activityIndicator.stopAnimating()
//              if let responseDict = response as? [String:Any] {
//                  if let imagePath = responseDict["path"] as? String, imagePath.count > 0 {
//                      self?.serviceModel?.uploadedImages.append(imagePath)
//                      }
//              }
//              self?.activityIndicator.stopAnimating()
//
//          }, withProgress: { (progress) in
//
//              print(progress?.fractionCompleted)
//          }) {[weak self] (error) in
//              self?.activityIndicator.stopAnimating()
//              print(error)
//          }
      }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //TODO: Replace this everywhere...
    var servicesModel = ServiceBaseModel.fetchFromUserDefaults()
    var services:[ServiceModel] = []
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        collectionView.reloadData()
        
    }
    
    @IBAction func selectAddressTapped(_ sender: Any) {
        //  add to cart ....and open order review screen.
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        services = servicesModel?.data ?? []
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    func rushDeliveryTapped(withIndexPath indexPath: IndexPath?)
    {
//        if let rushDeliveryState = serviceModel?.isRushDeliverySelected {
//            serviceModel?.isRushDeliverySelected = !rushDeliveryState
//            collectionView.reloadData()
//        }
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
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
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
            if let servicesModel = ServiceBaseModel.fetchFromUserDefaults() {
                if let services = servicesModel.data {
                    cell.serviceName.text = services[indexPath.row].name
                    cell.serviceDescription.text = services[indexPath.row].descrip
                    cell.alias = services[indexPath.row].alias
                    if let url = services[indexPath.row].icon {
                        if let urlValue = URL(string: url)
                        {
                            cell.serviceImage.kf.setImage(with: urlValue)
                        }
                    }
                }
                
                return cell
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedRushDeliveryCollectionViewCell", for: indexPath) as! NeedRushDeliveryCollectionViewCell
            cell.delegate = self
//            cell.configureUI(forRushDeliveryState: serviceModel?.isRushDeliverySelected ?? false, forIndex: indexPath)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0  {
            return CGSize(width: collectionView.frame.size.width/2 - 25, height:266)
        }else if indexPath.section == 1  {
            return CGSize(width: collectionView.frame.size.width, height :95)
        }else  {
            return CGSize(width:collectionView.frame.size.width,height:134)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  indexPath.section == 0
        {
            
            
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
