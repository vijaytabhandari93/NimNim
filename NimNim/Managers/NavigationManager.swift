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
    func initializeApp() {
        let loginSignupStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
        baseNavigationController = loginSignupStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        baseNavigationController?.isNavigationBarHidden = true
        //This will be the conditional part in future...
        if let vc = fetchInitialVC(){
            baseNavigationController?.viewControllers = [vc] // This is to setup the root view controller of baseNavigationController
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = baseNavigationController
            appDelegate.window?.makeKeyAndVisible() // these three lines of code are used to initialize the first screen.
        }
    }
    
    func fetchInitialVC() -> UIViewController? {
        print(UserDefaults.standard.value(forKey: UserDefaultKeys.authToken))
        if let descriptionPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.descriptionPreferences) as? String , let pickUpDropOffPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.pickUpDropOfPreferences) as? String{
            let homeSB = UIStoryboard(name: "Home", bundle: nil)
            let secondViewController = homeSB.instantiateViewController(withIdentifier:"HomeBaseViewController") as? HomeBaseViewController
            return secondViewController
        }
        if let descriptionPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.descriptionPreferences) as? String {
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            return secondViewController
        }
        if let pickUpDropOffPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.pickUpDropOfPreferences) as? String {
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .descriptionOfUser
            
            return secondViewController
        }

        if let userModel = UserModel.fetchFromUserDefaults()
        {
            print(UserDefaults.standard.value(forKey: UserDefaultKeys.authToken))
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            return secondViewController
        }
        if let LocationModel = LocationModel.fetchFromUserDefaults()
        {
            print(UserDefaults.standard.value(forKey: UserDefaultKeys.location))
            let preferencesSB = UIStoryboard(name: "LoginSignup", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"LoginSignUpViewController") as?
                LoginSignUpViewController

            return secondViewController
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultKeys.hasSeenOnboarding) == false{
            let onboardingStory = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVC = onboardingStory.instantiateViewController(withIdentifier:"OnboardingViewController") as? OnboardingViewController
            return onboardingVC
        }else{
            let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"MyLocationViewController") as? MyLocationViewController
            return secondViewController

        }
    }
    
    func push(viewController vc:UIViewController?) {
        if let vc = vc {
            baseNavigationController?.pushViewController(vc, animated: true)
        } // common function in whicvh the view controller is passed
    }
    
    func pushWithoutAnimation(viewController vc:UIViewController?) {
        if let vc = vc {
            baseNavigationController?.pushViewController(vc, animated: false)
        } // common function in whicvh the view controller is passed
    }
}
