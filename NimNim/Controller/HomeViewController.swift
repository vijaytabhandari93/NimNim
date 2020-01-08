//
//  HomeViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 26/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:IBOutlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    var bannerModel : BannersBaseModel?
    var serviceModel : ServiceBaseModel?
    
    @IBOutlet weak var basketLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(fetchValidPickupDates())
        registerCells()
        fetchBanners()
        fetchServices()
        // Read Vijayta - Doing fetchCart below to ensure that services that are in cart get synced with the servicesAliasArray every time the app launches... this will also solve the issue that when a user logs out and logs in again then initially all his user defaults are erased... so this will ensure that his previously saved cart items are highlighted on this screen as well when he logs back in...
        fetchCart()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let UserObject = UserModel.fetchFromUserDefaults()
        if let abc = UserObject?.firstName {
        userName.text = "Hello \(abc.capitalized)"
        }
        setupCartCountLabel()
 
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        homeCollectionView.reloadData()
        setupCartCountLabel()
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
    //MARK:UI Methods
    func registerCells() {
        let bannersBaseNib = UINib(nibName: "BannersBaseCollectionViewCell", bundle: nil)
        homeCollectionView.register(bannersBaseNib, forCellWithReuseIdentifier: "BannersBaseCollectionViewCell")
        let servicesBaseNib = UINib(nibName: "ServicesBaseCollectionViewCell", bundle: nil)
        homeCollectionView.register(servicesBaseNib, forCellWithReuseIdentifier: "ServicesBaseCollectionViewCell")
        let headerNib = UINib(nibName: "ServicesHeaderCollectionReusableView", bundle: nil)
        homeCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ServicesHeaderCollectionReusableView")
    }
    
    //MARK: Networking Methods
    func fetchBanners() {
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.banners, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let bannerModel = Mapper<BannersBaseModel>().map(JSON: responseDict)
                self?.bannerModel = bannerModel //? is put after self as it is weak self.
                self?.homeCollectionView.reloadData()
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
    
    func fetchServices() {
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.services, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let serviceModel = Mapper<ServiceBaseModel>().map(JSON: responseDict)
                self?.serviceModel = serviceModel //? is put after self as it is weak self.
                self?.serviceModel?.saveInUserDefaults()
                self?.homeCollectionView.reloadData()
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
    
    func fetchCart() {
        guard let cartId = UserDefaults.standard.object(forKey: UserDefaultKeys.cartId) as? String, cartId.count > 0 else{
            return
        }
        NetworkingManager.shared.get(withEndpoint: Endpoints.fetchCart, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...//in this get call the user Auth token thee cart is being fetched.
            if let responseDict = response as? [String:Any] { //Alamofire is throwing the response as dictionary .....we are convertig it to model
                let cartModel = Mapper<CartModel>().map(JSON: responseDict)
                
                //VRead Vijayta - The code below loops over all the services that are there in the user's cart and adds the services to aliases array if not already present (if not already present logic is there in addServiceToCartAliasinUserDefaults function)... that function ensures that services are not added again if already present...
                if let services = cartModel?.services {
                    for service in services {
                        addServiceToCartAliasinUserDefaults(withAlias: service.alias)
                    }
                }
                if let cartId = cartModel?.cartId {
                    UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    // from server we are fetching the cart id.
                }
                self?.setupCartCountLabel()
                self?.homeCollectionView.reloadData()
            }
            self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }


    //MARK: IBActions
    @IBAction func basketTapped(_UI sender: Any) {
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "OrderReviewViewController")
        NavigationManager.shared.push(viewController: orderReviewVC)
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannersBaseCollectionViewCell", for: indexPath) as! BannersBaseCollectionViewCell
            cell.configureCell(withModel: bannerModel) //To pass the banneer model to the cell.
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesBaseCollectionViewCell", for: indexPath) as! ServicesBaseCollectionViewCell
             cell.configureCell(withModel: serviceModel) //To pass the banneer model to the cell.
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height:150)
        }
        else
        {
            return CGSize(width: self.view.frame.width, height:228)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 85)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ServicesHeaderCollectionReusableView", for: indexPath) as! ServicesHeaderCollectionReusableView
            return headerView
            
        default:
            let view = UICollectionReusableView()
            return view
        }
    }
}

