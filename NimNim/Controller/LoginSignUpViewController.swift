//
//  LoginSignUpViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginWithPasswordTableViewCellDelegate, LoginViaOTPTableViewCellDelegate, SignUpTableViewCellDelegate {
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var loginSignUpTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    enum LoginSignupStates {
        case loginWithPassword
        case loginWithOTP
        case signup
    }
    
    //MARK: Constants and Variables
    var currentScreenState:LoginSignupStates = .signup {
        didSet {
            resetLoginSignupButtons()
            view.endEditing(true)
            switch currentScreenState {
            case .loginWithPassword:
                activateLoginButton()
            case .loginWithOTP:
                activateLoginButton()
            case .signup:
                activateSignUpButton()
            }
        }
    }
    
    var activeTextField:UITextField?
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        addTapGestureToView()
        setupTableView()
        addObservers()
    }
    
    
    //MARK: Setup UI
    func setupUI() {
        currentScreenState = .signup
    }
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped)) // This line will create an object of tap gesture recognizer
        self.view.addGestureRecognizer(tapGesture) // This line will add that created object of tap gesture recognizer to the view of this login signup view controller screen....
    }
    
    func removeTapGestures(forTextField textField:UITextField) {
        // This function first checks if the textField that is passed is the currently active TextField or Not...if the user will tap somewhere outside then the textField passed will be equal to the activeTextField...but if the user will tap on another textField and this function gets called...then we need not remove the gesture recognizer...
        if let activeTextField = activeTextField, activeTextField == textField {
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupTableView() {
        registerCells()
        loginSignUpTableView.delegate = self
        loginSignUpTableView.dataSource = self
    }
    
    func refreshTable() {
        loginSignUpTableView.reloadData()
    }
    
    func registerCells() {
        
        let signUpCellNib = UINib(nibName: "SignUpTableViewCell", bundle: nil)
        loginSignUpTableView.register(signUpCellNib, forCellReuseIdentifier: "SignUpTableViewCell")
        
        let loginWithPassCellNib = UINib(nibName: "LoginWithPasswordTableViewCell", bundle: nil)
        loginSignUpTableView.register(loginWithPassCellNib, forCellReuseIdentifier: "LoginWithPasswordTableViewCell")
        
        let loginViaOTPCellNib = UINib(nibName: "LoginViaOTPTableViewCell", bundle: nil)
        loginSignUpTableView.register(loginViaOTPCellNib, forCellReuseIdentifier: "LoginViaOTPTableViewCell")
    }
    
    func activateLoginButton() {
        //select login button
        loginButton.titleLabel?.font = Fonts.semiBold16
        loginButton.setTitleColor(Colors.nimnimGreen, for: .normal)
    }
    
    func activateSignUpButton() {
        //select signup button
        signUpButton.titleLabel?.font = Fonts.semiBold16
        signUpButton.setTitleColor(Colors.nimnimGreen, for: .normal)
    }
    
    func resetLoginSignupButtons() {
        //reset both buttons
        loginButton.titleLabel?.font = Fonts.regularFont12
        signUpButton.titleLabel?.font = Fonts.regularFont12
        loginButton.setTitleColor(Colors.nimnimGrey, for: .normal)
        signUpButton.setTitleColor(Colors.nimnimGrey, for: .normal)
    }
    
    //MARK: IBActions
    @IBAction func logInTapped(_ sender: Any) {
        currentScreenState = .loginWithPassword
        refreshTable()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        currentScreenState = .signup
        refreshTable()
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentScreenState {
        case .loginWithPassword:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginWithPasswordTableViewCell") as! LoginWithPasswordTableViewCell
            cell.delegate = self
            return cell
        case .loginWithOTP:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViaOTPTableViewCell") as! LoginViaOTPTableViewCell
            cell.delegate = self
            return cell
        case .signup:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
            cell.delegate = self
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
            return 551
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //view.endEditing(true)
        print("")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    //MARK: TableView Cell Delegates
    func signUpTappedInLoginWithPasswordTableViewCell() {
        currentScreenState = .signup
        refreshTable()
    }
    
    func logInViaOtpTappedInLoginWithPasswordTableViewCell() {
        currentScreenState = .loginWithOTP
        refreshTable()
    }
    
    func textFieldStartedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField) {
        activeTextField = textField
        addTapGestureToView()
    }
    
    func textFieldEndedEditingInLoginViaOTPTableViewCell(withTextField textField:UITextField) {
        removeTapGestures(forTextField: textField)
    }
    
    func logInViaPasswordTappedInLoginViaOTPTableViewCell() {
        currentScreenState = .loginWithPassword
        refreshTable()
    }
    
    func textFieldStartedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField) {
        activeTextField = textField
        addTapGestureToView() //once the textbox editing begins the tap gesture starts functioning
    }
    
    func textFieldEndedEditingInLoginViaPasswordTableViewCell(withTextField textField:UITextField) {
        removeTapGestures(forTextField: textField)
    }
    
    func signUpTappedInLoginViaOTPTableViewCell() {
        currentScreenState = .signup
        refreshTable()
    }
    
    func loginTappedInSignUpTableViewCell() {
        currentScreenState = .loginWithPassword
        refreshTable()
    }
    
    func textFieldStartedEditingInSignUpTableViewCell(withTextField textField:UITextField) {
        activeTextField = textField
        addTapGestureToView()
    }
    
    func textFieldEndedEditingInSignUpTableViewCell(withTextField textField:UITextField) {
        removeTapGestures(forTextField: textField)
    }
    
    func signUpTappedInSignUpTableViewCell() {
        //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
        let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
         let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
           secondViewController?.screenTypeValue = .pickUpDropOff
        NavigationManager.shared.push(viewController: secondViewController)
    }
}
