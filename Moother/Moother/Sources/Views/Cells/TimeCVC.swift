//
//  TimeCVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

class TimeCVC: UICollectionViewCell {
    static let identifier = "TimeCVC"
    
    let timeLabel = UILabel()
    let humidityLabel = UILabel()
    let temperatureLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        timeLabel.text = ""
        timeLabel.font = .systemFont(ofSize: 17)
        humidityLabel.text = ""
        temperatureLabel.text = ""
        timeLabel.text = ""
        imageView.image = UIImage()
    }
    
    private func configUI() {
        backgroundColor = .clear
        
        timeLabel.font = .systemFont(ofSize: 17)
        timeLabel.textColor = .white
        
        humidityLabel.font = .systemFont(ofSize: 13, weight: .medium)
        humidityLabel.textColor = .cyan
          
        temperatureLabel.textColor = .white
        temperatureLabel.font = .systemFont(ofSize: 20)
        
        imageView.tintColor = .systemYellow
    }
    
    private func setupLayout() {
        addSubviews([timeLabel,
                     humidityLabel,
                     temperatureLabel,
                     imageView])
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(25)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
