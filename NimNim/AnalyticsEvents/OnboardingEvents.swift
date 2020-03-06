//
//  OnboardingEvents.swift
//  NimNim
//
//  Created by Raghav Vij on 05/03/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation

class OnboardingEvents {
    func fireLoginSuccess(withType loginType:String?) {
        guard let loginType = loginType else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"Onboarding",
            AnalyticsEventProperties.label:loginType
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.loginSuccess, withProperties: props)
    }
    
    func fireLoginFailure(withType loginType:String?) {
        guard let loginType = loginType else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"Onboarding",
            AnalyticsEventProperties.label:loginType
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.loginFailure, withProperties: props)
    }
    
    func fireSignupSuccess(withType signupType:String?) {
        guard let signupType = signupType else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"Onboarding",
            AnalyticsEventProperties.label:signupType
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.signupSuccess, withProperties: props)
    }
    
    func fireSignupFailure(withType signupType:String?) {
        guard let signupType = signupType else {
            return
        }
        let props:[String:String] = [
            AnalyticsEventProperties.category:"Onboarding",
            AnalyticsEventProperties.label:signupType
        ]
        FirebaseManager.shared.fireEvent(withName: AnalyticsEventNames.signupFailure, withProperties: props)
    }
}
