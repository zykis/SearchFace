//
//  ActivityIndicatorView.swift
//  SearchFace
//
//  Created by Артём Зайцев on 02/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    var animating: Bool = false
    var padding: CGFloat = 2.0
    
    func startAnimating() {
        guard !animating else {
            return
        }
        isHidden = false
        animating = true
        layer.speed = 1
        
        setupAnimation()
        for sl in layer.sublayers! {
            print(sl.frame)
        }
    }
    
    func stopAnimating() {
        guard animating else {
            return
        }
        isHidden = true
        animating = false
        layer.sublayers?.removeAll()
    }
    
    public func isAnimating() -> Bool {
        return animating
    }
    
    private func setupAnimation() {
        let animationRect = frame.inset(by: UIEdgeInsets(top: padding,
                                                         left: padding,
                                                         bottom: padding,
                                                         right: padding))
        
        let minEdge = min(animationRect.width / 3.0, animationRect.height)
        let circleSize = CGSize(width: minEdge, height: minEdge)
        
        layer.sublayers?.removeAll()
        
        let animationCenteredRect = CGRect(x: (animationRect.size.width - circleSize.width * 3.0) / 2.0,
                                           y: (animationRect.size.height - circleSize.height) / 2.0,
                                           width: circleSize.width * 3,
                                           height: circleSize.height)
        print("animationCenteredRect: \(animationCenteredRect)")
        
        for index in 0...2 {
            let circleFrame = CGRect(origin: CGPoint(x: animationCenteredRect.origin.x + CGFloat(index) * circleSize.width,
                                                     y: animationCenteredRect.origin.y),
                                     size: circleSize)
            print("circleFrame: \(circleFrame)")
            setCircleAnimation(inLayer: self.layer, withSize: circleSize, inFrame: circleFrame, withDelay: Double(index) * 0.15)
        }
    }
    
    private func setCircleAnimation(inLayer layer: CALayer, withSize size: CGSize, inFrame frame: CGRect, withDelay delay: Double) {
        let circleLayer = CAShapeLayer()
        let circleSize = size.width
        
        circleLayer.path = CGPath(ellipseIn: CGRect(origin: .zero,
                                                    size: CGSize(width: circleSize, height: circleSize)), transform: .none)
        circleLayer.fillColor = Style.lightBlueColor!.cgColor
        
        let duration: CFTimeInterval = 1
        let timingFunctions: [CAMediaTimingFunction] = [CAMediaTimingFunction(name: .easeInEaseOut),
                                                        CAMediaTimingFunction(name: .easeInEaseOut)]
        let circleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        let minDelay = min(delay, (1.0 - 0.3) / 3.0)
        circleAnimation.values = [0.4, 0.9, 0.4]
        circleAnimation.keyTimes = [0.0, NSNumber(value: 0.3 + minDelay), 1.0]
        circleAnimation.duration = duration
        circleAnimation.timingFunctions = timingFunctions
        circleAnimation.repeatCount = HUGE
        circleAnimation.isRemovedOnCompletion = false
        
        /// making circle layer frame in the bottom right quarter to have
        /// proper animation (scaling from center)
        let circleFrame = CGRect(x: frame.origin.x + (frame.width - circleSize) / 2.0,
                                 y: frame.origin.y + (frame.height - circleSize) / 2.0,
                                 width: circleSize,
                                 height: circleSize)
        circleLayer.frame = circleFrame
        circleLayer.add(circleAnimation, forKey: "animation")
        
        layer.addSublayer(circleLayer)
    }
}
