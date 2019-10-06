//
//  MyLocationViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 23/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class MyLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:IBOutlets
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var currentLocationSelected: UILabel!
    @IBOutlet weak var bottomShadowView: UIView!
    @IBOutlet weak var topShadowView: UIView!
    
    //MARK: Variables
    var selectedIndexPath: IndexPath?
    var tupleArray: [(lable1: String, lable2: String)] = [("Norfolk County","02101"),("Plymouth County","02111"),("Essex County","02115"),("Cedar St.","02119"),("Faneuil St.","02123")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationList()
    }
    
    func setupLocationList()
    {
        locationTableView.delegate = self
        locationTableView.dataSource = self
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topShadowView.addBottomShadowToView()
        bottomShadowView.addAllCornersShadowToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:IBActions
    @IBAction func useThisLocation(_ sender: Any) {
        let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"NonServiceable") as? NonServiceable
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        currentLocationSelected.text = "abcd"
        selectedIndexPath = nil
        locationTableView.reloadData()
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let preferencesSB = UIStoryboard(name: "LoginSignup", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"LoginSignUpViewController") as? LoginSignUpViewController
        self.navigationController?.pushViewController(secondViewController!, animated: true)
        
    }
    
    //MARK: TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tupleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationcCell", for: indexPath) as! LocationcCell
        cell.locationName.text = String(tupleArray[indexPath.row].lable1)
        cell.locationPincode.text = String(tupleArray[indexPath.row].lable2)
        if let selected = selectedIndexPath {
            if selected == indexPath
            {
                cell.setupcell(forState: true)
            }
            else{
                cell.setupcell(forState: false)
            }
        }
        else
        {
            cell.setupcell(forState: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        locationTableView.reloadData()
        currentLocationSelected.text = String(tupleArray[indexPath.row].lable1)
    }
    
}


