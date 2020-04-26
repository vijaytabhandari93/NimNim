//
//  ReferralViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 24/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ReferralViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var referralDescription:String?
    var referralPromo:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        fetchReferralCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    func fetchReferralCode() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        NetworkingManager.shared.get(withEndpoint: Endpoints.referralCode, withParams: nil, withSuccess: {[weak self] (response) in
            if let response = response as? [String:Any] {
                if let description = response["description"] as? String {
                    self?.referralDescription = description
                }
                if let promo = response["promo"] as? String {
                    self?.referralPromo = promo
                }
                self?.activityIndicator.stopAnimating()
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }
        }) {[weak self] (error) in
            if let error = error as? String {
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                self?.collectionView.isHidden = false
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ReferralViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReferralCollectionViewCell", for: indexPath)  as! ReferralCollectionViewCell
        cell.delegate = self
        cell.codeLabel.text = referralPromo ?? ""
        cell.subTitleLabel.text = referralDescription ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ReferralViewController: ReferralCollectionViewCellDelegate {
    func copyTapped(withCode code: String?) {
        if let code = code {
            let pasteboard = UIPasteboard.general
            pasteboard.string = code
            view.showToast(message: "Copied")
        }
    }
    
    func inviteTapped(withCode code: String?) {
        BranchManager.shared.createBranchLink(withReferralCode: code) {[weak self] (urlString) in
            if let urlString = urlString, let url = URL(string: urlString) {
                if let text = self?.referralDescription {
                    let vc = UIActivityViewController(activityItems: [text,url], applicationActivities: [])
                    self?.present(vc, animated: true)
                }
            }
        }
    }
}
