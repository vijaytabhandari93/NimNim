//
//  LoginSignUpViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var loginSignUpTableView: UITableView!
    
    enum LoginSignupStates {
        case loginWithPassword
        case loginWithOTP
        case signup
    }
    
    //MARK: Constants and Variables
    var currentScreenState:LoginSignupStates = .signup
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupTableView()
    }
    
    //MARK: Setup UI
    func setupUI() {
    }
    
    func setupTableView() {
        registerCells()
        loginSignUpTableView.delegate = self
        loginSignUpTableView.dataSource = self
    }
    
    func registerCells() {
        
        let signUpCellNib = UINib(nibName: "SignUpTableViewCell", bundle: nil)
        loginSignUpTableView.register(signUpCellNib, forCellReuseIdentifier: "SignUpTableViewCell")
        
        let loginWithPassCellNib = UINib(nibName: "LoginWithPasswordTableViewCell", bundle: nil)
        loginSignUpTableView.register(loginWithPassCellNib, forCellReuseIdentifier: "LoginWithPasswordTableViewCell")
        
        let loginViaOTPCellNib = UINib(nibName: "LoginViaOTPTableViewCell", bundle: nil)
        loginSignUpTableView.register(loginViaOTPCellNib, forCellReuseIdentifier: "LoginViaOTPTableViewCell")
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentScreenState {
        case .loginWithPassword:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginWithPasswordTableViewCell") as! LoginWithPasswordTableViewCell
            return cell
        case .loginWithOTP:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViaOTPTableViewCell") as! LoginViaOTPTableViewCell
            return cell
        case .signup:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentScreenState {
        case .loginWithPassword:
            return 280
        case .loginWithOTP:
            return 343
        case .signup:
            return 484
        }
    }
}
