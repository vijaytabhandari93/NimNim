//
//  AddNewCardViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 20/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class AddNewCardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: IBOutlets
    @IBOutlet weak var cardCollectionView:UICollectionView!
    @IBOutlet weak var credit: UIButton!
    @IBOutlet weak var debit: UIButton!
    
    enum cardtype : Int {
        case credit
        case debit
    }
    
    var selectedCardState : cardtype! {
        didSet{
            if selectedCardState == .credit
            {
                resetButtons()
                credit.isSelected = true
                credit.titleLabel?.font = Fonts.semiBold16
                credit.setTitleColor(UIColor.white, for: .normal)
                cardCollectionView.reloadData()
                
            }
            else {
                resetButtons()
                debit.isSelected = true
                debit.titleLabel?.font = Fonts.semiBold16
                debit.setTitleColor(UIColor.white, for: .normal)
                cardCollectionView.reloadData()
                
            }
        }
        
    }
    func resetButtons() {
        credit.isSelected = false
        debit.isSelected = false
        credit.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        debit.titleLabel?.font = Fonts.regularFont12
        credit.setTitleColor(Colors.nimnimGenderWhite, for: .normal)
        debit.titleLabel?.font = Fonts.regularFont12
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyHorizontalNimNimGradient()
    }
    
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "AddCardCollectionViewCell", bundle: nil)
        cardCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AddCardCollectionViewCell")
    }
    
    @IBAction func addCardTapped(_ sender:Any?) {
        navigationController?.popViewController(animated: true)

        
    }
    @IBAction func creditTapped(_ sender:Any?) {
        selectedCardState = .credit
    }
    @IBAction func debitTapped(_ sender:Any?) {
        selectedCardState = .debit
    }
    
    @IBAction func previousTapped(_ sender:Any?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCardCollectionViewCell", for: indexPath) as! AddCardCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 506)
    }

}
