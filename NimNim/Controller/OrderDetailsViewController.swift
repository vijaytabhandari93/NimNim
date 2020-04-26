//
//  OrderDetailsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 09/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import NVActivityIndicatorView
import MessageUI

class OrderDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NeedHelpCollectionViewCellDelegate,SubmitTicketViewControllerDelegate {
    
    func submitTicket(withIssueDescription issueDescription: String,withType type: String) {
        print(issueDescription)
        print(type)
    }
    
    
    func helpCellTapped(withType type: String) {
        if type.caseInsensitiveCompare("Cancellation") == .orderedSame {
            cancelOrder()
        }else {
            openMailVC(withIssueTitle: type)
        }
    }
    
    
    @IBOutlet weak var totalPayableAmount: UILabel!
    @IBOutlet weak var totalPayableAmountShadowView: UIView!
    
    var addressBaseModel : AddressModel?
    var noOfSavedAdderess : Int = 0 //initially
    var cardBaseModel : CardModel?
    var noOfSavedCards : Int = 1// initially
    var cardId :String?
    var address : String?
    var nameOfCard :String?
    var expYear : Int?
    var expMonth :Int?
    var number: String?
    var date :String?
    var orderModel:OrderModel?
    var service : [ServiceModel]?
    var count : Int?
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    @IBOutlet weak var orderDetailsCollectionView: UICollectionView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        setupOrderTotal()
        registerCells()
        orderDetailsCollectionView.delegate =  self
        orderDetailsCollectionView.dataSource = self
        orderDetailsCollectionView.reloadData()
        fetchSavedCards()
        fetchSavedAddress()
        if let orderNumber = orderModel?.orderNumber {
            Events.orderDetailsViewed(withOrderNumber: "\(orderNumber)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        totalPayableAmountShadowView.layer.applySketchShadow(color: Colors.nimnimLocationShadowColor, alpha: 0.24, x: 0, y: 0, blur: 13, spread: 0)
    }
    
    func setupOrderTotal() {
        if let price = orderModel?.grandTotal  {
            totalPayableAmount.text = "$\(price)"
        }
    }
    
    func cancelOrder() {
        let alert = UIAlertController(title: "Alert", message: "Are you sure that you wish to cancel this order?", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{[weak self] (_) in
                if let endpoint = Endpoints.cancelOrder(withId: self?.orderModel?.orderNumber) {
                     NetworkingManager.shared.put(withEndpoint: endpoint, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
                         self?.navigationController?.popViewController(animated: true)
                         }) //definition of success closure
                     { (error) in
                         if let error = error as? String {
                             let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                             alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                             self?.present(alert, animated: true, completion: nil)
                         }
                     }
                 }
              }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
          self.present(alert, animated: true, completion: nil)
    }
    
    func fetchSavedCards(){
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallcard, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let cardBaseModel = Mapper<CardModel>().map(JSON: responseDict)
                self?.cardBaseModel = cardBaseModel //? is put after self as it is weak self.
                if let count = cardBaseModel?.data?.count {
                    self?.noOfSavedCards = count
                }
                self?.selectedCard()
                self?.orderDetailsCollectionView.reloadData()
            }
            
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func selectedGetaddress()-> String
    {
        if let array = addressBaseModel?.data {
            for item in array {
                if item.id == self.address  {
                    if let street = item.street , let house = item.house, let city = item.city , let state = item.state  ,  let pincode =  item.pincode {
                        var finalAddress = ""
                        if let landmark = item.landmark {
                            finalAddress = "\(street),  \(house), \(city), \(state), \(pincode), \(landmark)"
                        }else {
                            finalAddress = "\(street),  \(house), \(city), \(state), \(pincode)"
                        }
                        return finalAddress
                    }
                }
            }
        }
        return ""
    }
    func selectedCard()
    {
        if let array = cardBaseModel?.data {
            for item in array {
                if item.id == self.cardId  {
                    
                    if let name = item.name  {
                        self.nameOfCard = name
                    }
                    if let expYear = item.expYear  {
                        self.expYear = expYear
                    }
                    if let expMonth = item.expMonth  {
                        self.expMonth = expMonth
                    }
                    if let number = item.last4 {
                        self.number = number
                    }
                }
            }
        }
    }
    
    func openMailVC(withIssueTitle issueTitle:String?) {
        if MFMailComposeViewController.canSendMail()  {
            if let issueTitle = issueTitle, issueTitle.count > 0 {
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = self
                mailVC.setToRecipients(["support@getnimnim.com"])
                if let orderNumber = orderModel?.orderNumber  {
                    let subject = "Reporting issue:\(issueTitle) for orderNumber:\(orderNumber)"
                    mailVC.setSubject(subject)
                }
                present(mailVC, animated: true, completion: nil)
            }
        }else {
            let alert = UIAlertController(title: "Alert", message: "Probably, you have not configured your email account in Apple Mail application. Try again after doing so.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:UI Methods
    func registerCells() {
        let headerNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        orderDetailsCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionReusableView")
        let type2PreferencesNib = UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "OrderDetailsCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "OrderReviewAddressCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "OrderReviewAddressCollectionViewCell")
        let type4PreferencesNib = UINib(nibName: "OrderReviewCardCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type4PreferencesNib, forCellWithReuseIdentifier: "OrderReviewCardCollectionViewCell")
        let type5PreferencesNib = UINib(nibName: "DoYouHaveACouponCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type5PreferencesNib, forCellWithReuseIdentifier: "DoYouHaveACouponCollectionViewCell")
        
        let type6PreferencesNib = UINib(nibName: "ApplyWalletPointsCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type6PreferencesNib, forCellWithReuseIdentifier: "ApplyWalletPointsCollectionViewCell")
        let type7PreferencesNib = UINib(nibName: "NeedHelpCollectionViewCell", bundle: nil)
        orderDetailsCollectionView.register(type7PreferencesNib, forCellWithReuseIdentifier: "NeedHelpCollectionViewCell")
    }
    //IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section ==  0 {
            //Services
            //            if let service = service , let rushCharges = orderModel?.rushDeliveryCost, rushCharges > 0 {
            //                return service.count + 1
            //            }
            if let orderModel  = orderModel {
                if let service = service{
                    return service.count + 1
                }
            }
            
        }
        else if section == 1 {
            if orderModel?.couponCode?.discount != nil
            {return 1}
            else
            { return 0}
        }else if section == 2 {
            //Wallet
            if let _ = orderModel?.paidViaWallet {
                return 1
            }
        }else if section == 3 {
            //Address
            return 1
        }else if section == 4 {
            //Card
            return 1
        }else if section == 5 {
            //Card
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 130)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath) as! CollectionReusableView
            if let count = service?.count {
                if count == 1
                {
                    headerView.noOfItems.text = "\(count) Service"
                }else {
                    headerView.noOfItems.text = "\(count) Services"
                }
                
            }
            if let serviceItem = service?.first {
                if let pickUpTime = serviceItem.pickUpTime, let pickUpDate = serviceItem.pickupDate {
                    headerView.pickUpDateAndTime.text = "\(pickUpTime) \(pickUpDate)"
                }
            }
            headerView.delegate = self
            headerView.orderCreatedDate.text = date
            return headerView
        default:
            let view = UICollectionReusableView()
            return view
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderReviewCardCollectionViewCell", for: indexPath) as!
            OrderReviewCardCollectionViewCell
            cell.cardHolderName.text = nameOfCard
            if let number = number
            {
                cell.cardNumber.text  = "************\(number)"
            }
            if let month = expMonth ,let year = expYear {
                cell.validTill.text  = " \(month)/\(year)"
            }
            
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderReviewAddressCollectionViewCell", for: indexPath) as!
            OrderReviewAddressCollectionViewCell
            cell.address.text = selectedGetaddress()
            return cell
        } else if indexPath.section == 0 && indexPath.item != service?.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! OrderDetailsCollectionViewCell
            if let serviceItem = service?[indexPath.item] {
                cell.serviceName.text = serviceItem.name
                if let dropOffTime = serviceItem.dropOffTime, let dropOffDate = serviceItem.dropOffDate {
                    cell.dropOffGTimeSlotDate.text =  "\(dropOffTime)  \(dropOffDate)"
                }
                if let serviceCost = serviceItem.totalCost {
                    if serviceCost == 0.0 {
                    cell.amountPayable.text = "@PriceList"
                    } else{
                    cell.amountPayable.text = "$\(serviceCost)"
                    }
              }else {
                    cell.amountPayable.text = nil
                }
                cell.configureCell(withModel: serviceItem)
                cell.serviceStatus.text  = serviceItem.status
            }
            return cell
        }  else if indexPath.section == 0 && indexPath.item == service?.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoYouHaveACouponCollectionViewCell", for: indexPath) as! DoYouHaveACouponCollectionViewCell
            if let orderModel = orderModel {
                let rushStatus = orderModel.confirmRushRequiredOrNot()
                if rushStatus == 1 {
                    cell.doYouHaveACoupon.text = "Rush Delivery is Applicable"
                    if let rushDeliveryNote = orderModel.rush_delivery_note {
                        cell.chooseCoupon.text = rushDeliveryNote.capitalized
                    }
                }else {
                    cell.doYouHaveACoupon.text = "Delivery Charges"
                    if orderModel.delivery_charges_waived == true {
                        cell.chooseCoupon.text = "We have waived off your delivery charges"
                    }else {
                        if let deliveryCost = orderModel.deliverycost {
                            cell.chooseCoupon.text = "$\(deliveryCost)"
                        }
                    }
                }
            }
            
            cell.chooseCoupon.font = Fonts.semiBold14
            
            return cell
        } else if indexPath.section == 1 {
            //Promo
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoYouHaveACouponCollectionViewCell", for: indexPath) as! DoYouHaveACouponCollectionViewCell
            cell.doYouHaveACoupon.text = "Coupons Applied"
            if let coupon = orderModel?.couponCode?.discount {
                cell.chooseCoupon.text  = "$\(coupon) discount is applied on this order."
            }
            return cell
        }else if indexPath.section == 2 {
            //Wallet -- section == 2
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyWalletPointsCollectionViewCell", for: indexPath) as! ApplyWalletPointsCollectionViewCell
            cell.applyWalletPoints.text = "Wallet Points Applied"
            cell.apply.isHidden = true
            if let walletPoints = orderModel?.paidViaWallet {
                cell.points.text = "$\(walletPoints)"
            }else {
                cell.points.text = nil
            }
            return cell
        }else if indexPath.section == 5 {
            //Wallet -- section == 2
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedHelpCollectionViewCell", for: indexPath) as! NeedHelpCollectionViewCell
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyWalletPointsCollectionViewCell", for: indexPath) as! ApplyWalletPointsCollectionViewCell
            return cell
            
        }
    }
    func fetchSavedAddress(){
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallAddrress, withParams: nil, withSuccess: {
            [weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let addressBaseModel = Mapper<AddressModel>().map(JSON: responseDict)
                self?.addressBaseModel = addressBaseModel //? is put after self as it is weak self.
                print(JSON(responseDict))
                if let count = addressBaseModel?.data?.count {
                    self?.noOfSavedAdderess = count
                    self?.orderDetailsCollectionView.reloadData()
                }
            }
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        } // definition of error closure
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 && indexPath.item == service?.count{
            return CGSize(width: collectionView.frame.size.width, height:110.5)
        }else if indexPath.section == 0 && indexPath.item != service?.count {
            //Promo
            return CGSize(width: collectionView.frame.size.width, height:145.5)
        }else if indexPath.section == 1 {
            //Promo
            return CGSize(width: collectionView.frame.size.width, height:110.5)
        }else if indexPath.section == 2 {
            //Wallet
            return CGSize(width: collectionView.frame.size.width, height:110.5)
        }else if indexPath.section == 3 {
            //Address
            let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 56, height: CGFloat.greatestFiniteMagnitude))
            label.text = selectedGetaddress()
            label.numberOfLines = 0
            label.font = Fonts.medium14
            label.sizeToFit()
            let h: CGFloat = label.frame.size.height
            print(h)
            return CGSize.init(width:collectionView.frame.size.width, height : h+84) //84 ---fixed height other than address part...
        }else if indexPath.section == 4 {
            return CGSize(width: collectionView.frame.size.width, height:214)
        }else if indexPath.section == 5 {
            return CGSize(width: collectionView.frame.size.width, height:198)
        }
        else {
            return CGSize(width: collectionView.frame.size.width, height:0)
        }
    }
}

extension OrderDetailsViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent {
            let alert = UIAlertController(title: "Alert", message: "Your issue has been successfully reported. We will get back to you.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "Alert", message: "Sorry your issue could not be reported. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension OrderDetailsViewController: CollectionReusableViewDelegate {
    func trackOrderTapped() {
        let servicesStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let trackOrder = servicesStoryboard.instantiateViewController(withIdentifier: "TrackOrderViewController") as? TrackOrderViewController
        trackOrder?.timelineModel = orderModel?.timelines ?? []
        trackOrder?.date  = date
        trackOrder?.service = service
        NavigationManager.shared.push(viewController: trackOrder)
    }
}
