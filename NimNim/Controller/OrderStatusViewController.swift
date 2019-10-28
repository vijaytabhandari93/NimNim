//
//  OrderStatusViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 24/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class OrderStatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
//IBActions
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
