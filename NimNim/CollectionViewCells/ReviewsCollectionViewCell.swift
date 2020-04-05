//
//  ReviewsCollectionViewCell.swift
//  NimNim
//
//  Created by Raghav Vij on 05/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var activeProgress = 0
    var imageProgressTimer:Timer?
    var startDate:Date?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = self
        progress1.transform = CGAffineTransform(scaleX: 1, y: 2)
        progress2.transform = CGAffineTransform(scaleX: 1, y: 2)
        progress3.transform = CGAffineTransform(scaleX: 1, y: 2)
    }
    
    func registerCells() {
        let reviewCell = UINib(nibName: "ReviewCollectionViewCell", bundle: nil)
        collectionView.register(reviewCell, forCellWithReuseIdentifier: "ReviewCollectionViewCell")
    }
    
    func configureCell() {
        activeProgress = 0
        stopTimer()
        progress1.setProgress(0, animated: false)
        progress2.setProgress(0, animated: false)
        progress3.setProgress(0, animated: false)
        startTimer()
        collectionView.reloadData()
        DispatchQueue.main.async {[weak self] in
            if let activeProgress = self?.activeProgress {
                self?.collectionView.scrollToItem(at: IndexPath(item: activeProgress, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func scroll() {
        DispatchQueue.main.async {[weak self] in
            if let activeProgress = self?.activeProgress {
                self?.collectionView.scrollToItem(at: IndexPath(item: activeProgress, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func startTimer() {
        startDate = Date()
        scroll()
        imageProgressTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        imageProgressTimer?.invalidate()
    }
    
    @objc func runTimedCode() {
        if let startDate = startDate {
            let currentDate = Date()
            let differenceInDates = currentDate.timeIntervalSince(startDate)
            let fraction = Float(differenceInDates/5)
            print("fraction:\(fraction)")
            if fraction <= 1 {
                if activeProgress == 0 {
                    self.progress1.progress = fraction
                }else if activeProgress == 1 {
                    self.progress2.progress = fraction
                }else {
                    self.progress3.progress = fraction
                }
            }else {
                if activeProgress < 2 {
                    if activeProgress == 0 {
                        self.progress1.progress = 1
                    }
                    if activeProgress == 1 {
                        self.progress1.progress = 1
                        self.progress2.progress = 1
                    }
                    activeProgress = activeProgress + 1
                    stopTimer()
                    startTimer()
                }else {
                    self.progress1.progress = 1
                    self.progress2.progress = 1
                    self.progress3.progress = 1
                    stopTimer()
                }
            }
        }
    }
    
    func animate(progressBar progress:UIProgressView) {
        progress.setProgress(1, animated: true)
        UIView.animate(withDuration: 5, animations: {
            progress.layoutIfNeeded()
        }) { (completed) in
            if self.activeProgress == 0 {
                self.activeProgress = 1
                self.scroll()
                self.progress1.setProgress(1, animated: false)
                self.progress3.setProgress(0, animated: false)
                self.animate(progressBar: self.progress2)
            }else if self.activeProgress == 1 {
                self.activeProgress = 2
                self.scroll()
                self.progress1.setProgress(1, animated: false)
                self.progress2.setProgress(1, animated: false)
                self.animate(progressBar: self.progress3)
            }
        }
    }
}

extension ReviewsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
        if indexPath.item == 0 {
            cell.reviewImageView.image = UIImage(named: "BG-4-4")
        }else if indexPath.item == 1 {
            cell.reviewImageView.image = UIImage(named: "BG-4-5")
        }else {
            cell.reviewImageView.image = UIImage(named: "BG-4-6")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
