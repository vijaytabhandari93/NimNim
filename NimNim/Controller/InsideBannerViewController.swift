//
//  InsideBannerViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 27/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import Kingfisher

class InsideBannerViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    @IBOutlet weak var titleLabelOfBannerInside: UILabel!
    
    enum BannerType : String {
        case newCustomerOnboarding = "http://getnimnim.us/banner?type=newcustomeronboarding"
        case newServicesTailoringRugCleaning = "http://getnimnim.us/banner?type=newservicestailoringrugcleaning"
        case DogoodFeelGood = "http://getnimnim.us/banner?type=dogoodfeelgood"
    }
    
    struct BannerData {
        static let newCustomerOnboardingIcons = ["10Off","justNimNimIt","questionIcon","driver"]
        static let newCustomerOnboardingTitles = ["Thank you for joining NimNim","Just press NimNim it","Do you have a Question?","Our driver will bring the bags"]
        static let newCustomerOnboardingDescription = ["Use first time code NewNim upon check out to get $10 OFF of your order.","You can individually choose services preference by preference or just press NimNim it and allow us to sort out everything for you.","If you have a question about order then please go to help section and get service against your order","NimNim driver will bring you a bag upon arrival or you can collect one from your concierge. NimNim delivers in 24  hours on your door."]
        
        static let newServicesTailoringRugCleaningIcons = ["tailoring","rugsIcon","5Off","certified"]
        static let newServicesTailoringRugCleaningTitles = ["Tailoring","For Rugs","Our Offers","Certified Vendors"]
        static let newServicesTailoringRugCleaningDescription = ["You can just select your item and choose a job type with your instructions and NimNim team will take care of now.","We can pick them up and bring them back to you, at the comfort of your couch.","We are offering exclusive $5 off your first trial when selected these services, use code RUG5, TAILOR5","Our vendors are 100% certified who do these craftsmanship for a living, so only expect quality and the most streamlined experience."]
        
        static let DogoodFeelGoodIcons = ["ourMission","pickUpDoneEasily","recycleIcon"]
        static let DogoodFeelGoodTitles = ["Our Mission","Pick up Done easily","Our Recycle Program"]
        static let DogoodFeelGoodDescription = ["We are on a mission not only to save you time but empower the homeless and working professionals and thus partnered up with Year Up and local homeless shelter to support the ones in need.","By going on to this page you can request a pick up for clothing donation for the shelter or working professionals.","Make use of our recycle program, You can send back your NimNim hangers and we will recycle them for you. Simply add them back to the bag they came in and NimNim will take care of rest. "]
    }
    
    var deepLink:String = ""
    
    //MARK:Gradient Setting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let banner : BannerType = BannerType(rawValue: deepLink) {
            switch banner {
                
            case .newCustomerOnboarding:
                titleLabelOfBannerInside.text = "New Customer\nOnboarding"
            case .newServicesTailoringRugCleaning:
                titleLabelOfBannerInside.text = "New Services\nTailoring & Rug Cleaning"
            case .DogoodFeelGood:
                titleLabelOfBannerInside.text = "Do good,\nFeel Good"
            }
        }
        registerCells()
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
        pricingCollectionView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type1PreferencesNib = UINib(nibName: "BannerInsideCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "BannerInsideCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if let banner : BannerType = BannerType(rawValue: deepLink) {
            switch banner {
            case .newCustomerOnboarding:
                let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label.text = BannerData.newCustomerOnboardingTitles[indexPath.row]
                label.numberOfLines = 0
                label.font = Fonts.semiBold18
                label.sizeToFit()
                let h1 =  label.frame.size.height
                let label2 =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label2.text = BannerData.newCustomerOnboardingDescription[indexPath.row]
                label2.numberOfLines = 0
                label2.font = Fonts.regularFont14
                label2.sizeToFit()
                let h2: CGFloat = label2.frame.size.height
                let h = h1 + h2
                return CGSize.init(width:collectionView.frame.size.width, height : h+290)
            case .newServicesTailoringRugCleaning:
                let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label.text = BannerData.newServicesTailoringRugCleaningTitles[indexPath.row]
                label.numberOfLines = 0
                label.font = Fonts.semiBold18
                label.sizeToFit()
                let h1 =  label.frame.size.height
                let label2 =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label2.text = BannerData.newServicesTailoringRugCleaningDescription[indexPath.row]
                label2.numberOfLines = 0
                label2.font = Fonts.regularFont14
                label2.sizeToFit()
                let h2: CGFloat = label2.frame.size.height
                let h = h1 + h2
                return CGSize.init(width:collectionView.frame.size.width, height : h+290)
            case .DogoodFeelGood:
                let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label.text = BannerData.DogoodFeelGoodTitles[indexPath.row]
                label.numberOfLines = 0
                label.font = Fonts.semiBold18
                label.sizeToFit()
                let h1 =  label.frame.size.height
                let label2 =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude))
                label2.text = BannerData.DogoodFeelGoodDescription[indexPath.row]
                label2.numberOfLines = 0
                label2.font = Fonts.regularFont14
                label2.sizeToFit()
                let h2: CGFloat = label2.frame.size.height
                let h = h1 + h2
                return CGSize.init(width:collectionView.frame.size.width, height : h+290)
            }
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let banner : BannerType = BannerType(rawValue: deepLink) {
            switch banner {
            case .newCustomerOnboarding:
                return BannerData.newCustomerOnboardingIcons.count
            case .newServicesTailoringRugCleaning:
                return BannerData.newServicesTailoringRugCleaningIcons.count
            case .DogoodFeelGood:
                return BannerData.DogoodFeelGoodIcons.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerInsideCollectionViewCell", for: indexPath) as! BannerInsideCollectionViewCell
        //  on the basis of the deeplink generate the enum type
        if let banner : BannerType = BannerType(rawValue: deepLink) {
            switch banner {
            case .newCustomerOnboarding:
                cell.imageView.image = UIImage(named: BannerData.newCustomerOnboardingIcons[indexPath.row])
                cell.label1.text = BannerData.newCustomerOnboardingTitles[indexPath.row]
                cell.label2.text = BannerData.newCustomerOnboardingDescription[indexPath.row]
                
            case .newServicesTailoringRugCleaning:
                cell.imageView.image = UIImage(named: BannerData.newServicesTailoringRugCleaningIcons[indexPath.row])
                cell.label1.text = BannerData.newServicesTailoringRugCleaningTitles[indexPath.row]
                cell.label2.text = BannerData.newServicesTailoringRugCleaningDescription[indexPath.row]
                
            case .DogoodFeelGood:
                cell.imageView.image = UIImage(named: BannerData.DogoodFeelGoodIcons[indexPath.row])
                cell.label1.text = BannerData.DogoodFeelGoodTitles[indexPath.row]
                cell.label2.text = BannerData.DogoodFeelGoodDescription[indexPath.row]
            }
        }
        
        return cell
    }
    
    
    
    
    
    
    
}
