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
        
        let reviewCell = UINib(nibName: "ReviewsCollectionViewCell", bundle: nil)
        onboardingCollectionView.register(reviewCell, forCellWithReuseIdentifier: "ReviewsCollectionViewCell")
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
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
            let title = "Choose from a wide range of local services"
            cell.configureCell(withImage: "onboarding1", withTitle: title)
            return cell
        }else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
            let title = "Set your preferences or \"Just NimNim It\""
            cell.configureCell(withImage: "onboarding2", withTitle: title)
            return cell
        }else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
            let title = "Delivering to your door 7 days a week"
            cell.configureCell(withImage: "onboarding3", withTitle: title)
            return cell
        }else if indexPath.item == 3 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as! ReviewsCollectionViewCell
            return cell2
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            (cell as? ReviewsCollectionViewCell)?.configureCell()
        }
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
