//
//  ExtLabel.swift
//  TNC360
//
//  Created by Shiwani Thakur on 19/04/21.
//

import Foundation
import UIKit

extension UILabel{
    
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
      attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: self.text?.count ?? 0))
        self.attributedText = attributedString
    }
    
  var optimalWidth : CGFloat {
        get {
          let txtView = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: self.frame.height))
          
          txtView.numberOfLines = 0
          //label.lineBreakMode = self.lineBreakMode
          txtView.font = self.font
          txtView.text = self.text
          txtView.sizeToFit()
          
          return txtView.frame.width
        }
      }
      
      var optimalHeight : CGFloat {
        get {
          let txtView = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width,height: CGFloat.greatestFiniteMagnitude))
          
          txtView.numberOfLines = 0
          //txtView.lineBreakMode = self.lineBreakMode
          txtView.font = self.font
          txtView.text = self.text
          
          txtView.sizeToFit()
          
          return txtView.frame.height
        }
        
      }
}
