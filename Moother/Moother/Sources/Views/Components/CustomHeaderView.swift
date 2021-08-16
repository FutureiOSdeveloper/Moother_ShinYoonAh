//
//  CustomHeaderView.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/29.
//

import UIKit

import SnapKit

class CustomHeaderView: UIView {
    // MARK: - Properties
    let areaLabel = UILabel()
    let wordWeatherLabel = UILabel()
    let temperatureLabel = UILabel()
    let limitTemperatureLabel = UILabel()
    let degreeLabel = UILabel()
    
    var labelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        self.backgroundColor = UIColor.clear
        
        areaLabel.text = "광진구"
        areaLabel.font = .systemFont(ofSize: 30)
        areaLabel.textColor = .white
        areaLabel.setupShadow()
        
        wordWeatherLabel.font = .systemFont(ofSize: 18)
        wordWeatherLabel.textColor = .white
        
        temperatureLabel.font = .systemFont(ofSize: 80, weight: .thin)
        temperatureLabel.textColor = .white
        temperatureLabel.setupShadow()
        
        degreeLabel.text = "º"
        degreeLabel.font = .systemFont(ofSize: 60, weight: .thin)
        degreeLabel.textColor = .white
        degreeLabel.setupShadow()
        
        limitTemperatureLabel.font = .systemFont(ofSize: 18)
        limitTemperatureLabel.textColor = .white
    }
    
    private func setupLayout() {
        self.addSubviews([areaLabel,
                          wordWeatherLabel,
                          temperatureLabel,
                          limitTemperatureLabel,
                          degreeLabel])
        
        areaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        labelHeightConstraint = areaLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 70)
        labelHeightConstraint.isActive = true
        
        wordWeatherLabel.snp.makeConstraints {
            $0.top.equalTo(areaLabel.snp.bottom).offset(3)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(wordWeatherLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        limitTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        degreeLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureLabel.snp.trailing)
            $0.top.equalTo(temperatureLabel.snp.top).inset(5)
        }
    }
}
