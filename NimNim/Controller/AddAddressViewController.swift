//
//  AddAddressViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AddAddressCollectionViewCellDelegate {

    @IBOutlet weak var addAddressCollectionView: UICollectionView!
    
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var office: UIButton!
    

        
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
            }else {
                resetButtons()
                office.isSelected = true
                office.titleLabel?.font = Fonts.semiBold16
                office.setTitleColor(UIColor.white, for: .normal)
                addAddressCollectionView.reloadData()
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
    var phoneNumber: String?
    
    
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
    
    func postAddress(streetAddress : String?, houseBlockNumber : String?,city : String?,state : String?,zipcode : String?,enterLandmark : String?,phoneNumber: String?){
        guard let streetAddress = streetAddress , let houseBlockNumber =  houseBlockNumber ,let city = city, let state = state, let zipcode = zipcode, let enterLandmark = enterLandmark, let phoneNumber = phoneNumber else {
            return
        }
        
        
        let params:[String:Any] = [
            AddAddress.streetAddress:streetAddress,
            AddAddress.houseBlockNumber:houseBlockNumber,
            AddAddress.city:city,
            AddAddress.state:state,
            AddAddress.zipcode:zipcode,
            AddAddress.enterLandmark:enterLandmark,
            AddAddress.phoneNumber:phoneNumber,
        ]
        
        NetworkingManager.shared.post(withEndpoint: Endpoints.addCard, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                print(responseDict)
                print("hello")
            }
            
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                print("wrong")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    
    
    
    @IBAction func addAddressTapped(_ sender: Any) {
        
        postAddress(streetAddress: streetAddress, houseBlockNumber: houseBlockNumber, city: city, state: state, zipcode: zipcode, enterLandmark: enterLandmark, phoneNumber: phoneNumber)
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
        addAddressCollectionView.delegate = self
        addAddressCollectionView.dataSource = self
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
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER STREET ADDRESS"
            cell.indexPath = indexPath // This is used to set the var property defined in the cell defination. It is later used to give the data of the text field to the right param parameter based on the indexPath.
            return cell
        }
        else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER HOUSE/BLOCK NUMBER"
            cell.indexPath = indexPath
            return cell
        }
        else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "CITY"
            cell.indexPath = indexPath
            return cell
            
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "STATE"
            cell.indexPath = indexPath
            return cell
        }
        else if indexPath.item == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ZIPCODE"
            cell.indexPath = indexPath
            return cell
        }
            
        else if indexPath.item == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "ENTER LANDMARK"
            cell.indexPath = indexPath
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAddressCollectionViewCell", for: indexPath) as! AddAddressCollectionViewCell
            cell.label.text = "PHONE NUMBER"
            cell.indexPath = indexPath
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
        }
        else if indexPath.item == 1 {
        houseBlockNumber = text
        }
        else if indexPath.item == 2 {
         city = text
            
        }
        else if indexPath.item == 3 {
        state = text
        }
        else if indexPath.item == 4 {
         zipcode = text
        }
        else if indexPath.item == 5 {
          enterLandmark = text
        }
        else {
          phoneNumber = text
        }
    }
    
    func textFieldStartedEditingInAddAddressCollectionViewCell(withTextField textField: UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInAddAddressCollectionViewCell(withTextField textField: UITextField) {
        removeTapGestures(forTextField: textField)
        
    }
}
