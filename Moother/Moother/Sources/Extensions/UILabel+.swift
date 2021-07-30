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
}
