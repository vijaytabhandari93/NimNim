//
//  PickDeliveryTimeSlotsViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class PickDeliveryTimeSlotsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pickDeliverySlot(_ sender: Any) {
        
        let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let selectPaymentVC = SB.instantiateViewController(withIdentifier: "SelectPaymentViewController")
        NavigationManager.shared.push(viewController: selectPaymentVC)
        
    }
    
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    

}
