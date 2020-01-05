//
//  SavedCardExpandedStateTwoCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 19/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit


protocol SavedCardExpandedStateTwoCollectionViewCellDelegate:class {
    func deleteCard(id : String?)
}



class SavedCardExpandedStateTwoCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CardsCollectionViewCellDelegate{
    
    var selectedIndex : IndexPath?
    var cartModel : CartModel?
    
    func selectedTapped(withIndexPath indexPath: IndexPath?) {
        selectedIndex = indexPath
        cardsCollectionView.reloadData()
    }
    
    
   var IsDeleteToBeShown : Bool = true 
    
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    weak var delegate :SavedCardExpandedStateTwoCollectionViewCellDelegate?
    var noOfCards : Int = 0
    var cardModel : [CardDetailsModel] = [] // We have purposly made it non optional and assinged zero to it.
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
        return cardModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsCollectionViewCell", for: indexPath) as! CardsCollectionViewCell
        cell.delegate = self
        if let cardNumber = cardModel[indexPath.row].last4
        {
        cell.cardNumber.text = "**** **** **** \(cardNumber)"
        }
        if let cardId = cardModel[indexPath.row].id
        {
            cell.cardId = cardId
        }
    //  hide // show
        if IsDeleteToBeShown{
            cell.Delete.isHidden = false
            cell.tickButton.isHidden = true
            heightCollectionView.constant = 100
            cell.bottom.constant = 0
        }  else
        {
            cell.Delete.isHidden = true
            cell.tickButton.isHidden = false
            heightCollectionView.constant = 150
            cell.bottom.constant = 50
        }
        if let selectedIndex = selectedIndex {
            if indexPath == selectedIndex {
                cell.configureUI(forRushDeliveryState: true, forIndex: indexPath)
                cartModel?.CardId = cell.cardId
            }
            else
            {
                cell.configureUI(forRushDeliveryState: false, forIndex: indexPath)
            }
        } else  {
            cell.configureUI(forRushDeliveryState: false, forIndex: indexPath)
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if IsDeleteToBeShown{
               return CGSize(width: 154, height: 100)
            
        }  else
        {
                 return CGSize(width: 154, height: 150)
        }
    }
    func deleteCardTapped(withId id : String?){
        delegate?.deleteCard(id:id)
    }
}
