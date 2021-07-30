//
//  WeatherInfoTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

class WeatherInfoTVC: UITableViewCell {
    static let identifier = "WeatherInfoTVC"
    
    let infoLabel = UILabel()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Custom Method
    private func configUI() {
        infoLabel.text = "오늘: 현재 날씨 한때 흐름, 최고 기온은 36º입니다.\n오늘 밤 날씨 대체로 흐름, 최저 기온은 24º입니다."
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .white
        infoLabel.setupShadow()
    }
    
    private func setupLayout() {
        self.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(25)
        }
    }
}
