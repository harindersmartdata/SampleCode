//
//  ExtTextView.swift
//  TNC360
//
//  Created by Shiwani Thakur on 27/08/21.
//

import UIKit

extension UITextView
{
  var optimalWidthTxtView : CGFloat {
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
  
  var optimalHeightTxtView : CGFloat {
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
