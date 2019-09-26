//
//  NonServiceable.swift
//  NimNim
//
//  Created by Raghav Vij on 25/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NonServiceable: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    //MARK: IBActions
    @IBAction func previosScreenTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func NoIAmGoodTapped(_ sender: Any) {
    }
    @IBAction func notifyMeTapped(_ sender: Any) {
    }
}
