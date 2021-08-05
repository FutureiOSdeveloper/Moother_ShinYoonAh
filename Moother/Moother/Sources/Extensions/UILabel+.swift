//
//  UILabel+.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

extension UILabel {
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.masksToBounds = false
    }
    
    func addCharacterSpacing(kernValue: Double = -0.22) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
            
            if #available(iOS 14.0, *) {
                lineBreakStrategy = .hangulWordPriority
            } else {
                lineBreakMode = .byWordWrapping
            }
        }
    }
    
    func addCharacterColor(word: String) {
        if let labelText = text, labelText.count > 0 {
            let attributedStr = NSMutableAttributedString(string: labelText)
            attributedStr.addAttribute(.foregroundColor, value: UIColor.white, range: (labelText as NSString).range(of: word))
            
            attributedText = attributedStr
        }
    }
}
