//
//  HomeBaseViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 12/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class HomeBaseViewController: UIViewController {
    
    //MARK:IBOutlets
    @IBOutlet weak var homeContainerView: UIView!
    @IBOutlet weak var navDrawerContainerView: UIView!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var tabBarShadowView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nimNimButton: UIButton!
    @IBOutlet weak var homeButtonBackView: UIView!
    @IBOutlet weak var navButtonBackView: UIView!
    @IBOutlet weak var chatButtonBackView: UIView!
    @IBOutlet weak var profileButtonBackView: UIView!
    @IBOutlet weak var OKGotIt: UIButton!
    @IBOutlet weak var smallerView: UIView!
    @IBOutlet weak var smallView: UIView!
    
    var haveVisiteed  = false
    
    @IBAction func Ok(_ sender: Any) {
        smallView.isHidden = true
        smallerView.isHidden = true
        haveVisiteed  = true
        UserDefaults.standard.set(haveVisiteed, forKey: "haveVisiteed")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeScreen()
        OKGotIt.layer.borderWidth = 1
        OKGotIt.layer.borderColor = Colors.nimnimGreen.cgColor
        if let haveVisiteed = UserDefaults.standard.value(forKey: "haveVisiteed") as? Bool, haveVisiteed == true  {
            smallView.isHidden = true
            smallerView.isHidden = true
        }
        else {
            smallView.isHidden = false
            smallerView.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarShadowView.addSpreadShadowToView()
    }
    
    //MARK: Setup UI
    func initializeScreen() {
        resetAlpha()
        resetButtons()
        homeButton.tintColor = Colors.nimnimHomeTabsGreen
        homeButtonBackView.alpha = 1
        homeContainerView.alpha = 1
    }
    
    func resetAlpha(){
        homeContainerView.alpha = 0
        navDrawerContainerView.alpha = 0
        chatContainerView.alpha = 0
        profileContainerView.alpha = 0
    }
    
    func resetButtons() {
        homeButton.tintColor = Colors.nimnimHomeTabsGrey
        homeButtonBackView.alpha = 0
        navButton.tintColor = Colors.nimnimHomeTabsGrey
        navButtonBackView.alpha = 0
        chatButton.tintColor = Colors.nimnimHomeTabsGrey
        chatButtonBackView.alpha = 0
        profileButton.tintColor = Colors.nimnimHomeTabsGrey
        profileButtonBackView.alpha = 0
       

    }
    
    //MARK: IBActions
    @IBAction func homeButtonTapped(_ sender: Any) {
        resetAlpha()
        resetButtons()
        homeButton.tintColor = Colors.nimnimHomeTabsGreen
        homeButtonBackView.alpha = 1
        homeContainerView.alpha = 1
    }
    
    @IBAction func navDrawerTapped(_ sender: Any) {
        resetAlpha()
        resetButtons()
        navButton.tintColor = Colors.nimnimHomeTabsGreen
        navButtonBackView.alpha = 1
        navDrawerContainerView.alpha = 1
    }
    
    @IBAction func nimNimButtonTapped(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let NimNimIt = homeStoryboard.instantiateViewController(withIdentifier: "NimNimViewController") as? NimNimViewController
            NavigationManager.shared.push(viewController: NimNimIt)
        
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        resetAlpha()
        resetButtons()
        chatButton.tintColor = Colors.nimnimHomeTabsGreen
        chatButtonBackView.alpha = 1
        chatContainerView.alpha = 1
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        resetAlpha()
        resetButtons()
        profileButton.tintColor = Colors.nimnimHomeTabsGreen
        profileButtonBackView.alpha = 1
        profileContainerView.alpha = 1
    }
}
