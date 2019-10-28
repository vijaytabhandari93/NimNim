//
//  PickDateAndTimeViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class PickDateAndTimeViewController: UIViewController {

    
    @IBAction func pickDeliverySlot(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let DropVC = SB.instantiateViewController(withIdentifier: "PickDeliveryTimeSlotsViewController")
        NavigationManager.shared.push(viewController: DropVC)
        
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
       
    }
    


}
