//
//  SelectPaymentViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 25/10/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import SwiftyJSON


class SelectPaymentViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    //IBOutlets
    @IBOutlet weak var selectPaymentCollectionView: UICollectionView!
    var cardBaseModel : CardModel?
    var cartModel : CartModel?
    var noOfSavedCards : Int = 1// initially
    var selectedCard = true
     @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedCards()
        registerCells()
        selectPaymentCollectionView.delegate = self
        selectPaymentCollectionView.dataSource = self
    }
    //IBActions
    @IBAction func placeOrder(_ sender: Any) {
        if let cartModel =  cartModel {
        var modelToDictionary = cartModel.toJSON()
            print(JSON(modelToDictionary))
            activityIndicator.startAnimating()
          NetworkingManager.shared.post(withEndpoint: Endpoints.order, withParams: modelToDictionary, withSuccess: { (response) in
              if let responseDict = response as? [String:Any] {
                 print("success")
                let SB = UIStoryboard(name: "OrderStoryboard", bundle: nil)
                       let placeOrderVC = SB.instantiateViewController(withIdentifier: "OrderSuccessFailureViewController")
                       NavigationManager.shared.push(viewController: placeOrderVC)
                       
                 
              }
              self.activityIndicator.stopAnimating()
              
          }) { (error) in
              self.activityIndicator.stopAnimating()
              if let error = error as? String {
                  let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
          }
            }
       
    }
    //MARK:Collection View Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
        
    }
    func fetchSavedCards(){
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.getallcard, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let cardBaseModel = Mapper<CardModel>().map(JSON: responseDict)
                self?.cardBaseModel = cardBaseModel //? is put after self as it is weak self.
                if let count = cardBaseModel?.data?.count {
                    self?.noOfSavedCards = count
                }
                self?.selectPaymentCollectionView.reloadData()
            }
            self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        self.activityIndicator.stopAnimating()
        // definition of error closure
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "SavedCardCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "SavedCardCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "SavedCardExpandedStateTwoCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell")
        let type3PreferencesNib = UINib(nibName: "SavedCardExpandedStateCollectionViewCell", bundle: nil)
        selectPaymentCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "SavedCardExpandedStateCollectionViewCell")
        
    }
    @IBAction func previousTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0
        { let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardCollectionViewCell", for: indexPath) as! SavedCardCollectionViewCell
            cell.savedLabel.text = "Saved Cards"
            if selectedCard == true {
            cell.configureCell(withExpandedState: true)
                if let number = cardBaseModel?.data?.count, number > 0
                {
                    if number == 1 {
                        cell.subTitleLabel.text = "You currrently have \(1) saved card"
                    }else {
                        cell.subTitleLabel.text = "You currrently have \(number) saved cards"
                    }
                }else {
                    cell.subTitleLabel.text = "You currrently have \(0) saved cards"
                }
            }else {
                cell.configureCell(withExpandedState: false)
            }
            return cell
        }
        else  {
            if noOfSavedCards > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateTwoCollectionViewCell", for: indexPath) as! SavedCardExpandedStateTwoCollectionViewCell
                
                cell.noOfCards = noOfSavedCards
                cell.cardModel = cardBaseModel?.data ?? []
                cell.cardsCollectionView.reloadData()
                cell.IsDeleteToBeShown = false
                cell.cartModel = cartModel
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCardExpandedStateCollectionViewCell", for: indexPath) as! SavedCardExpandedStateCollectionViewCell
                cell.missingLabel.text = "No cards"
                return cell
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width:collectionView.frame.size.width , height: 64)
        }
        else
        {
            return CGSize(width: collectionView.frame.size.width, height: 350)
            
        }
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        fetchSavedCards()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
