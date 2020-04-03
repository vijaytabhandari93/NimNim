//
//  OnboardingViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 26/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
    }
    
    func registerCells() {
        let onboardingCell = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
        onboardingCollectionView.register(onboardingCell, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
    }
    
    @IBAction func setDeliveryLocationTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.hasSeenOnboarding)
        let preferencesSB = UIStoryboard(name: "MyLocation", bundle: nil)
        let secondViewController = preferencesSB.instantiateViewController(withIdentifier:"MyLocationViewController") as? MyLocationViewController
        NavigationManager.shared.push(viewController: secondViewController)
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        if indexPath.row == 0 {
            let title = "Order from a wide range of Services"
            cell.configureCell(withImage: "onboarding1", withTitle: title)
        }else if indexPath.row == 1 {
            let title = "Setup from a range of Preferences or \"just NimNim it\""
            cell.configureCell(withImage: "onboarding2", withTitle: title)
        }else if indexPath.row == 2 {
            let title = "24 Hours Delivery. Delivered quickly to your doorstep"
            cell.configureCell(withImage: "onboarding3", withTitle: title)
        }else if indexPath.row == 3 {
            let title = "Why customers use NimNim Services"
            cell.configureCell(withImage: "BG-4-5", withTitle: title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: onboardingCollectionView.contentOffset, size: onboardingCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = onboardingCollectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.item
        }
    }
}
