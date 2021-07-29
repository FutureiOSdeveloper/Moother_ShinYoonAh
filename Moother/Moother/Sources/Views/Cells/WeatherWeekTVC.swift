//
//  WeatherWeekTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/29.
//

import UIKit

class WeatherWeekTVC: UITableViewCell {
    static let identifier = "WeatherWeekTVC"

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Custom Method
    private func configUI() {
        
    }
}
