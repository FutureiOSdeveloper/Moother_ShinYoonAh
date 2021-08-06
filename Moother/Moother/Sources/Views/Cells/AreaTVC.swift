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
    
    let lottieView = UIImageView(image: UIImage(named: "sunny")).then {
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
    }
    let temperatureLabel = UILabel().then {
        $0.textColor = .white
        $0.setupShadow()
        $0.font = .systemFont(ofSize: 70, weight: .thin)
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
        
        areaLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(timeLabel.snp.leading)
        }
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(areaLabel.snp.top).offset(-3)
            $0.leading.equalToSuperview().inset(25)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(25)
        }
    }
    
    func changeTemper(isFar: Bool) {
        if isFar {
            if let temp = temperatureLabel.text {
                let new = temp.split(separator: "º")
                let far = Int(new[0])! + 32
                temperatureLabel.text = "\(far)º"
            }
        } else {
            if let temp = temperatureLabel.text {
                let new = temp.split(separator: "º")
                let cel = Int(new[0])! - 32
                temperatureLabel.text = "\(cel)º"
            }
        }
    }
    
    func setupLabel(area: String, temper: String? = "16") {
        areaLabel.text = area
        if let temper = temper {
            temperatureLabel.text = "\(temper)º"
        }
    }
}
