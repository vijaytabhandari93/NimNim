//
//  ShoeRepairViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


protocol ShoeRepairSecondViewControllerDelegate:class {
    func addShoeRepairTask(withTask taskModel:TaskModel?)
}

class ShoeRepairSecondViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SpecialNotesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ShoeRepairCollectionViewCellDelegate,DropDownCollectionViewCellDelegate {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var shoeRepairCollectionView: UICollectionView!
    @IBOutlet weak var shoeRepairLabel: UILabel!
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    enum SelectionType: Int {
        case women
        case men
    }
    var activeTextView : UITextView?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var selectedDropDownIndex:Int?
    weak var delegate:ShoeRepairSecondViewControllerDelegate?
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .women {
                resetButtons()
                womenButton.isSelected = true
                womenButton.titleLabel?.font = Fonts.semiBold16
                womenButton.setTitleColor(UIColor.white, for: .normal)
                shoeRepairCollectionView.reloadData()
            }else {
                resetButtons()
                menButton.isSelected = true
                menButton.titleLabel?.font = Fonts.semiBold16
                menButton.setTitleColor(UIColor.white, for: .normal)
                shoeRepairCollectionView.reloadData()
            }
        }
    }
    var serviceModel:ServiceModel?
    var taskModel:TaskModel?
    
    @IBAction func AddSShoereepairTaskTapped(_ sender: Any) {
        delegate?.addShoeRepairTask(withTask: taskModel)
        navigationController?.popViewController(animated: true)
    }
    //MARK:View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTaskModel()
        registerCells()
        shoeRepairCollectionView.delegate = self
        shoeRepairCollectionView.dataSource = self
        selectedState = .women
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
    }
    
    func resetButtons() {
        menButton.isSelected = false
        womenButton.isSelected = false
        menButton.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        menButton.titleLabel?.font = Fonts.regularFont12
        womenButton.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        womenButton.titleLabel?.font = Fonts.regularFont12
    }
    
    func setupTaskModel() {
        if taskModel == nil {
            taskModel = TaskModel(JSON: [:])
            if let items = serviceModel?.items {
                for item in items {
                    if let itemCopy = item.copy() as? ItemModel {
                        itemCopy.isSelectedShoeRepairPreference = false
                        taskModel?.items.append(itemCopy)
                    }
                }
            }
            selectedDropDownIndex = 0
            taskModel?.gender = "male"
        }
        
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
                shoeRepairCollectionView.contentInset = UIEdgeInsets(top: shoeRepairCollectionView.contentInset.top, left: shoeRepairCollectionView.contentInset.left, bottom: shoeRepairCollectionView.contentInset.bottom + addedHeight, right: shoeRepairCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            shoeRepairCollectionView.contentInset = UIEdgeInsets(top: shoeRepairCollectionView.contentInset.top, left: shoeRepairCollectionView.contentInset.left, bottom: shoeRepairCollectionView.contentInset.bottom - addedHeight, right: shoeRepairCollectionView.contentInset.right)
            isHeightAdded = false
        }
    }
    
    //MARK: IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    
    @IBAction func basketTapped(_ sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
    }
    
    @IBAction func womenTapped(_ sender: Any) {
        selectedState = .women
    }
    
    @IBAction func menTapped(_ sender: Any) {
        selectedState = .men
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            //male/female
            return 1
        }else if section == 1  {
            //special  notes
            return 1
        }
        else {
            //prefs
            return taskModel?.getGenderSpecificItems().count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropDownCollectionViewCell", for: indexPath) as! DropDownCollectionViewCell
            cell.headingLabel.text = "Please select your type of shoe".uppercased()
            cell.configureCell(withOptions: ["Male","Female"], withSelectedIndex: selectedDropDownIndex)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialNotesCollectionViewCell", for: indexPath) as! SpecialNotesCollectionViewCell
            cell.delegate = self
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoeRepairCollectionViewCell", for: indexPath) as! ShoeRepairCollectionViewCell
            cell.actionLabel.text = taskModel?.getGenderSpecificItems()[indexPath.item].name
            if let price = taskModel?.getGenderSpecificItems()[indexPath.item].price {
                cell.priceLabel.text = "\(price)"
            }
            cell.delegate = self
            if let state = taskModel?.getGenderSpecificItems()[indexPath.item].isSelectedShoeRepairPreference
            {
                cell.configureUI(forPreferenceSelectedState: state, forIndex: indexPath)
            }
            return cell
        }
    }
    //MARK:UI Methods
    func registerCells() {
        let noOfClothesNib = UINib(nibName: "SpecialNotesCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(noOfClothesNib, forCellWithReuseIdentifier: "SpecialNotesCollectionViewCell")
        
        let dropDownCellNib = UINib(nibName: "DropDownCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(dropDownCellNib, forCellWithReuseIdentifier: "DropDownCollectionViewCell")
        
        let type1PreferencesNib = UINib(nibName: "ShoeRepairCollectionViewCell", bundle: nil)
        shoeRepairCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ShoeRepairCollectionViewCell")
        
        
        
        let headerNib = UINib(nibName: "PreferencesCollectionReusableView", bundle: nil)
        shoeRepairCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PreferencesCollectionReusableView")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 66)
        }
        else if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.size.width, height:191)
        }else {
            return CGSize(width: collectionView.frame.size.width, height:54)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 2  {
            return CGSize(width: collectionView.frame.size.width, height: 92)
        } else{
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
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
    
    //MARK: Networking Methods
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
                    self?.taskModel?.uploadedImages.append(imagePath)
                }
            }
            }, withProgress: { (progress) in
                
                print(progress?.fractionCompleted)
        }) {[weak self] (error) in
            self?.activityIndicator.stopAnimating()
            print(error)
        }
    }
    
    
    //MARK: SpecialNotesTableViewCellDelegate
    func sendImage(){// To tell the VC to send image post call
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    func textViewStartedEditingInCell(withTextField textView
        :UITextView){ // To tell the VC to add tap geture to the view and to pass the text View selected
        activeTextView = textView
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning//
    }
    
    func textViewEndedEditingInCell(withTextField textView : UITextView){ // To tell the VC to remove the tap gesture from the view and to pass the textview upon which end editing has been called
        removeTapGestures(forTextView: textView)
        if let currentText = textView.text {
            if !(currentText.caseInsensitiveCompare("Any Special Notes...") == .orderedSame) {
                taskModel?.specialNotes = textView.text
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
    func preferenceSelected(withIndexPath indexPath: IndexPath?) {
        if let indexPath = indexPath {
            if let state = taskModel?.getGenderSpecificItems()[indexPath.item].isSelectedShoeRepairPreference
            {
                taskModel?.getGenderSpecificItems()[indexPath.item].isSelectedShoeRepairPreference = !state
            }
        }
        shoeRepairCollectionView.reloadData()
    }
    
    //MARK: DropDownCollectionViewCellDelegate Methods
    func selectedDropDownValue(withValue value:String?, withIndex index:Int?) {
        print("male")
        if let value = value, value.caseInsensitiveCompare("male") == .orderedSame {
            taskModel?.gender = "male"
        }else {
            taskModel?.gender = "female"
        }
        selectedDropDownIndex = index
        shoeRepairCollectionView.reloadData()
    }
    
}
