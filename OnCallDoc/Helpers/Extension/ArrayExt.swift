//
//  ArrayExt.swift
//  TNC360
//
//  Created by Shiwani Thakur on 03/08/21.
//

import Foundation
import UIKit

extension Array {
func stringyfy() -> String {
  do {
    let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    return String(data: data, encoding: String.Encoding.utf8) ?? ""
  } catch {
    return ""
  }
}
}

extension  Dictionary {
func stringyfy() -> String {
  do {
    let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    return String(data: data, encoding: String.Encoding.utf8) ?? ""
  } catch {
    return ""
  }
}
}
