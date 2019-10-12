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
        let color1 = UIColor(red: 4/255, green: 113/255, blue: 166/255, alpha: 1).cgColor
        let color3 = UIColor(red: 124/255, green: 216/255, blue: 198/255, alpha: 1).cgColor
        let colors = [color1,color3]
        let positions:[NSNumber] = [0.0,1.0]
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = positions
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyHorizontalNimNimGradient() {
        let color1 = UIColor(red: 4/255, green: 113/255, blue: 166/255, alpha: 1).cgColor
        let color3 = UIColor(red: 124/255, green: 216/255, blue: 198/255, alpha: 1).cgColor
        let colors = [color1,color3]
        let positions:[NSNumber] = [0.0,1.0]
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = positions
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    func addBottomShadowToView() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height + 19))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height + 19))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.close()
        self.layer.shadowColor = UIColor(red: 58/255, green: 76/255, blue: 130/255, alpha: 0.24).cgColor
        self.layer.shadowOpacity = 0.38
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 5
    }

    func addTopShadowToView() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.origin.x, y: -2))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: -2))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.close()
        self.layer.shadowColor = UIColor(red: 58/255, green: 76/255, blue: 130/255, alpha: 0.24).cgColor
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 5
    }
    
    func addSpreadShadowToView() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.origin.x, y: -22))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: -22))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.close()
        self.layer.shadowColor = UIColor(red: 58/255, green: 76/255, blue: 130/255, alpha: 0.13).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 5
    }
    
    func addAllCornersShadowToView() {
        self.layer.shadowColor = UIColor(red: 58/255, green: 76/255, blue: 130/255, alpha: 0.24).cgColor
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.bounds.size.width + shadowSize,
                                                   height: self.bounds.size.height + shadowSize))
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowPath = shadowPath.cgPath
    }
}
