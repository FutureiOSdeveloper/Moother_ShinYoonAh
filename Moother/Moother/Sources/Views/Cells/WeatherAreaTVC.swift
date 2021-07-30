//
//  WeatherAreaTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

class WeatherAreaTVC: UITableViewCell {
    static let identifier = "WeatherAreaTVC"
    
    let infoLabel = UILabel()
    let mapButton = UIButton()

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
        infoLabel.text = "광장동 날씨."
        infoLabel.textColor = .white
        
        mapButton.setTitle("지도에서 열기", for: .normal)
        mapButton.setTitleColor(.white, for: .normal)
        mapButton.drawUnderline()
        mapButton.titleLabel?.font = .systemFont(ofSize: 17)
    }
    
    private func setupLayout() {
        self.addSubviews([infoLabel, mapButton])
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
        }
        
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(infoLabel.snp.trailing).offset(5)
        }
    }
}
