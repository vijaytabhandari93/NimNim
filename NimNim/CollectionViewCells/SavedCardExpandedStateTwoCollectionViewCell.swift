//
//  SavedCardExpandedStateTwoCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit

class SavedCardExpandedStateTwoCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var noOfCards : Int = 3
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    @IBOutlet weak var addNewCardButton:UIButton!
    @IBOutlet weak var bottomSeparator:UIView!
    
    @IBAction func addTapped(_ sender: Any) {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let addNewCardVC = profileStoryboard.instantiateViewController(withIdentifier: "AddNewCardViewController")
        NavigationManager.shared.push(viewController: addNewCardVC)
    }
    
    @IBOutlet weak var titleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAddNewCardButton()
        registerCells()
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
    }
    
    func setupAddNewCardButton() {
        addNewCardButton.layer.cornerRadius = 10
        addNewCardButton.layer.borderWidth = 1.5
        addNewCardButton.layer.borderColor = Colors.nimnimButtonBorderGreen.cgColor
    }

    func registerCells() {
        let cardBaseNib = UINib(nibName: "CardsCollectionViewCell", bundle: nil)
        cardsCollectionView.register(cardBaseNib, forCellWithReuseIdentifier: "CardsCollectionViewCell")
        
    }
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsCollectionViewCell", for: indexPath) as! CardsCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 100)
        
    }
    
}
