//
//  UITextField+SecureToggle.swift.swift
//  OnCallDoc
//
//  Created by Harinder Rana on 17/02/22.
//

import Foundation
import UIKit

let button = UIButton(type: .custom)

extension UITextField {
    
    func enablePasswordToggle(){
        
        button.setImage(UIImage(named: "icons8-eye-48"), for: .normal)
        button.setImage(UIImage(named: "icons8-closed-eye-48"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
        button.alpha = 1
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        Haptics.manager.trigger(type: .light)
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
}
