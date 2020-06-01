//
//  AddAddressViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddAddressViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AddAddressCollectionViewCellDelegate {

    @IBOutlet weak var addAddressCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var model : AddressDetailsModel? // used for editing function
    var editTapped : Bool = false // used for editing function
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var office: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    
    var label : String?
        
    enum SelectionType: Int {
        case house
        case office
    }
    var selectedState:SelectionType! {
        didSet {
            if selectedState == .house {
                resetButtons()
                home.isSelected = true
                home.titleLabel?.font = Fonts.semiBold16
                home.setTitleColor(UIColor.white, for: .normal)
                addAddressCollectionView.reloadData()
                label = "house"
            }else {
                resetButtons()
                office.isSelected = true
                office.titleLabel?.font = Fonts.semiBold16
                office.setTitleColor(UIColor.white, for: .normal)
                addAddressCollectionView.reloadData()
                label = "office"
                
            }
        }
    }
    
    var activeTextField:UITextField?
    var streetAddress : String?
    var houseBlockNumber : String?
    var city : String?
    var state : String?
    var zipcode : String?
    var enterLandmark : String?
    var id: String?
    
    func resetButtons() {
        home.isSelected = false
        office.isSelected = false
        home.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        office.titleLabel?.font = Fonts.regularFont12
        home.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        office.titleLabel?.font = Fonts.regularFont12
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        selectedState = .house
    }
    @IBAction func officeTapped(_ sender: Any) {
        selectedState = .office
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
                addAddressCollectionView.contentInset = UIEdgeInsets(top: addAddressCollectionView.contentInset.top, left: addAddressCollectionView.contentInset.left, bottom: addedHeight, right: addAddressCollectionView.contentInset.right)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            addAddressCollectionView.contentInset = UIEdgeInsets(top: addAddressCollectionView.contentInset.top, left: addAddressCollectionView.contentInset.left, bottom: 0, right: addAddressCollectionView.contentInset.right)
            isHeightAdded = false
        }
    }
    func postAddress(streetAddress : String?, houseBlockNumber : String?,city : String?,state : String?,zipcode : String?,enterLandmark : String?,label:String?){
        guard let streetAddress = streetAddress , let houseBlockNumber =  houseBlockNumber ,let city = city, let state = state, let zipcode = zipcode, let label = label else {
            let alert = UIAlertController(title: "Alert", message: "Please fill all the mandatory fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        var params:[String:Any] = [
            AddAddress.streetAddress:streetAddress,
            AddAddress.houseBlockNumber:houseBlockNumber,
            AddAddress.city:city,
            AddAddress.state:state,
            AddAddress.zipcode:zipcode,
            AddAddress.label:label
        ]
        
        if let enterLandmark = enterLandmark {
            params[AddAddress.enterLandmark] = enterLandmark
        }
        
        activityIndicator.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.addAddress, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                print(responseDict)
                print("hello")
            }
            Events.fireAddedAddressSuccess()
            
            self.navigationController?.popViewController(animated: true)
             self.activityIndicator.stopAnimating()
        }) { (error) in
            
            Events.fireAddedAddressFailure()
            
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                print("wrong")
                self.present(alert, animated: true, completion: nil)
            }
             self.activityIndicator.stopAnimating()
        }
    }
    
    func putAddress(streetAddress : String?, houseBlockNumber : String?,city : String?,state : String?,zipcode : String?,enterLandmark : String?,label:String?,id:String?) {
        guard let streetAddress = streetAddress , let houseBlockNumber =  houseBlockNumber ,let city = city, let state = state, let zipcode = zipcode, let label = label, let id = id else {
            return
        }
        
        let params:[String:Any] = [
            AddAddress.streetAddress:streetAddress,
            AddAddress.houseBlockNumber:houseBlockNumber,
            AddAddress.city:city,
            AddAddress.state:state,
            AddAddress.zipcode:zipcode,
            AddAddress.enterLandmark:enterLandmark ?? "",
            AddAddress.label:label,
            AddAddress.id:id
        ]
        activityIndicator.startAnimating()
        NetworkingManager.shared.put(withEndpoint: Endpoints.addAddress, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                print(responseDict)
                print("hello")
            }
            self.navigationController?.popViewController(animated: true)
             self.activityIndicator.stopAnimating()
        }) { (error) in
            
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                print("wrong")
                self.present(alert, animated: true, completion: nil)
            }
             self.activityIndicator.stopAnimating()
        }
        
    }

    @IBAction func addAddressTapped(_ sender: Any) {
        if editTapped{
            putAddress(streetAddress: streetAddress, houseBlockNumber: houseBlockNumber, city: city, state: state, zipcode: zipcode, enterLandmark: enterLandmark,label:label, id: id)
        }else {
            postAddress(streetAddress: streetAddress, houseBlockNumber: houseBlockNumber, city: city, state: state, zipcode: zipcode, enterLandmark: enterLandmark,label:label)
        }
    }
    
    func removeTapGestures(forTextField textField:UITextField) {
        // This function first checks if the textField that is passed is the currently active TextField or Not...if the user will tap somewhere outside then the textField passed will be equal to the activeTextField...but if the user will tap on another textField and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextField = activeTextField, activeTextField == textField {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        selectedState = .house
        addAddressCollectionView.delegate = self
        addAddressCollectionView.dataSource = self
        if editTapped == true {
            setUpUIForEditState()
        }else {
            model = AddressDetailsModel()
        }
        addObservers()
    }
    func setUpUIForEditState()
    {
        stackView.isHidden = true
        addAddressButton.setTitle("Edit Address", for: .normal)
        addressLabel.text = "Edit Address"
        topBarHeightConstraint.constant = 45.0
        id = model?.id
        streetAddress = model?.street
        houseBlockNumber = model?.house
        city = model?.city
        state = model?.state
        label = model?.label
        zipcode = model?.pincode
        enterLandmark = model?.landmark

    }
    
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "AddAddressCollectionViewCell", bundle: nil)
        addAddressCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AddAddressCollectionViewCell")
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height:71)
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "ENTER STREET ADDRESS"
            cell.addressText.text = model?.street // editing function
            cell.delegate = self
            cell.indexPath = indexPath // This is used to set the var property defined in the cell defination. It is later used to give the data of the text field to the right param parameter based on the indexPath.
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "ENTER APARTMENT NUMBER"
            cell.addressText.text = model?.house
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "CITY"
            cell.addressText.text = model?.city
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
            
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "STATE"
            cell.addressText.text = model?.state
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = true
            cell.label.text = "ZIPCODE"
            cell.addressText.text = model?.pincode
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
        else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "ENTER LANDMARK (optional)"
            cell.addressText.text = model?.landmark
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.isPincode = false
            cell.label.text = "PHONE NUMBER"
            cell.addressText.text = model?.phone
            cell.delegate = self
            cell.indexPath = indexPath
            if cell.addressText.text == nil || cell.addressText.text == ""  {
                cell.animateToBottom()
            }else {
                cell.animateToTop()
            }
            return cell
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textEntered(withText text: String?, withIndexPath indexPath: IndexPath?) {
        guard let text = text, let indexPath = indexPath else {
            return
        }
        if indexPath.item == 0 {
            streetAddress = text
            model?.street = text
        }
        else if indexPath.item == 1 {
            houseBlockNumber = text
            model?.house = text
        }
        else if indexPath.item == 2 {
            city = text
            model?.city = city
        }
        else if indexPath.item == 3 {
            state = text
            model?.state =  state
        }
        else if indexPath.item == 4 {
            zipcode = text
        }
        else {
            enterLandmark = text
            model?.landmark = enterLandmark
        }
        addAddressCollectionView.reloadData()
    }
    
    func textFieldStartedEditingInAddAddressCollectionViewCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInAddAddressCollectionViewCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        
    }
    
    func pincodeTapped() {
        let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"MyLocationViewController") as? MyLocationViewController
        secondViewController?.isFromAddress = true
        secondViewController?.delegate = self
        view.endEditing(true)
        NavigationManager.shared.push(viewController: secondViewController)
    }
}

extension AddAddressViewController:MyLocationViewControllerDelegate  {
    func selectedLocation(withModel model: LocationModel?) {
        if let locationModel = model {
            self.model?.pincode = locationModel.pincode
            zipcode = locationModel.pincode
            addAddressCollectionView.reloadData()
            view.endEditing(true)
        }
    }
}
