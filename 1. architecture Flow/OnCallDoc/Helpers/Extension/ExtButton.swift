//
//  ExtButton.swift
//  TNC360
//
//  Created by Shiwani Thakur on 19/04/21.
//

import Foundation
import UIKit

extension UIButton{
    
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text?.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
