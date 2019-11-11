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

class MyLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    //MARK:IBOutlets
    
    @IBOutlet weak var pin: UIImageView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var currentLocationSelected: UILabel!
    @IBOutlet weak var bottomShadowView: UIView!
    @IBOutlet weak var topShadowView: UIView!
    @IBOutlet weak var useThisLocationButton: UIButton!
    
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
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topShadowView.addBottomShadowToView()
        bottomShadowView.addAllCornersShadowToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUseThisLocationButton() {
        if let selectedPath = selectedIndexPath {
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
            self.locationManager.stopUpdatingLocation()
            long = location.coordinate.longitude
            lat = location.coordinate.latitude
            checkForServiceableLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
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
            for i in 0..<locations.count {
                let location = locations[i]
                if let latitude = location.lat, let longitude = location.long, let radius = location.radius {
                    if let doubleLat = Double(latitude), let doubleLong = Double(longitude) , let doubleRadius = Double(radius) {
                        let circularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong), radius:  doubleRadius, identifier: "")
                        if let lat = lat, let long = long { //our location
                            if circularRegion.contains(CLLocationCoordinate2D(latitude: lat, longitude: long)) {
                                // This means that the user's location lies under this location model...
                                locationModel = location //This is used to globally save this location...when user taps on detect my location...for further local storage...
                                selectedIndexPath = IndexPath(row: i, section: 0)
                                currentLocationSelected.text = location.title
                                fallsUnderSomeLocation = true
                                locationTableView.reloadData()
                            }
                        }
                    }
                }
            }
            if !fallsUnderSomeLocation {
                let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
                let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"NonServiceable") as? NonServiceable
                NavigationManager.shared.push(viewController: secondViewController)
            }
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
        
        NetworkingManager.shared.get(withEndpoint: Endpoints.serviceableLocations, withParams: nil, withSuccess: {[weak self] (response) in
            if let responseDict = response as? [String:Any] {
                let serviceableLocationModel = Mapper<ServiceableLocationModel>().map(JSON: responseDict)
                self?.serviceableLocationModel = serviceableLocationModel
                self?.reloadTable()
            }
        }) //definition of success closure
        { (error) in
            
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
        if let selected = selectedIndexPath {
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
        selectedIndexPath = indexPath
        locationTableView.reloadData()
        if let locationArray = serviceableLocationModel?.data {
            let location = locationArray[indexPath.row]
            locationModel = location //This is used to globally save this location...when user taps on it...for further local storage...
            currentLocationSelected.text = location.title
        }
    }
}






