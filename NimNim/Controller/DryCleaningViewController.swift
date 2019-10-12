//
//  DryCleaningViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 11/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class DryCleaningViewController: UIViewController {
    
    @IBOutlet weak var priceTotalBackgroundView: UIView!
    @IBOutlet weak var dryCleaningCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var washAndFoldLabel: UILabel!
    @IBOutlet weak var basketLabel: UILabel!
    
    
    @IBAction func basketTapped(_ sender: Any) {
    }
    @IBAction func previousTapped(_ sender: Any) {
    }
    @IBAction func justNimNimIt(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        priceTotalBackgroundView.addTopShadowToView()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
