//
//  UIViewController+.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

extension UIViewController {
    func selectBackgroundByTimeFormat() {
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH"
        let currentTimeString = formatterTime.string(from: Date())
        let currentTimeInt = Int(currentTimeString)!
          
        if currentTimeInt >= 18 || currentTimeInt <= 5 {
            view.backgroundColor = UIColor.init(red: 67/255, green: 74/255, blue: 84/255, alpha: 1.0)
        } else {
            view.backgroundColor = UIColor.init(red: 104/255, green: 153/255, blue: 235/255, alpha: 1.0)
        }
    }
    
    func selectLottieByTimeFormat() -> String {
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH"
        let currentTimeString = formatterTime.string(from: Date())
        let currentTimeInt = Int(currentTimeString)!
        
        if currentTimeInt >= 18 || currentTimeInt <= 5 {
            return "4796-weather-cloudynight"
        } else {
            return "4800-weather-partly-cloudy"
        }
    }
}
