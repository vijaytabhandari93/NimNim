//
//  PickUpDropOffPreferencesViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 14/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class PickUpDropOffPreferencesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var preferencesTableView: UITableView!
    @IBOutlet weak var titleLable: UILabel!
    var reselection = false
   
    
    //MARK: Constants and Variables
    var titleArray:[String] = []
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipForNow: UIButton!
    var selectedIndexPath: IndexPath?
    
    enum ScreenType {
        case pickUpDropOff
        case descriptionOfUser
    }
    
    var screenTypeValue:ScreenType = .pickUpDropOff
    
    override func viewDidLoad() {
        if reselection{
            skipForNow.isHidden = true
            nextButton.setTitle("Done", for: .normal)
            
        }
        super.viewDidLoad()
        setupScreenModel()
        setuptableview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyNimNimGradient()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        return .lightContent
    }
    
    //MARK: Setup Screen
    
    func setupScreenModel(){
        if screenTypeValue == .pickUpDropOff
        {
            titleArray = [
                "Leave unattened in Foyer",
                "Pick up and drop off at concierge",
                "Pick up and drop off in person"
            ]
            titleLable.text = "Choose your pick up and drop off preference:"
        }
        else{
            titleArray = [
                "Student",
                "Working Professional",
                "Hotel Guest",
                "Business(Salon/Spa/Gym)"
                ]
             titleLable.text = "You are a:"
            
        }
    }
    
    func setuptableview(){
        preferencesTableView.delegate = self
        preferencesTableView.dataSource = self
    }
    
    //MARK: IBActions
    @IBAction func skipTapped(_ sender: Any) {
        if screenTypeValue == .pickUpDropOff {
            if let descriptionPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.descriptionPreferences) as? String {
                let servicesStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let servicesViewController = servicesStoryboard.instantiateViewController(withIdentifier: "HomeBaseViewController")
                NavigationManager.shared.push(viewController: servicesViewController)
            }else {
                let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
                let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
                secondViewController?.screenTypeValue = .descriptionOfUser
                NavigationManager.shared.push(viewController: secondViewController)
            }
        }else {
            let servicesStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let servicesViewController = servicesStoryboard.instantiateViewController(withIdentifier: "HomeBaseViewController")
            NavigationManager.shared.push(viewController: servicesViewController)
        }
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if reselection{
            if screenTypeValue == .pickUpDropOff {
                if let selectedIndexPath = selectedIndexPath {
                    UserDefaults.standard.set(titleArray[selectedIndexPath.row], forKey: UserDefaultKeys.pickUpDropOfPreferences)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if screenTypeValue == .pickUpDropOff {
                                 if let selectedIndexPath = selectedIndexPath {
                                     UserDefaults.standard.set(titleArray[selectedIndexPath.row], forKey: UserDefaultKeys.pickUpDropOfPreferences)
                                     if let descriptionPreferences = UserDefaults.standard.object(forKey: UserDefaultKeys.descriptionPreferences) as? String {
                                         let servicesStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                         let servicesViewController = servicesStoryboard.instantiateViewController(withIdentifier: "HomeBaseViewController")
                                         NavigationManager.shared.push(viewController: servicesViewController)
                                     }else {
                                         let preferencesSB = UIStoryboard(name: "Preferences", bundle: nil)
                                         let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"PickUpDropOffPreferencesViewController") as? PickUpDropOffPreferencesViewController
                                         secondViewController?.screenTypeValue = .descriptionOfUser
                                         NavigationManager.shared.push(viewController: secondViewController)
                                     }
                                 }
                             }else {
                                 if let selectedIndexPath = selectedIndexPath { UserDefaults.standard.set(titleArray[selectedIndexPath.row], forKey: UserDefaultKeys.descriptionPreferences)
                                     
                                     let servicesStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                     let servicesViewController = servicesStoryboard.instantiateViewController(withIdentifier: "HomeBaseViewController")
                                     NavigationManager.shared.push(viewController: servicesViewController)
                                     
                                 }
                                 
                             }
                      
                  
        }
 
    }
    
    //MARK: Tableview delegate and datasource methods
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenTypeValue == .pickUpDropOff { return 3}
        else {return 4}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesTableViewCell", for: indexPath) as! PreferencesTableViewCell
        cell.titleLabel.text = titleArray[indexPath.row]
        if let selectedIndex = selectedIndexPath{
            if selectedIndex == indexPath {
                cell.setupCell(forState: true)
            }else {
                cell.setupCell(forState: false)
            }
        }else {
            cell.setupCell(forState: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
}
