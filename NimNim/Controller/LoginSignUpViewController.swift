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
import FBSDKCoreKit
import FBSDKLoginKit

class LoginSignUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginWithPasswordTableViewCellDelegate, LoginViaOTPTableViewCellDelegate, SignUpTableViewCellDelegate, GIDSignInDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var loginSignUpTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var logInSignUpToContinueLabel: UILabel!
    
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
            email = nil
            firstName = nil
            lastName = nil
            socialLoginType = nil
            userId = nil
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
    
    var firstName:String?
    var lastName:String?
    var email:String?
    var socialLoginType:String?
    var userId:String?
    var profileImage:String?
    var isHeightAdded = false // global variable made for keyboard height modification
    var addedHeight:CGFloat = 0 // global variable made for keyboard height modification
    var checked = ""
    {
        didSet
        {
            refreshTable()
        }
    }
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)//when keyboard will come , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) //when keyboard will go , this notification will be called.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil) //when keyboard change from one number pad to another , this notification will be called.
    }
    
    
    @objc func backViewTapped() {
        view.endEditing(true) //to shutdown the keyboard. Wheneever you tap the text field on a specific screeen , then that screen becomes the first responder of the keyoard.
    }
    
    @IBOutlet weak var tickButton: UIButton!
    
    @IBAction func tickButton(_ sender: Any) {
        if tickButton.currentImage != nil{
       tickButton.setImage(nil, for: .normal)
            tickButton.backgroundColor = Colors.nimnimGrey
        }
        else{
             let image = UIImage(named: "path2")
            tickButton.backgroundColor = Colors.nimnimGreen
            tickButton.setImage(image, for: .normal)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isHeightAdded {
                let currentHeight = loginSignUpTableView.contentSize.height
                addedHeight = keyboardSize.height
                loginSignUpTableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight + addedHeight)
                isHeightAdded = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isHeightAdded {
            let currentHeight = loginSignUpTableView.contentSize.height
            loginSignUpTableView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight - addedHeight)
            isHeightAdded = false
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
        logInSignUpToContinueLabel.text = "Log In to Continue"
        loginButton.setTitleColor(Colors.nimnimGreen, for: .normal)
    }
    
    func activateSignUpButton() {
        //select signup button
        signUpButton.titleLabel?.font = Fonts.semiBold16
        logInSignUpToContinueLabel.text = "Sign In to Continue"
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
    
    func fetchDataFromFB() {
        let params = ["fields": "id,name,email,first_name,last_name,picture"]
        GraphRequest.init(graphPath: "me", parameters: params).start {[weak self] (connection, result, error) in
            if (error == nil) {
                if let accessToken = AccessToken.current {
                    if accessToken.hasGranted(permission: "public_profile") {
                        print("public_profile \(accessToken.hasGranted(permission: "public_profile"))")
                    }
                    if accessToken.hasGranted(permission: "email") {
                        print("email \(accessToken.hasGranted(permission: "email"))")
                    }
                    if accessToken.hasGranted(permission: "user_friends") {
                        print("user_friends \(accessToken.hasGranted(permission: "user_friends"))")
                    }
                    self?.handleFBResult(withData: result)
                }
            }
        }
    }
    
    func handleFBResult(withData data:Any?) {
        if let data = data as? [String:Any] {
            if currentScreenState == .loginWithPassword || currentScreenState == .loginWithOTP {
                if let email = data[FBSDK.email] as? String {
                    performSocialLogin(withEmail: email)
                }
            }else {
                if let fbId = data[FBSDK.id] as? String {
                    self.userId = fbId
                }
                if let firstName = data[FBSDK.firstName] as? String {
                    self.firstName = firstName
                }
                if let lastName = data[FBSDK.lastName] as? String {
                    self.lastName = lastName
                }
                if let email = data[FBSDK.email] as? String {
                    self.email = email
                }
                if let picture = data[FBSDK.picture] as? [String:Any] {
                    if let pictureData = picture[FBSDK.pictureData] as? [String:Any] {
                        if let url = pictureData[FBSDK.url] as? String {
                            self.profileImage = url
                        }
                    }
                }
                self.socialLoginType = "fb"
                self.loginSignUpTableView.reloadData()
            }
            
            
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { result in
          self.loginManagerDidComplete(result)
            
        }
    }
    
    @IBAction func instaTapped(_ sender: Any) {
    }
    
    @IBAction func linkedInTapped(_ sender: Any) {
    }
    
    @IBAction func logInTapped(_ sender: Any) {// upper button
        currentScreenState = .loginWithPassword
        refreshTable()
    }
    
    @IBAction func signUpTapped(_ sender: Any) { //upper button
        currentScreenState = .signup
        refreshTable()
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
      switch result {
      case .cancelled:
        print("")
      case .failed(let error):
        print("")
      case .success(let grantedPermissions, _, _):
        print("")
        fetchDataFromFB()
      }
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
            cell.checkedStatus = checked
            cell.configureCell(withEmail: email, withFirstName: firstName, withLastName: lastName)//To ensure that the verify button ui is updated for the value of checked variable...
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
    
    func getOtpTapped(withPhone phoneNumber : String?, withType type:String?) {
        guard let phoneNumber = phoneNumber, let type = type else {
            return
        }
        let params:[String:Any] = [
            LogInViaOTP.mobile:phoneNumber,
            LogInViaOTP.type:type
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
    
    func setupCartIdInUserDefaults(fromResponse response:[String:Any]?) {
        if let response = response {
            if let customerData = response["customer"] as? [String:Any] {
                if let cartId = customerData["cart_id"] as? String {
                    //UserDefaults.standard.set(cartId, forKey: UserDefaultKeys.cartId)
                }
            }
        }
    }
    
    func resendOtpTapped(withPhone phoneNumber: String?) {
        guard let phoneNumber = phoneNumber else {
            return
        }
        let params:[String:Any] = [
            LogInViaOTP.mobile:phoneNumber,
            LogInViaOTP.type:"login"
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
            VerifyOTP.otp:otp,
            VerifyOTP.type:"login"
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.verifyOTP, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                self.setupCartIdInUserDefaults(fromResponse: responseDict)
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
            LogInViaFormParams.password:password, //dic of key value pairs
            LogInViaFormParams.email:email        //dic of key value pairs
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.customersLoginWithPassword, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                self.setupCartIdInUserDefaults(fromResponse: responseDict)
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
    var OTP : String?
    func verifyTappedInSignUpTableViewCell(withPhoneNumber phoneNumber: String?) {
        getOtpTapped(withPhone: phoneNumber, withType: "signup")
        let alert = UIAlertController(title: "Alert", message: "Enter the OTP", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""}
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{[weak alert] (_) in
               let otpTextField = alert?.textFields![0]
                if let textEntered = otpTextField?.text as? String?{
                self.OTP = textEntered
                 self.verify(withType: "signup",withOTP: self.OTP)
      
                }
            }))
        self.present(alert, animated: true, completion: nil)
       
    }
    
    func verify(withType type:String?, withOTP otp:String?)
    {
        guard let otp = otp, let type = type, otp.count>0  else {
            return
        }
        let params:[String:Any] = [
            VerifyOTPSignIn.type:type,
            VerifyOTPSignIn.otp:otp,
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.checkotp, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                self.setupCartIdInUserDefaults(fromResponse: responseDict)
                self.checked = "done"
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
        if let socialLoginType = socialLoginType, socialLoginType.count > 0 {
            performSocialSignUp(userInfo: userId, withType: socialLoginType, withFirstName: firstName, withLastName: lastName, withEmail: email, withPhone: phoneNumber, withPassword: password, withDob: dob)
        }else {
            guard let email = email, let firstName = firstName, let lastName = lastName, let phoneNumber = phoneNumber, let password = password else {
                return
            }
            if checked != "done"
            {
                let alert = UIAlertController(title: "Alert", message: "please verify the phone no first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            var params:[String:Any] = [
                SignUpViaFormParams.firstName:firstName,
                SignUpViaFormParams.lastName:lastName,
                SignUpViaFormParams.phone:phoneNumber,
                SignUpViaFormParams.password:password,
                SignUpViaFormParams.email:email
            ]
            
            if let dob = dob, dob.count > 0 {
                params[SignUpViaFormParams.dob] = dob
            }
            
            if tickButton.currentImage != nil {
                activityIndicatorView.startAnimating()
                NetworkingManager.shared.post(withEndpoint: Endpoints.customers, withParams: params, withSuccess: { (response) in
                    if let responseDict = response as? [String:Any] {
                        let userModel = Mapper<UserModel>().map(JSON: responseDict)
                        userModel?.saveInUserDefaults()
                        //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                        self.setupCartIdInUserDefaults(fromResponse: responseDict)
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
        //Vijayta Read: If user logs in with google then we check what is the current state of the screen.. if it is of a login type... then this means we have to login and not signup...
        if currentScreenState == .loginWithPassword || currentScreenState == .loginWithOTP {
            performSocialLogin(withEmail: user.profile.email)
        }else {
            self.userId = user.userID                  // For client-side use only!
            self.firstName = user.profile.givenName
            self.lastName = user.profile.familyName
            self.email = user.profile.email
            self.socialLoginType = "google"
            self.loginSignUpTableView.reloadData()
        }
        
    }
    
    func performSocialLogin(withEmail email:String?) {
        guard let email = email else {
            return
        }
        let params:[String:Any] = [
            SocialSignIn.email:email
        ]
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.socialLogin, withParams: params, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                self.setupCartIdInUserDefaults(fromResponse: responseDict)
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
    
    func performSocialSignUp(userInfo userId : String? , withType type: String?,withFirstName firstName:String?,withLastName lastName:String?, withEmail email:String?, withPhone phone:String?, withPassword password:String?, withDob dob:String?)
    {
        guard let userId = userId , let type = type, let firstName = firstName, let lastName = lastName, let phone = phone, let password = password, let email = email else{
            return
        }
        if checked != "done"
        {
            let alert = UIAlertController(title: "Alert", message: "please verify the phone no first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let params:[String:Any] = [
            SocialSignIn.userId:userId,
            SocialSignIn.typeOfSignIn :type
        ]
        var finalParams:[String:Any] = [
            "socialAccount":params,
            SocialSignIn.firstName:firstName,
            SocialSignIn.lastName:lastName,
            SocialSignIn.phone:phone,
            SocialSignIn.password:password,
            SocialSignIn.email:email,
        ]
        if let profileImage = profileImage {
            //Possible in Fb Signup...
            finalParams[SocialSignIn.profileImage] = profileImage
        }
        if let dob = dob, dob.count > 0 {
            finalParams[SocialSignIn.dob] = dob
        }
        activityIndicatorView.startAnimating()
        NetworkingManager.shared.post(withEndpoint: Endpoints.socialSignUp, withParams: finalParams, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                let userModel = Mapper<UserModel>().map(JSON: responseDict)
                userModel?.saveInUserDefaults()
                //Read Vijayta - Saving cart id in user defaults so that if the user has a cart then we can straightaway show it's status on the home screen...
                self.setupCartIdInUserDefaults(fromResponse: responseDict)
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
