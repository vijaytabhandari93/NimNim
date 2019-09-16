//
//  NavDrawerViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 16/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NavDrawerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    //MARK: IBOutlets
    @IBOutlet weak var navDrawerTableView: UITableView!
    
    //MARK: Constants and Variables
    let navDrawerlist = ["Order History","Wallet","Learn How","Subscription","Help","Price","About Us & FAQs","Settings","Logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        

        // Do any additional setup after loading the view.
    }
    
    func setupTableView()
    {
        navDrawerTableView.delegate = self
        navDrawerTableView.dataSource = self
        
    }
    
    //MARK: TableView Datasource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navDrawerlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NavDrawerTableViewCell") as! NavDrawerTableViewCell
        cell.titleNavDrawer.text = navDrawerlist[indexPath.row]
        return cell
    }
}
