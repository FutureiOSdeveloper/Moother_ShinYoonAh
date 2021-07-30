//
//  DetailTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

import SnapKit
import Then

class DetailTVC: UITableViewCell {
    static let identifier = "DetailTVC"
    
    let leftTitleLabel = UILabel().then {
        $0.text = "일출"
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.font = .systemFont(ofSize: 12)
    }
    let leftInfoLabel = UILabel().then {
        $0.text = "05:34"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        $0.setupShadow()
    }
    let rightTitleLabel = UILabel().then {
        $0.text = "일몰"
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.font = .systemFont(ofSize: 12)
    }
    let rightInfoLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "19:41"
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        $0.setupShadow()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupLayout() {
        addSubviews([leftTitleLabel, leftInfoLabel, rightTitleLabel, rightInfoLabel])
        
        leftTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(25)
        }
        
        leftInfoLabel.snp.makeConstraints {
            $0.top.equalTo(leftTitleLabel.snp.bottom)
            $0.leading.equalTo(leftTitleLabel.snp.leading)
        }
        
        rightTitleLabel.snp.makeConstraints {
            $0.top.equalTo(leftTitleLabel.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.centerX)
        }
        
        rightInfoLabel.snp.makeConstraints {
            $0.top.equalTo(rightTitleLabel.snp.bottom)
            $0.leading.equalTo(rightTitleLabel.snp.leading)
        }
    }
    
    private func configUI() {
        backgroundColor = .clear
    }
}
