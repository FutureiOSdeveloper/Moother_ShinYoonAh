//
//  WeekTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

import SnapKit
import Then

class WeekTVC: UITableViewCell {
    static let identifier = "WeekTVC"
    
    let dayLabel = UILabel().then {
        $0.textColor = .white
    }
    let weatherImage = UIImageView().then {
        $0.tintColor = .systemYellow
    }
    let humidityLabel = UILabel().then {
        $0.textColor = .cyan
        $0.text = "40%"
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    let maxLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "34"
        $0.font = .systemFont(ofSize: 20)
    }
    let minLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.7)
        $0.text = "25"
        $0.font = .systemFont(ofSize: 20)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        dayLabel.text = ""
        dayLabel.font = .systemFont(ofSize: 20)
        humidityLabel.text = ""
        maxLabel.text = ""
        minLabel.text = ""
        weatherImage.image = UIImage()
    }

    private func setupLayout() {
        addSubviews([dayLabel, weatherImage, humidityLabel,
                     maxLabel, minLabel])
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.centerY.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(25)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weatherImage.snp.trailing).offset(5)
        }
        
        minLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalToSuperview()
        }
        
        maxLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(70)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configUI() {
        backgroundColor = .clear
    }
}
