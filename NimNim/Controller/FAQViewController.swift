//
//  PricingViewController.swift
//  NimNim
//
//  Created by Raghav Vij on 13/01/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import UIKit
import ObjectMapper
import NVActivityIndicatorView
import Kingfisher


class FAQViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    //IBOutlets
    @IBOutlet weak var pricingCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        pricingCollectionView.delegate = self
        pricingCollectionView.dataSource = self
    }
    
    var KnowMoreAboutNimNim  : Bool  = false
    var AccountAndProfileManagement  : Bool  = false
    var Payments  : Bool  = false
    var PickupDelivery  : Bool  = false
    var RefundAndCancellation  : Bool  = false
    var expandedSectionIndex:Int = -1
    struct KnowMoreSection {
        static let title = "Learn more about NimNim >"
        static let questions = [
            "What is the NimNim app for?",
            "How can I schedule my first pick up?",
            "What does the “Just NimNim it” feature do?",
            "How will I know my order has been submitted?",
            "Do I need to count my items?"
        ]
        static let answers = [
            "NimNim is a service app for all your laundry, dry cleaning, shoe repair, alterations, and more. Our team of delivery drivers and professional small business service providers help you get what you need, done and with fast turnaround 7 days a week. With NimNim it’s always a WinWin.",
            "Choose the service you want and select your preferences or “Just NimNim It” (see each service for further details). Select your pick up location and times, confirm your order and we’ll take care of the rest! It’s that easy.",
            "This feature lets you place an order without needing to select individual preferences. Our professionals will do that for you according to the amount of laundry, types of fabric, or repair needs of your shoes and clothing.",
            "You will get a text message confirming we have received your order and a second message when your delivery driver is on their way to pick up your items.",
            "You can count your items yourself but there is no need to count your items when you select the “Just NimNim It” option. We’ll count (or weigh) and sort your items for you and update you with the number of items and weight for you to confirm before cleaning."
        ]
    }
    
    struct AccountManagementSection {
        static let title = "Manage my account"
        static let questions = [
            "How can I log into the app?",
            "How can I reset my password?",
            "How can I update my address?",
            "How can I update my credit card details?"
        ]
        static let answers = [
            "You can log in by entering your phone number followed by a one-time SMS code. You can also log in with your email address.",
            "You can reset your password by clicking on “Forgot Password” and entering the one-time SMS code sent to your registered mobile number.",
            "You can update your address by editing your details in your “Profile” section which is located at the bottom right of the home screen.",
            "You can update your credit card details via your “Profile” section."
        ]
    }
    
    struct PricingSection {
        static let title = "Pricing and billing"
        static let questions = [
            "How can I pay for NimNim?",
            "Do I need to submit a minimum order?",
            "Do you pre-authorize my card?",
            "Do you have questions about your bill?"
        ]
        static let answers = [
            "You can input your payment credentials into the app before placing your order. You will be billed after all items are verified at the admin level.",
            "We have a $20 minimum. A $3.99 delivery fee applies to orders less than $35.",
            "Yes, NimNim will pre authorize $20 to your account upon order placement which gets returned after verifying items and billing.",
            "If you have any questions you can simply go to your order in the history section and raise a billing concern against it."
        ]
    }
    
    struct DeliverySection {
        static let title = "Pickup/ Delivery"
        static let questions = [
            "Is it possible to change my delivery location or order information after placing a confirmed order?",
            "Do I need to return the ‘NimNim Bag’?",
            "Can I give special pickup instructions to the driver?",
            "Will I receive a notification when my items are ready for drop off?",
            "Who will pick up my clothes?",
            "How can I track my order?",
            "Does NimNim charge a delivery fee?",
            "Do I need to tip my driver?"
        ]
        static let answers = [
            "Yes, it is. We ask that you please reach out to support@getnimnim.com or call us at 844-767-8646 from 7:00 AM until 7:00 PM Monday through Saturday.",
            "No, these environmentally friendly bags are for you to keep. Use our bag over and over, when you need a new one let us know. Let’s save the planet together.",
            "Yes. When the driver sends an SMS notification stating that he is on the way, you may respond with text instructions or call as well.",
            "Yes! You will receive a text message on your smartphone when NimNim is on the way!! You will receive notification when they are dropped off with you in person or with your concierge or unattended with visual confirmation.",
            "A NimNim Consultant will pick up your clothes. They will have extra bags for you too.",
            "Yes. Check your order in the track orders sections to view status updates of your order as it progresses from stages of pending to paid to completed.",
            "A $3.99 delivery charge will be applied for orders under $35.",
            "This is completely up to you. We are here to help."
        ]
    }
    
    struct RefundSection {
        static let title = "Refunds and cancellations"
        static let questions = [
            "What if I need to reschedule?",
            "What if I need to cancel my order?",
            "What if I’m not satisfied?"
        ]
        static let answers = [
            "Please call our team immediately on 844-767-8464 ASAP or email us at team@getnimnim.com preferably 1 hour prior to your order pick up. We understand that these things do happen, so please let us know as early as possible.",
            "Please call our team immediately on 844-767-8464 ASAP or email us at team@getnimnim.com as soon as you know you need to cancel. We understand these things do happen which is why there are no penalties for cancellations.",
            "If you are not satisfied with the service you received, simply to go your order history and raise a ticket about your order, telling us in detail what happened so we can help you take care of it ASAP."
        ]
    }
    
    enum Sections:Int {
        case KnowMore
        case AccountManagement
        case Pricing
        case Refund
    }
    
    //MARK:Gradient Setting
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        applyHorizontalNimNimGradient()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:UI Methods
    func registerCells() {
        let type3PreferencesNib = UINib(nibName: "PricingHeaderCollectionViewCell", bundle: nil)
             pricingCollectionView.register(type3PreferencesNib, forCellWithReuseIdentifier: "PricingHeaderCollectionViewCell")
         let type2PreferencesNib = UINib(nibName: "DescriptionCollectionViewCell", bundle: nil)
           pricingCollectionView.register(type2PreferencesNib, forCellWithReuseIdentifier: "DescriptionCollectionViewCell")
        let type1PreferencesNib = UINib(nibName: "AnswerDescriptionCollectionViewCell", bundle: nil)
        pricingCollectionView.register(type1PreferencesNib, forCellWithReuseIdentifier: "AnswerDescriptionCollectionViewCell")
        let headerNib = UINib(nibName: "FAQHeaderCollectionReusableView", bundle: nil)
        pricingCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FAQHeaderCollectionReusableView")
        let footerNib = UINib(nibName: "FAQFooterCollectionReusableView", bundle: nil)
        pricingCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FAQFooterCollectionReusableView")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let result = indexPath.item.quotientAndRemainder(dividingBy: 2)
        let remainder = result.remainder
        let quotient = result.quotient
        var text = ""
        if let sectionType = Sections(rawValue: indexPath.section) {
            switch sectionType {
            case .KnowMore:
                if remainder ==  0 {
                    //Question
                    text = KnowMoreSection.questions[quotient]
                }else {
                    //Answer
                    text = KnowMoreSection.answers[quotient]
                }
            case .AccountManagement:
                if remainder ==  0 {
                    //Question
                    text = AccountManagementSection.questions[quotient]
                }else {
                    //Answer
                    text = AccountManagementSection.answers[quotient]
                }
            case .Pricing:
                if remainder ==  0 {
                    //Question
                    text = PricingSection.questions[quotient]
                }else {
                    //Answer
                    text = PricingSection.answers[quotient]
                }
            case .Refund:
                if remainder ==  0 {
                    //Question
                    text = RefundSection.questions[quotient]
                }else {
                    //Answer
                    text = RefundSection.answers[quotient]
                }
            }
        }
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width - 56, height: CGFloat.greatestFiniteMagnitude))
        if remainder == 0 {
            label.font = Fonts.medium16
        }else {
            label.font = Fonts.regularFont14
        }
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        let h: CGFloat = label.frame.size.height
        print(h)
        return CGSize.init(width:collectionView.frame.size.width, height : h+10)
    }
    
    //MARK:Collection View Datasource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionType = Sections(rawValue: section) {
            switch sectionType {
            case .KnowMore:
                if section == expandedSectionIndex{
                    return KnowMoreSection.questions.count * 2
                }else {
                    return 0
                }
            case .AccountManagement:
                if section == expandedSectionIndex{
                    return AccountManagementSection.questions.count * 2
                }else {
                    return 0
                }
            case .Pricing:
                if section == expandedSectionIndex{
                    return PricingSection.questions.count * 2
                }else {
                    return 0
                }
            case .Refund:
                if section == expandedSectionIndex{
                    return RefundSection.questions.count * 2
                }else {
                    return 0
                }
            }
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCollectionViewCell", for: indexPath) as! DescriptionCollectionViewCell
        cell.bulletView.isHidden = false
        let result = indexPath.item.quotientAndRemainder(dividingBy: 2)
        let remainder = result.remainder
        let quotient = result.quotient
        var text = ""
        var font =  Fonts.medium16
        if let sectionType = Sections(rawValue: indexPath.section) {
            switch sectionType {
            case .KnowMore:
                if remainder ==  0 {
                    //Question
                    text = KnowMoreSection.questions[quotient]
                    font = Fonts.medium16
                }else {
                    //Answer
                    text = KnowMoreSection.answers[quotient]
                    font = Fonts.regularFont14
                    cell.bulletView.isHidden = true
                }
            case .AccountManagement:
                if remainder ==  0 {
                    //Question
                    text = AccountManagementSection.questions[quotient]
                    font = Fonts.medium16
                }else {
                    //Answer
                    text = AccountManagementSection.answers[quotient]
                    font = Fonts.regularFont14
                    cell.bulletView.isHidden = true
                }
            case .Pricing:
                if remainder ==  0 {
                    //Question
                    text = PricingSection.questions[quotient]
                    font = Fonts.medium16
                }else {
                    //Answer
                    text = PricingSection.answers[quotient]
                    font = Fonts.regularFont14
                    cell.bulletView.isHidden = true
                }
            case .Refund:
                if remainder ==  0 {
                    //Question
                    text = RefundSection.questions[quotient]
                    font = Fonts.medium16
                }else {
                    //Answer
                    text = RefundSection.answers[quotient]
                    font = Fonts.regularFont14
                    cell.bulletView.isHidden = true
                }
            }
        }
        cell.label.font = font
        cell.label.text = text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == expandedSectionIndex  {
            return CGSize(width: UIScreen.main.bounds.width, height: 56.0)
        }else {
            return CGSize(width: UIScreen.main.bounds.width, height: 46.0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 23.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionType = Sections(rawValue: indexPath.section) {
            switch sectionType {
            case .KnowMore:
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQHeaderCollectionReusableView", for: indexPath) as! FAQHeaderCollectionReusableView
                    headerView.titleLabel.text = KnowMoreSection.title
                    headerView.indexPath = indexPath
                    headerView.delegate = self
                    if indexPath.section ==  expandedSectionIndex {
                        headerView.rightArrow.isHidden = true
                        headerView.bottomArrow.isHidden = false
                    }else {
                        headerView.rightArrow.isHidden = false
                        headerView.bottomArrow.isHidden = true
                    }
                    return headerView
                case UICollectionView.elementKindSectionFooter:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                default:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                }
            case .AccountManagement:
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQHeaderCollectionReusableView", for: indexPath) as! FAQHeaderCollectionReusableView
                    headerView.indexPath = indexPath
                    headerView.titleLabel.text = AccountManagementSection.title
                    headerView.delegate = self
                    if indexPath.section ==  expandedSectionIndex {
                        headerView.rightArrow.isHidden = true
                        headerView.bottomArrow.isHidden = false
                    }else {
                        headerView.rightArrow.isHidden = false
                        headerView.bottomArrow.isHidden = true
                    }
                    return headerView
                case UICollectionView.elementKindSectionFooter:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                default:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                }
            case .Pricing:
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQHeaderCollectionReusableView", for: indexPath) as! FAQHeaderCollectionReusableView
                    headerView.indexPath = indexPath
                    headerView.titleLabel.text = PricingSection.title
                    headerView.delegate = self
                    if indexPath.section ==  expandedSectionIndex {
                        headerView.rightArrow.isHidden = true
                        headerView.bottomArrow.isHidden = false
                    }else {
                        headerView.rightArrow.isHidden = false
                        headerView.bottomArrow.isHidden = true
                    }
                    return headerView
                case UICollectionView.elementKindSectionFooter:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                default:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                }
            case .Refund:
               switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQHeaderCollectionReusableView", for: indexPath) as! FAQHeaderCollectionReusableView
                    headerView.indexPath = indexPath
                    headerView.titleLabel.text = RefundSection.title
                    headerView.delegate = self
                    if indexPath.section ==  expandedSectionIndex {
                        headerView.rightArrow.isHidden = true
                        headerView.bottomArrow.isHidden = false
                    }else {
                        headerView.rightArrow.isHidden = false
                        headerView.bottomArrow.isHidden = true
                    }
                    return headerView
                case UICollectionView.elementKindSectionFooter:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                default:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FAQFooterCollectionReusableView", for: indexPath) as! FAQFooterCollectionReusableView
                    return headerView
                }
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            KnowMoreAboutNimNim = !KnowMoreAboutNimNim
        }
        else if indexPath.section == 1 && indexPath.item == 0 {
            AccountAndProfileManagement = !AccountAndProfileManagement
        }
        else if indexPath.section == 2 && indexPath.item == 0 {
             Payments = !Payments
        }
        else if indexPath.section == 3 && indexPath.item == 0 {
            PickupDelivery = !PickupDelivery
        }else if indexPath.section == 4 && indexPath.item == 0 {
            RefundAndCancellation = !RefundAndCancellation
        }
        pricingCollectionView.reloadData()
        
    }
    
    
    
}

extension FAQViewController:FAQHeaderCollectionReusableViewDelegate {
    func headerTapped(atIndexPath indexPath: IndexPath?) {
        if let indexPath = indexPath {
            if expandedSectionIndex == indexPath.section {
                expandedSectionIndex = -1
            }else {
                expandedSectionIndex = indexPath.section
            }
            pricingCollectionView.reloadData()
        }
    }
}

