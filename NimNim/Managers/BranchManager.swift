//
//  BranchManager.swift
//  NimNim
//
//  Created by Raghav Vij on 11/04/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import UIKit
import Branch

class BranchManager {
    static let shared = BranchManager()
    
    struct BranchUrlKeys {
        static let referralCode = "$referral_promo"
    }
    func initialize(withLaunchOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) {
        Branch.setUseTestBranchKey(true)
        Branch.getInstance().enableLogging()
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) {[weak self] (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            if let params = params as? [String:Any] {
                print("branch params:\(params)")
                self?.setupReferralPromo(withParams: params)
            }
        }
    }
    
    func createBranchLink(withReferralCode referralCode:String? = nil, withCompletionBlock completionBlock:@escaping ((_ url:String?)->Void)) {
        if let ref = referralCode {
            let buo = BranchUniversalObject.init(canonicalIdentifier: ref)
            buo.publiclyIndex = true
            buo.locallyIndex = true
            let linkProperties = BranchLinkProperties()
            if let referralCode = referralCode {
                linkProperties.addControlParam(BranchUrlKeys.referralCode, withValue: referralCode)
            }
            buo.getShortUrl(with: linkProperties) { (link, error) in
                if let link = link {
                    completionBlock(link)
                }
            }
        }
    }
    
    func setupReferralPromo(withParams params:[String:Any]) {
        if let referralPromo = params["$referral_promo"] as? String {
            UserDefaults.standard.set(referralPromo, forKey: UserDefaultKeys.referralPromo)
            UserDefaults.standard.synchronize()
        }
    }
}
