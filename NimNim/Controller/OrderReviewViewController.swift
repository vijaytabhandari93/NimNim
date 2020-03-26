//
//  OrderReviewViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import NVActivityIndicatorView

class OrderReviewViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ServiceOrderStatusCollectionViewCellDelegate,ApplyWalletPointsCollectionViewCellDelegate{
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var pointsApplied : Bool = true
    var walletBalance : Int = 0
    
    var isCouponApplied : Bool = false
    var couponCode : String? 
    
    func applyPointsTapped(tapped: Bool) {
        pointsApplied  = tapped
        cartModel?.isWalletSelected  = pointsApplied
    }
    
    func fetchWalletPoints() {
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.fetchwalletbalance, withParams: nil, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let walletBalance = responseDict["balance"] as? Int {
                    self.walletBalance = walletBalance
                    self.orderStatusCollectionView.reloadData()
                    UserDefaults.standard.set(walletBalance, forKey: UserDefaultKeys.walletBalance)
                }
            }
            self.activityIndicator.stopAnimating()
        }) { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    
    //delegate function which is called when user taps on order details
    func orderDetails(withServiceModel model: ServiceModel?) {
        if let model = model  {
            let servicesStoryboard = UIStoryboard(name: "Services", bundle: nil)
            if model.alias == "wash-and-fold" {
                let washAndFoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
                washAndFoldVC.serviceModel = model.copy() as? ServiceModel //passing of the service model to the vc.
                NavigationManager.shared.push(viewController: washAndFoldVC)
                
            }else if model.alias == "wash-and-air-dry" {
                let washAndAirDryVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashAndAirDryViewController") as! WashAndAirDryViewController
                
                washAndAirDryVC.serviceModel = model.copy() as? ServiceModel
                NavigationManager.shared.push(viewController: washAndAirDryVC)
            }else if model.alias == "laundered-shirts" {
                let washPressedVC = servicesStoryboard.instantiateViewController(withIdentifier: "WashPressedShirtsViewController") as!WashPressedShirtsViewController
                
                washPressedVC.serviceModel = model.copy() as? ServiceModel
                NavigationManager.shared.push(viewController: washPressedVC)
            }else if model.alias == "household-items" {
                let houseHoldVC = servicesStoryboard.instantiateViewController(withIdentifier: "HouseHoldItemsViewController") as! HouseHoldItemsViewController
                houseHoldVC.serviceModel = model.copy() as? ServiceModel
                NavigationManager.shared.push(viewController: houseHoldVC)
            }else if model.alias == "dry-cleaning" {
                let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "DryCleaningViewController") as! DryCleaningViewController
                dryCleaningVC.serviceModel = model.copy() as? ServiceModel  //refers to 4th element
                NavigationManager.shared.push(viewController: dryCleaningVC)
            }else if model.alias == "tailoring" {
                let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "TailoringViewController") as!TailoringViewController
                dryCleaningVC.serviceModel = model.copy() as? ServiceModel  //refers to 4th element
                NavigationManager.shared.push(viewController: dryCleaningVC)
            }else if model.alias == "shoe-repair" {
                let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "ShoeRepairViewController") as! ShoeRepairViewController
                dryCleaningVC.serviceModel = model.copy() as? ServiceModel  //refers to 4th element
                NavigationManager.shared.push(viewController: dryCleaningVC)
            }else if model.alias == "carpet-cleaning" {
                let dryCleaningVC = servicesStoryboard.instantiateViewController(withIdentifier: "RugCleaningViewController") as! RugCleaningViewController
                dryCleaningVC.serviceModel = model.copy() as? ServiceModel  //refers to 4th element
                NavigationManager.shared.push(viewController: dryCleaningVC)
            }
        }
    }
    
    func removeItem(withServiceModel model: ServiceModel?) {
        if let model = model {
            removeItemFromCart(withModel: model)
        }
    }
    
    var isFirstLoad: Bool = true
    var cartModel : CartModel?
    
    //IBOutlets
    @IBOutlet weak var orderStatusCollectionView: UICollectionView!
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var addressMethod: UIView!
    
    @IBOutlet weak var netPayableLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderStatusCollectionView.reloadData()
        registerCells()
        orderStatusCollectionView.delegate = self
        orderStatusCollectionView.dataSource = self
        addressMethod.isHidden = true
        fetchCart()
        fetchWalletPoints()
        Events.cartViewed()
    }
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        if !isFirstLoad {
            fetchCart()
        }
        orderStatusCollectionView.reloadData()
        isFirstLoad = false
    }
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func selectAddressTapped(_ sender: Any) {
        
        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
        let selectAddressVC = orderSB.instantiateViewController(withIdentifier: "SelectAddressViewController") as! SelectAddressViewController
        selectAddressVC.cartModel = cartModel
        NavigationManager.shared.push(viewController: selectAddressVC)
    }
    //fetch Cart
    
    func fetchCart() {
        guard let cartId =  UserDefaults.standard.object(forKey: UserDefaultKeys.cartId)else {
            return
        }
        
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.fetchCart, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...//in this get call the user Auth token thee cart is being fetched.
            if let responseDict = response as? [String:Any] { //Alamofire is throwing the response as dictionary .....we are convertig it to model
                print(JSON(responseDict))
                let cartModel = Mapper<CartModel>().map(JSON: responseDict)
                
                self?.cartModel = cartModel //? is put after self as it is weak self.
                
                
                if cartModel?.services?.count != nil {
                    
                    self?.addressMethod.isHidden = false
                    
                    let cartCount = fetchNoOfServicesInCart()
                    if cartCount == 0 {
                        let orderSB = UIStoryboard(name:"OrderStoryboard", bundle: nil)
                        let orderReviewVC = orderSB.instantiateViewController(withIdentifier: "EmptyCartViewController")
                        NavigationManager.shared.pushWithoutAnimation(viewController: orderReviewVC)
                    }
                }
                setupAliasesFromCart(withModel: cartModel)
                if let cartId = cartModel?.cartId {
                    UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                    // from server we are fetching the cart id.
                }
                self?.orderStatusCollectionView.reloadData()
            }
            self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()// definition of error closure
        }
    }
    // remove Item from cart
    func removeItemFromCart(withModel model : ServiceModel) {
        
        guard let itemId = model.id, let cartId = UserDefaults.standard.object(forKey: UserDefaultKeys.cartId) else {return}
        
        let params:[String:Any] = [
            AddToCart.itemId:itemId,
            AddToCart.cart_Id:cartId
        ]
        activityIndicator.startAnimating()
        NetworkingManager.shared.delete(withEndpoint: Endpoints.removeItemFromCart, withParams: params, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] { //Alamofire is throwing the response as dictionary .....we are convertig it to model
                print(JSON(responseDict))
                //remove alias count from cart
                removeServiceFromCartAliasInUserDefault(withAlias: model.alias)
                self?.fetchCart()
                self?.orderStatusCollectionView.reloadData()
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
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "ServiceOrderStatusCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "ServiceOrderStatusCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "DoYouHaveACouponCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "DoYouHaveACouponCollectionViewCell")
        
        let type3PreferencesNib = UINib(nibName: "ApplyWalletPointsCollectionViewCell", bundle: nil)
        orderStatusCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "ApplyWalletPointsCollectionViewCell")
        
        
        let headerNib = UINib(nibName: "ShoppingbagSummaryCollectionReusableView", bundle: nil)
        orderStatusCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ShoppingbagSummaryCollectionReusableView")
        
    }
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 3
    }
    
    func GetRushStatus() -> Bool {
        if let services = cartModel?.services, services.count > 0 {
            for service in services  {
            if service.isRushDeliverySelected == true
            {return true
            }
        }
        return false
       }
     return false
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            if let services = cartModel?.services, services.count > 0 {
                return  services.count
            }
        }
        else if section == 1 {
            if let services = cartModel?.services, services.count > 0 {
                return 1//  for rush status/  delivery-notes
            }
        }
        else {
            if let services = cartModel?.services, services.count > 0 {
                return 2  // this statement ensures that no cell is made when cart is empty
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceOrderStatusCollectionViewCell", for: indexPath) as! ServiceOrderStatusCollectionViewCell
            cell.delegate = self
            if let services = cartModel?.services {
                let service = services[indexPath.item]
                cell.configureCell(withModel: service)
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoYouHaveACouponCollectionViewCell", for: indexPath) as! DoYouHaveACouponCollectionViewCell
        
            if GetRushStatus() {
                cell.doYouHaveACoupon.text = "Rush Delivery is Applicable"
                cell.chooseCoupon.text  = cartModel?.rush_delivery_note?.capitalized
            } else {
                cell.doYouHaveACoupon.text = "Delivery Charges"
                cell.chooseCoupon.text  = cartModel?.delivery_note?.capitalized
                
            }
            cell.chooseCoupon.font = Fonts.semiBold14
            return cell
        }else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoYouHaveACouponCollectionViewCell", for: indexPath) as! DoYouHaveACouponCollectionViewCell
                if let coupon = cartModel?.couponCode {
                    cell.doYouHaveACoupon.text = "Coupons Applied"
                    cell.chooseCoupon.text  = coupon.codeName ?? ""
                }else {
                    cell.doYouHaveACoupon.text = "Do you have a Coupon?"
                    cell.chooseCoupon.text  = "Choose a coupon"
                }
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyWalletPointsCollectionViewCell", for: indexPath) as! ApplyWalletPointsCollectionViewCell
                cell.pointsinWallet = walletBalance
                if walletBalance == 0 {
                    cell.points.text = "No Points"
                }
                else
                {
                    cell.points.text = "Points \(walletBalance)"
                }
                
                cell.configureCell(withCartModel: cartModel)
                
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width, height:144.5)
        }else if indexPath.section == 1 {
        

                return CGSize(width: collectionView.frame.size.width, height:110.5)
            
        }
        else {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.size.width, height:110.5)
            }else {
                return CGSize(width: collectionView.frame.size.width, height:110.5)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if let services = cartModel?.services, services.count > 0 {
                return CGSize(width: collectionView.frame.size.width, height: 70)
            }else  {
               return CGSize(width: collectionView.frame.size.width, height: 0)
            }
        }else {
           return CGSize(width: collectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShoppingbagSummaryCollectionReusableView", for: indexPath) as! ShoppingbagSummaryCollectionReusableView
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.item == 0 {
            let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
            let applyCouponVC = SB.instantiateViewController(withIdentifier: "CouponsViewController")
            NavigationManager.shared.push(viewController: applyCouponVC)
            
        }
    }
}
