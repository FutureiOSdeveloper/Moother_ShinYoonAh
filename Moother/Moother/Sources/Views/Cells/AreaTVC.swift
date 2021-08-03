//
//  AreaTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/01.
//

import UIKit

import Then
import SnapKit
import Lottie

class AreaTVC: UITableViewCell {
    static let identifier = "AreaTVC"
    
    let lottieView = UIImageView(image: UIImage(named: "sunnynight")).then {
        $0.contentMode = .scaleToFill
    }
    let timeLabel = UILabel().then {
        $0.textColor = .white
        $0.setupShadow()
        $0.font = .systemFont(ofSize: 17)
        $0.text = "07:21"
    }
    let areaLabel = UILabel().then {
        $0.textColor = .white
        $0.setupShadow()
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        $0.text = "파리"
    }
    let temperatureLabel = UILabel().then {
        $0.textColor = .white
        $0.setupShadow()
        $0.font = .systemFont(ofSize: 70, weight: .thin)
        $0.text = "16º"
        $0.addCharacterSpacing(kernValue: 5)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout() {
        addSubviews([lottieView,
                     timeLabel,
                     areaLabel,
                     temperatureLabel])
        
        lottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(25)
        }
        
        areaLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(timeLabel.snp.leading)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(25)
        }
    }
}
