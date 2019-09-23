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
    
    //MARK: Constants and Variables
    var titleArray:[String] = []
    
    var selectedIndexPath: IndexPath?
    
    enum ScreenType {
        case pickUpDropOff
        case descriptionOfUser
    }
    
    var screenTypeValue:ScreenType = .pickUpDropOff
    
    override func viewDidLoad() {
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
    
    //MARK: Setup Screen
    
    func setupScreenModel(){
        if screenTypeValue == .pickUpDropOff
        {
            titleArray = [
                "Leave unattened in Foyer",
                "Pick up and drop off at concierge",
                "Pick up and Drop off in person"
            ]
            titleLable.text = "Please specify your pick up & drop off preferences"
        }
        else{
            titleArray = [
                "Students",
                "Working Professional",
                "On a short visit",
                "Hotel Guests",
                "Business(Spa/Salon/Gym)"
                ]
             titleLable.text = "Tell us which describes you the best?"
            
        }
    }
    
    func setuptableview(){
        preferencesTableView.delegate = self
        preferencesTableView.dataSource = self
    }
    
    //MARK: IBActions
    @IBAction func skipTapped(_ sender: Any) {
    }
    
    @IBAction func nextTapped(_ sender: Any) {
    }
    
    //MARK: Tableview delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
