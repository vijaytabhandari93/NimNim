//
//  NonServiceable.swift
//  NimNim
//
//  Created by Raghav Vij on 25/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class NonServiceable: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyNimNimGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.addTopShadowToView()
        topNavigationView.addBottomShadowToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
