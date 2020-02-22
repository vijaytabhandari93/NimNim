//
//  MixPanelManager.swift
//  NimNim
//
//  Created by Raghav Vij on 20/02/20.
//  Copyright © 2020 NimNim. All rights reserved.
//

import Foundation
import Mixpanel

class MixPanelManager {
    static let shared = MixPanelManager()
    
    func initializeMixPanel() {
        Mixpanel.initialize(token: "4a3bb4289a0c82c48da86d469a68649b")
    }
    
    
}

