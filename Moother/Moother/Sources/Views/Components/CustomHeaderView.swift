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
        
        areaLabel.text = "성남시"
    }
    
    private func setupLayout() {
        self.addSubviews([areaLabel])
        
        areaLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
