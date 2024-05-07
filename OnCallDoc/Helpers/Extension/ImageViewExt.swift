//
//  ImageExt.swift
//  BuzzyTap
//
//  Created by Shiwani Thakur on 24/11/20.
//

import Foundation
import UIKit
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async { [weak self] in
                        self?.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self?.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
  
  func applyBlurEffectOnImageView() {
    if !UIAccessibility.isReduceTransparencyEnabled {
    let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    blurredView.frame = self.bounds
    backgroundColor = .clear
      blurredView.backgroundColor = .clear
      isUserInteractionEnabled = true
    addSubview(blurredView)
    }
     }
}

extension UIImage
{
  func resized(withPercentage percentage: CGFloat) -> UIImage? {
  let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
  UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
  defer { UIGraphicsEndImageContext() }
  draw(in: CGRect(origin: .zero, size: canvasSize))
  return UIGraphicsGetImageFromCurrentImageContext()
  }
  
  enum JPEGQuality: CGFloat {
  case lowest = 0
  case low = 0.27
  case medium = 0.5
  case high = 0.75
  case highest = 1
  }
  
  func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
          return jpegData(compressionQuality: jpegQuality.rawValue)
      }
}
