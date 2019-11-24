//
//  LoginSignUpViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 08/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import GoogleSignIn

class LoginSignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginWithPasswordTableViewCellDelegate, LoginViaOTPTableViewCellDelegate, SignUpTableViewCellDelegate, GIDSignInDelegate {
   
    
    
    //MARK: IBOutlets
    
    
    @IBOutlet weak var loginSignUpTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
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
    var otpState:OTPState = .getOtp {
        didSet {
            refreshTable()
        }
    }
    
    var passwordState:PasswordState = .logIn {
        didSet {
            refreshTable()
        }
    }
    
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
    
    @IBOutlet weak var tickButton: UIButton!
    
    @IBAction func tickButton(_ sender: Any) {
        if tickButton.currentImage != nil{
       tickButton.setImage(nil, for: .normal)
        }
        else{
             let image = UIImage(named: "path2")
            tickButton.setImage(image, for: .normal)
        }
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
        loginButton?.titleLabel?.font = Fonts.regularFont12
        signUpButton?.titleLabel?.font = Fonts.regularFont12
        loginButton?.setTitleColor(Colors.nimnimGrey, for: .normal)
        signUpButton?.setTitleColor(Colors.nimnimGrey, for: .normal)
    }
    
    //MARK: IBActions
    @IBAction func googleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().clientID = "574591501756-6nl6ejk98mdfdqi2h26mhhq22t5o820h.apps.googleusercontent.com" //
        GIDSignIn.sharedInstance().delegate = self //Since we have written this we need to conform to GIDSignInDelegate in this class.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self //To tell google Sdk the presenting controller
        
        // Automatically sign in the user...to show
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
    }
    
    @IBAction func instaTapped(_ sender: Any) {
    }
    
    @IBAction func linkedInTapped(_ sender: Any) {
    }
    
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
            cell.configureView(withState :passwordState)
            return cell
        case .loginWithOTP:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoginViaOTPTableViewCell") as! LoginViaOTPTableViewCell
            cell.delegate = self
            cell.configureView(withOtpState: otpState)
            return cell
        case .signup:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
            cell.delegate = self //Through this statement the viewcontroller is giving its reference to the cell...
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
        removeTapGestures(forTextField: textField) // to enable interaction again with the screen. We want the tap gesture to be implemeented only when the kyboard is there.
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
    
    //MARK: Network Requests
    
    func getOtpTapped(withPhone phoneNumber : String?) {
        guard let phoneNumber = phoneNumber else {
            return
        }
        let params:[String:Any] = [
            LogInViaOTP.mobile:phoneNumber,
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.customersLoginWithOTP, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let msg = responseDict["msg"] as? String {
                    //we can assume here that otp was sent successfully...
                    self.otpState = .verifyOtp
                }
            }
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
           
        }
    }
    
    func resendOtpTapped(withPhone phoneNumber: String?) {
        guard let phoneNumber = phoneNumber else {
            return
        }
        let params:[String:Any] = [
            LogInViaOTP.mobile:phoneNumber,
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.resendOTP, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let msg = responseDict["msg"] as? String {
                    //we can assume here that otp was sent successfully...
                    self.otpState = .verifyOtp
                }
            }
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func verifyOtpTapped(withPhone phoneNumber : String?, withOTP otp: String?) {
        guard let phoneNumber = phoneNumber, let otp = otp else {
            return
        }
        let params:[String:Any] = [
            VerifyOTP.mobile:phoneNumber,
            VerifyOTP.otp:otp
            
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.verifyOTP, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                
            }
            //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            NavigationManager.shared.push(viewController: secondViewController)
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func logInTappedInLoginWithPasswordTableViewCell(withEmail email:String?,withPassword password:String?)
    {
        guard let email = email, let password = password else {
            return
        }
        let params:[String:Any] = [
            LogInViaFormParams.password:password,
            LogInViaFormParams.email:email
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.customersLoginWithPassword, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                
            }
            //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            NavigationManager.shared.push(viewController: secondViewController)
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sendLinkTappedInLoginWithPasswordTableViewCell(withEmail email:String?){
        guard let email = email else {return}
        let params: [String:Any] =
            [ForgotPassword.email:email]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.forgotPasssword, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let success = responseDict["success"] as? Bool, success == true{
                    self.passwordState = .logIn
                }
                
            }
            self.activityIndicatorView.stopAnimating()
            
            
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
       
        
    }
    
    func signUpTappedInSignUpTableViewCell(withEmail email:String?, withFirstName firstName:String?, withLastName lastName:String?, withPhoneNumber phoneNumber:String?, withPassword password:String?, withDob dob:String?) {
        guard let email = email, let firstName = firstName, let lastName = lastName, let phoneNumber = phoneNumber, let password = password, let dob = dob else {
            return
        }
        let params:[String:Any] = [
            SignUpViaFormParams.firstName:firstName,
            SignUpViaFormParams.lastName:lastName,
            SignUpViaFormParams.phone:phoneNumber,
            SignUpViaFormParams.password:password,
            SignUpViaFormParams.dob:dob,
            SignUpViaFormParams.email:email
        ]

        if tickButton.currentImage != nil {
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.customers, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                
            }
            //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            NavigationManager.shared.push(viewController: secondViewController)
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
    }
    //MARK: Google Sign In methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        performSocialSignUp(userInfo: userId, type: "google")
        
    }
    
    func performSocialSignUp(userInfo userId : String? , type : String?)
    {
        guard let userId = userId , let type = type else{
            return
        }
        let params:[String:Any] = [
            SocialSignIn.userId:userId,
            SocialSignIn.typeOfSignIn :type
        ]
        let finalParams = [
            "socialAccount":params
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.socialSignUp, withParams: finalParams, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                
            }
            //We have to push PickupDropOffViewController with screenType as descriptionOfUser...
            let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
            let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
            secondViewController?.screenTypeValue = .pickUpDropOff
            NavigationManager.shared.push(viewController: secondViewController)
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
