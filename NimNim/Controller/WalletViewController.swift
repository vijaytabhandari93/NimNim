//
//  WalletViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 10/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher

class WalletViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var walletModel : WalletModel?
    var walletTransactions : Int?
    var walletBalance : Int?
    
    @IBAction func backButtonTapped(_ sender: Any) {navigationController?.popViewController(animated: true)
    }
    
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
    }
    
    func fetchWalletPoints() {
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.fetchwalletbalance, withParams: nil, withSuccess: { (response) in
            if let responseDict = response as? [String:Any] {
                if let walletBalance = responseDict["balance"] as? Int {
                    self.walletBalance = walletBalance
                    self.pricingCollectionView.reloadData()
                    UserDefaults.standard.set(walletBalance, forKey: UserDefaultKeys.walletBalance)
                }
            }
            self.activityIndicator.stopAnimating()
        }) { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        fetchWalletHistory()
        fetchWalletPoints()
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "WalletBalanceCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "WalletBalanceCollectionViewCell")
        
        let type2PreferencesNib = UINib(nibName: "WalletTransactionCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "WalletTransactionCollectionViewCell")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    { if indexPath.item == 0  {
        return CGSize(width: collectionView.frame.size.width, height:70)
    }
    else   {
        return CGSize(width: collectionView.frame.size.width, height:64)
        }
        
    }
    func fetchWalletHistory(){
        activityIndicator.startAnimating()
        NetworkingManager.shared.get(withEndpoint: Endpoints.wallet, withParams: nil, withSuccess: {[weak self] (response) in //We should use weak self in closures in order to avoid retain cycles...
            if let responseDict = response as? [String:Any] {
                let walletModel = Mapper<WalletModel>().map(JSON: responseDict)
                self?.walletModel = walletModel //? is put after self as it is weak self.
                if let count = walletModel?.data?.count {
                    self?.walletTransactions = count
                }
                self?.pricingCollectionView.reloadData()
            }
            self?.activityIndicator.stopAnimating()
            }) //definition of success closure
        { (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        } // definition of error closure
    }
    
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let walletTransactions = walletTransactions{
            return walletTransactions + 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletBalanceCollectionViewCell", for: indexPath) as! WalletBalanceCollectionViewCell
            var currentDate = "\(Date())"
            print(currentDate)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss' '+0000'"
            if let finalDate = dateFormatter.date(from:currentDate) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month,.day], from: finalDate)
                if let DateTobeShown = calendar.date(from:components){
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM, YYYY"
                    currentDate = formatter.string(from: DateTobeShown)
                }
            }
            cell.currentdate.text = "Wallet Balance as on \(currentDate)"
            if let walletBalance = walletBalance {
                cell.walletBalance.text = "$\(walletBalance)"
            }
            return cell
        }
            
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletTransactionCollectionViewCell", for: indexPath) as! WalletTransactionCollectionViewCell
            if let amount  =  walletModel?.data?[indexPath.item - 1].amount {
                cell.amount.text =  "$\(amount)"
            }
            var dateRecieved = walletModel?.data?[indexPath.item - 1].created_at
            if let date = dateRecieved
            {
                print(date)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let finalDate = dateFormatter.date(from:date) {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month,.day], from: finalDate)
                    if let DateTobeShown = calendar.date(from:components){
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM, YYYY"
                        cell.date.text = formatter.string(from: DateTobeShown)
                        
                    }
                    
                    
                }
                
            }
            cell.orderNumber.text = walletModel?.data?[indexPath.item - 1].descriptiona
            cell.transactionType.text = walletModel?.data?[indexPath.item - 1].type
            
            return cell
        }
    }
    
}
