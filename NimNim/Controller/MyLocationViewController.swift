//
//  MyLocationViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation
import NVActivityIndicatorView

protocol MyLocationViewControllerDelegate:class {
    func selectedLocation(withModel model:LocationModel?)
}

class MyLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    //MARK:IBOutlets
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var currentLocationSelected: UILabel!
    @IBOutlet weak var bottomShadowView: UIView!
    @IBOutlet weak var topShadowView: UIView!
    @IBOutlet weak var useThisLocationButton: UIButton!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    //MARK: Variables and Constants
    let locationManager = CLLocationManager()
    var long : Double?
    var lat : Double?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var selectedIndexPath: IndexPath? {
        didSet {
            setupUseThisLocationButton()
        }
    }
    var serviceableLocationModel:ServiceableLocationModel?
    var locationModel:LocationModel?
    var isFromAddress = false
    weak var delegate:MyLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationList()
        fetchServiceableLocations()
        setupUseThisLocationButton()
        locationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 132, right: 0)
        setupTextField()
        addObservers()
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBackView.layer.applySketchShadow(color: Colors.nimnimLocationShadowColor, alpha: 0.24, x: 0, y: 19, blur: 38, spread: 2)
        bottomShadowView.layer.applySketchShadow(color: Colors.nimnimLocationShadowColor, alpha: 0.24, x: 0, y: 0, blur: 13, spread: 0)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//when keyboard will come , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) //when keyboard will go , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil) //when keyboard change from one number pad to another , this notification will be called.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            isHeightAdded = false
            addedHeight = 0
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isHeightAdded {
                if !isHeightAdded {
                    addedHeight = keyboardSize.height
                    locationTableView.contentInset = UIEdgeInsets(top: locationTableView.contentInset.top, left: locationTableView.contentInset.left, bottom: addedHeight + 132, right: locationTableView.contentInset.right)
                    isHeightAdded = true
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            locationTableView.contentInset = UIEdgeInsets(top: locationTableView.contentInset.top, left: locationTableView.contentInset.left, bottom: 132, right: locationTableView.contentInset.right)
            isHeightAdded = false
        }
    }
    
    func setupTextField() {
        searchTextField.delegate = self
    }
    
    func setupUseThisLocationButton() {
        if let _ = selectedIndexPath {
            useThisLocationButton.backgroundColor = Colors.nimnimButtonBorderGreen
            useThisLocationButton.isUserInteractionEnabled = true
        }else {
            currentLocationSelected.text = "Detect my location"
            useThisLocationButton.backgroundColor = UIColor.lightGray
            useThisLocationButton.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            self.locationManager.stopUpdatingLocation()
            long = location.coordinate.longitude
            lat = location.coordinate.latitude
            serviceableLocationModel?.resetText()
            reloadTable()
            //Dispatch Queue so that serviceability is checked after reload...
            DispatchQueue.main.async {[weak self] in
                self?.checkForServiceableLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("hello")
        }
    }
    
    func checkForServiceableLocation() {
        if let locations = serviceableLocationModel?.filteredData, locations.count > 0 {
            var fallsUnderSomeLocation = false
            var distance:Double?
            for i in 0..<locations.count {
                let location = locations[i]
                if let latitude = location.lat, let longitude = location.long, let radius = location.radius {
                    if let doubleLat = Double(latitude), let doubleLong = Double(longitude) , let doubleRadius = Double(radius) {
                        let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong), radius:  doubleRadius, identifier: "")
                        if let lat = lat, let long = long { //our location
                            let currentLocation = CLLocation(latitude: lat, longitude: long)
                            if circularRegion.contains(CLLocationCoordinate2D(latitude: lat, longitude: long)) {
                                // This means that the user's location lies under this location model...
                                let locationOfRegion = CLLocation(latitude: doubleLat, longitude: doubleLong)
                                let value = currentLocation.distance(from: locationOfRegion)
                                
                                if isValueLessThanDistance(withValue: value, withDistance: distance) {
                                    distance = value
                                    locationModel = location //This is used to globally save this location...when user taps on detect my location...for further local storage...
                                    selectedIndexPath = IndexPath(row: i, section: 0)
                                    currentLocationSelected.text = location.title
                                    fallsUnderSomeLocation = true
                                    locationTableView.reloadData()
                                    
                                    DispatchQueue.main.async {[weak self] in
                                        if let selectedIndexPath = self?.selectedIndexPath, let numberOfItems = self?.locationTableView.numberOfRows(inSection: 0), selectedIndexPath.item < numberOfItems {
                                            self?.locationTableView.scrollToRow(at: selectedIndexPath, at: .middle, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if !fallsUnderSomeLocation {
                let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
                let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"NonServiceable") as? NonServiceable
                NavigationManager.shared.push(viewController: secondViewController) //if the location of user does not fall in the radius of servicable locations , the non servoable screen will be pushed.
            }
        }
    }
    
    func isValueLessThanDistance(withValue value:Double?, withDistance distance:Double?) -> Bool {
        if let value = value, let distance = distance  {
            return (value < distance)
        }else {
            return true
        }
    }
    
    func setupLocationList()
    {
        locationTableView.delegate = self
        locationTableView.dataSource = self
    }
    
    func reloadTable() {
        locationTableView.reloadData()
    }
    
    func fetchServiceableLocations() {
        
       activityIndicator.startAnimating()
       NetworkingManager.shared.get(withEndpoint: Endpoints.serviceableLocations, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
           if let responseDict = response as? [String:Any] {
              let serviceableLocationModel = Mapper<ServiceableLocationModel>().map(JSON: responseDict)
               self?.serviceableLocationModel = serviceableLocationModel
               self?.reloadTable()
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
    } //calling of get
    
    
    //MARK:IBActions
    @IBAction func useThisLocation(_ sender: Any) {
        if let locationModel = locationModel {
            if isFromAddress {
                delegate?.selectedLocation(withModel: locationModel)
                navigationController?.popViewController(animated: true)
            }else {
                locationModel.saveInUserDefaults()//time of actual saving of loccation model
                let preferencesSB = UIStoryboard(name: "LoginSignup", bundle: nil)
                let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"LoginSignUpViewController") as? LoginSignUpViewController
                NavigationManager.shared.push(viewController: secondViewController)
            }
        }else {
            let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"NonServiceable") as? NonServiceable
            NavigationManager.shared.push(viewController: secondViewController)
        }
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }else {
             locationManager.requestWhenInUseAuthorization()
             locationManager.startUpdatingLocation()
        }
        selectedIndexPath = nil
        locationTableView.reloadData()
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let preferencesSB = UIStoryboard(name: "LoginSignup", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"LoginSignUpViewController") as? LoginSignUpViewController
        NavigationManager.shared.push(viewController: secondViewController)
        
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locationArray = serviceableLocationModel?.filteredData {
            return locationArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationcCell", for: indexPath) as! LocationcCell
        if let locationArray = serviceableLocationModel?.filteredData {
            let location = locationArray[indexPath.row]
            cell.locationName.text = location.title
            cell.locationPincode.text = location.pincode
        }
        if let selected = selectedIndexPath { //if selectedIndexPath has a value  assign that value to selected and then in the next line do comparison. The selectedIndexPath can be assigned value in two cases: 1.Whenever the user taps on a cell. 2.Here where our actual location comes in the radius of the locations provided by the backend.   selectedIndexPath = IndexPath(row: i, section: 0)
            if selected == indexPath
            {
                cell.setupcell(forState: true)
            }
            else{
                cell.setupcell(forState: false)
            }
        }
        else
        {
            cell.setupcell(forState: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath // the selected index path is sent in selectedindexPath
        locationTableView.reloadData()
        if let locationArray = serviceableLocationModel?.filteredData {
            let location = locationArray[indexPath.row]
            locationModel = location //This is used to globally save this location...when user taps on it...for further local storage...
            currentLocationSelected.text = location.title
        }
    }
}


extension MyLocationViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) //To shut the keyboard// this function is called when the user is pressing the return button
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    } // built in delegate function of textfield
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    } // built in delegate function of textfield
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        selectedIndexPath = nil
        serviceableLocationModel?.currentText = nil
        reloadTable()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This function is changing the font of the textField to montserratMedium/20 as soon as the user starts typing into the textField...and changing it back to montserratRegular/14 when the text is cleared or rubbed completely....
        // range =
        
        //Here we are converting NSRange to Range using the NSRange value passed above...and the current textField text...we have done this because the function "replacingCharacters" used below expects a Range Value and not NSRange value...
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            //Here, we are using the range and text values to determine the upcoming string inside the textfield...this will enable to setup the font beforehand....
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            selectedIndexPath = nil
            serviceableLocationModel?.currentText = updatedText
            reloadTable()
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}



