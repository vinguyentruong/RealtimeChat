//
//  UIView+Extension.swift
//  TodoProject
//
//  Created by David Nguyen Truong on 7/17/18.
//  Copyright © 2018 David Nguyen Truong. All rights reserved.
//

import UIKit
//import SpringIndicator

extension UIView {
    
    public func loadViewFromNib() -> UIView {
        let typeOfSelf = type(of: self)
        let bundle = Bundle(for: typeOfSelf)
        let nib = UINib(nibName: String(describing: typeOfSelf), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func setGradientColors(colors: [UIColor], cornerRadious: CGFloat?) {
        let gradientLayer = CAGradientLayer()
        if let index = layer.sublayers?.index(where: { $0.name == "gradient" }) {
            layer.sublayers?.remove(at: index)
        }
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.name = "gradient"
        gradientLayer.cornerRadius = cornerRadious ?? 0
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    
//    internal func startAnimation(attribute: SpringIndicator.Attributes = SpringIndicator.mediumAndWhite) {
//        stopAnimation()
//        var position = SpringIndicator.Position.right
//        var lineColor = UIColor.white
//        var lineWidth: CGFloat = 2.0
//        var sizeIndicator = CGSize(width: 25, height: 25)
//        
//        if let color = attribute[SpringIndicator.AttributesKey.LineColor] as? UIColor {
//            lineColor = color
//        }
//        if let width = attribute[SpringIndicator.AttributesKey.LineWidth] as? CGFloat {
//            lineWidth = width
//        }
//        if let size = attribute[SpringIndicator.AttributesKey.Size] as? CGSize {
//            sizeIndicator = size
//        }
//        if let pos = attribute[SpringIndicator.AttributesKey.Position] as? SpringIndicator.Position {
//            position = pos
//        }
//        let indicator = SpringIndicator(frame: CGRect(origin: .zero, size: sizeIndicator))
//        indicator.lineWidth = lineWidth
//        indicator.lineColor = lineColor
//        switch position {
//        case .left:
//            self.layout(indicator)
//                .size(sizeIndicator)
//                .centerVertically()
//                .left(8)
//        case .right:
//            self.layout(indicator)
//                .size(sizeIndicator)
//                .centerVertically()
//                .right(8)
//        case .center:
//            self.layout(indicator)
//                .size(sizeIndicator)
//                .centerVertically()
//                .centerHorizontally()
//        }
//        indicator.start()
//    }
//    
//    internal func stopAnimation() {
//        for view in self.subviews {
//            if view is SpringIndicator {
//                (view as? SpringIndicator)?.stop()
//                (view as? SpringIndicator)?.removeFromSuperview()
//            }
//        }
//    }
}
