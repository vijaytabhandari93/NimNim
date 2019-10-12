//
//  NavigationManager.swift
//  NimNim
//
//  Created by Raghav Vij on 12/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
    static let shared = NavigationManager() //since this is a static property of the class so it can be directly accessed via the class name...
    private init(){} // this class is a singleton class since the initializer of this class is private, hence no other class can initialize this class from outside..and the only object of this class will be the above declared "shared" object...
    
    var baseNavigationController:UINavigationController?
    func initalizeApp() {
        let loginSignupStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
        baseNavigationController = loginSignupStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        baseNavigationController?.isNavigationBarHidden = true
        
        
        let locationStoryboard = UIStoryboard(name: "MyLocation", bundle: nil)
        let myLocationViewController = locationStoryboard.instantiateViewController(withIdentifier: "MyLocationViewController")
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        let servicesStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let servicesViewController = servicesStoryboard.instantiateViewController(withIdentifier: "HomeBaseViewController")
        
        
        //This will be the conditional part in future...
        baseNavigationController?.viewControllers = [servicesViewController]
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = baseNavigationController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func push(viewController vc:UIViewController?) {
        if let vc = vc {
            baseNavigationController?.pushViewController(vc, animated: true)
        }
    }
}
