//
//  UIview+Ext.swift
//  TNC360
//
//  Created by Shiwani Thakur on 11/03/21.
//

import Foundation
import UIKit


extension UIView {
  
  func roundCornersView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
      }
  
  func applyBlurEffect() {
    if !UIAccessibility.isReduceTransparencyEnabled {
      let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
      blurredView.frame = self.bounds
      backgroundColor = .clear
      blurredView.backgroundColor = .clear
      isUserInteractionEnabled = true
      blurredView.clipsToBounds = true
      addSubview(blurredView)
    }
  }
  
  func image() -> UIImage {
      UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
      guard let context = UIGraphicsGetCurrentContext() else {
          return UIImage()
      }
      layer.render(in: context)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image!
  }
    func insertHorizontalGradient( color1: UIColor,  color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        //gradient.frame = bounds
        gradient.frame = CGRect(x: bounds.origin.x , y: bounds.origin.y, width: UIScreen.main.bounds.width , height: bounds.height)
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners(radius: CGFloat = 10, corners: UIRectCorner = .allCorners) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                var arr: CACornerMask = []
                
                let allCorners: [UIRectCorner] = [.topLeft, .topRight, .bottomLeft, .bottomRight, .allCorners]
                
                for corn in allCorners {
                    if(corners.contains(corn)){
                        switch corn {
                        case .topLeft:
                            arr.insert(.layerMinXMinYCorner)
                        case .topRight:
                            arr.insert(.layerMaxXMinYCorner)
                        case .bottomLeft:
                            arr.insert(.layerMinXMaxYCorner)
                        case .bottomRight:
                            arr.insert(.layerMaxXMaxYCorner)
                        case .allCorners:
                            arr.insert(.layerMinXMinYCorner)
                            arr.insert(.layerMaxXMinYCorner)
                            arr.insert(.layerMinXMaxYCorner)
                            arr.insert(.layerMaxXMaxYCorner)
                        default: break
                        }
                    }
                }
                self.layer.maskedCorners = arr
            } else {
               // self.roundCornersBezierPath(corners: corners, radius: radius)
            }
        }
    
  
}
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}
