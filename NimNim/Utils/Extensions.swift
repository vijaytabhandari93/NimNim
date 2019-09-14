//
//  Extensions.swift
//  NimNim
//
//  Created by Raghav Vij on 14/09/19.
//  Copyright © 2019 NimNim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func applyNimNimGradient() {
        let color1 = UIColor(red: 18/255, green: 64/255, blue: 214/255, alpha: 1).cgColor
        let color2 = UIColor(red: 92/255, green: 122/255, blue: 220/255, alpha: 1).cgColor
        let color3 = UIColor(red: 124/255, green: 216/255, blue: 198/255, alpha: 1).cgColor
        let colors = [color1,color2,color3]
        let positions:[NSNumber] = [0.0,0.3,1.0]
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = positions
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0.2, y: 0.1)
        gradient.endPoint = CGPoint(x: 0.8, y: 0.8)
        view.layer.insertSublayer(gradient, at: 0)
    }
}
