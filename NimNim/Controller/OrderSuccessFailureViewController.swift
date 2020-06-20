//
//  OrderSuccessFailureViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class OrderSuccessFailureViewController: UIViewController {
    
   var actualOrderStatus = "fail"
   @IBOutlet weak var backView : UIView!
   @IBOutlet weak var orderStatusImage : UIImageView!
    @IBOutlet weak var orderStatus : UILabel!
    @IBOutlet weak var orderStatusDescription : UILabel!
    @IBOutlet weak var label : UILabel!
    @IBOutlet weak var trackOrderButton : UIButton!
    @IBOutlet weak var homeButton : UIButton!
    
    @IBAction func homeTapped(_ sender: Any) {
        
        let homeVC =  self.navigationController?.viewControllers.first(where: { (viewController) -> Bool in
            if viewController is HomeBaseViewController  {
                return true
            }else {
                return false
            }
        })
        if let homeVC = homeVC {
            self.navigationController?.popToViewController(homeVC, animated: false)
        }
    }
    
    @IBAction func trackOrderTapped(_ sender: Any) {
        if trackOrderButton.titleLabel?.text == "Track Orders"
        {
            let orderStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
            let orderStatusVC = orderStoryboard.instantiateViewController(withIdentifier: "OrderStatusViewController")
            NavigationManager.shared.push(viewController: orderStatusVC)
        }
        else {
            let orderStoryboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
            let orderStatusVC = orderStoryboard.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController")
            NavigationManager.shared.push(viewController: orderStatusVC)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackOrderButton.layer.borderWidth = 1
        trackOrderButton.layer.borderColor = UIColor.white.cgColor
        
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = UIColor.white.cgColor
        
        if actualOrderStatus == "success" {
            orderStatusImage.image = UIImage(named: "happy")
            orderStatus.text = "Success"
            orderStatusDescription.text = "Your order has been placed successfully. Our driver will come to your preferred address to pick up your order. Please make sure it’s ready."
            label.text = "Use the buttons below to Track Your Order or go to Home."
            backView.backgroundColor = Colors.nimnimGreen
            
            trackOrderButton.setTitle("Track Orders", for: .normal)
        } else {
            
                      orderStatusImage.image = UIImage(named: "sad")
            orderStatus.text = "Failure"
            orderStatusDescription.text = "We regret to inform you that your order couldn’t be placed."
            label.text = "Please click on the button Try Again to place the order again or “Home” icon to go back home."
            backView.backgroundColor = Colors.nimnimBlue
            trackOrderButton.setTitle("Try Again", for: .normal)
            
        }
        refreshHome()

        // Do any additional setup after loading the view.
    }
    
    func refreshHome() {
        NotificationCenter.default.post(name: AppNotifications.refreshHome, object: nil)
    }
    

}
