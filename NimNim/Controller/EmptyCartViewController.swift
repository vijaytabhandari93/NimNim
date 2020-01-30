//
//  EmptyCartViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 27/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class EmptyCartViewController: UIViewController {
    
    @IBOutlet weak var homebutton: UIButton!
    
    @IBOutlet weak var descriptionContainingUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homebutton.layer.borderWidth  = 1.5
        homebutton.layer.borderColor  = Colors.nimnimGreen.cgColor
        
        if let userModel = UserModel.fetchFromUserDefaults() {
            if let a = userModel.firstName {
                descriptionContainingUserName.text  = "Hello \(a.capitalized), your Cart is currently empty.  Please add services from the Service page to place an order. "
            }
               
        }
        }
        
        @IBAction func homeButtonTapped(_ sender: Any) {
            
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
        
        
        @IBAction func addServicesTapped(_ sender: Any) {
            
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
            
            let preferencesSB = UIStoryboard(name: "Services", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"AllServicesViewController") as? AllServicesViewController
            NavigationManager.shared.push(viewController: secondViewController)
        }
        
        
        
}


