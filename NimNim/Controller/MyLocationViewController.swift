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

class MyLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    //MARK:IBOutlets
    
    @IBOutlet weak var pin: UIImageView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var currentLocationSelected: UILabel!
    @IBOutlet weak var bottomShadowView: UIView!
    @IBOutlet weak var topShadowView: UIView!
    @IBOutlet weak var useThisLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    //MARK: Variables and Constants
    let locationManager = CLLocationManager()
    var long : Double?
    var lat : Double?
    
    var selectedIndexPath: IndexPath? {
        didSet {
            setupUseThisLocationButton()
        }
    }
    var serviceableLocationModel:ServiceableLocationModel?
    var locationModel:LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationList()
        fetchServiceableLocations()
        setupUseThisLocationButton()
        locationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 132, right: 0)
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topShadowView.layer.applySketchShadow(color: Colors.nimnimLocationShadowColor, alpha: 0.24, x: 0, y: 19, blur: 38, spread: 2)
        bottomShadowView.layer.applySketchShadow(color: Colors.nimnimLocationShadowColor, alpha: 0.24, x: 0, y: 0, blur: 13, spread: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUseThisLocationButton() {
        if let _ = selectedIndexPath {
            useThisLocationButton.backgroundColor = Colors.nimnimButtonBorderGreen
            useThisLocationButton.isUserInteractionEnabled = true
        }else {
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
            checkForServiceableLocation()
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
        if let locations = serviceableLocationModel?.data, locations.count > 0 {
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
            locationModel.saveInUserDefaults()//time of actual saving of loccation model
            let preferencesSB = UIStoryboard(name: "LoginSignup", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"LoginSignUpViewController") as? LoginSignUpViewController
            NavigationManager.shared.push(viewController: secondViewController)
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
        if let locationArray = serviceableLocationModel?.data {
            return locationArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationcCell", for: indexPath) as! LocationcCell
        if let locationArray = serviceableLocationModel?.data {
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
        if let locationArray = serviceableLocationModel?.data {
            let location = locationArray[indexPath.row]
            locationModel = location //This is used to globally save this location...when user taps on it...for further local storage...
            currentLocationSelected.text = location.title
        }
    }
}






