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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeScreen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarShadowView.addSpreadShadowToView()
    }
    
    //MARK: Setup UI
    func initializeScreen() {
        resetAlpha()
        homeContainerView.alpha = 1
    }
    
    func resetAlpha(){
        homeContainerView.alpha = 0
        navDrawerContainerView.alpha = 0
        chatContainerView.alpha = 0
        profileContainerView.alpha = 0

    }
    
    //MARK: IBActions
    @IBAction func homeButtonTapped(_ sender: Any) {
        resetAlpha()
        homeContainerView.alpha = 1
    }
    
    @IBAction func navDrawerTapped(_ sender: Any) {
        resetAlpha()
        navDrawerContainerView.alpha = 1
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        resetAlpha()
        chatContainerView.alpha = 1
        
    }
    @IBAction func profileTapped(_ sender: Any) {
        resetAlpha()
        profileContainerView.alpha = 1
    }

}
