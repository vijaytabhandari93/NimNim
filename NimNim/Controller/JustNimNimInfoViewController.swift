//
//  JustNimNimInfoViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 29/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class JustNimNimInfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var titleValue:String?
    var descriptionValue:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = titleValue
        descriptionLabel.text  = descriptionValue
    }

    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
