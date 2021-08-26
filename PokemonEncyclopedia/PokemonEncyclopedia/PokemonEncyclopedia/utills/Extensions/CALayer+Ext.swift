//
//  CALayer+Ext.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

extension CALayer {
    func rotateAnimation(angal: CGFloat, duration: Double , repeatAnimation:Bool = false) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = angal
        rotationAnimation.duration =  duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.repeatCount = repeatAnimation ? .infinity : 0
        self.add(rotationAnimation, forKey: "rotation")
    }
}
extension UIView {
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]

        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }

        self.layer.insertSublayer(gradient, at: 0)
    }
}
enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}
