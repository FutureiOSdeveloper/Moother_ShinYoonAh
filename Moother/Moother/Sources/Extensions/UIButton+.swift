//
//  UIButton+.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

extension UIButton {
    func drawUnderline() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
        self.titleLabel?.attributedText = underlineAttributedString
    }
}
