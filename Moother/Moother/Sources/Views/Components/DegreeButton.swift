//
//  DegreeButton.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/01.
//

import UIKit

import Then
import SnapKit

class DegreeButton: UIButton {
    override var isSelected: Bool {
        didSet {
            celsiusButton.textColor = isCelsius ? .white : .gray
            fahButton.textColor = isCelsius ? .gray : .white
            isCelsius.toggle()
        }
    }
    
    var celsiusButton = UILabel().then {
        $0.text = "℃"
        $0.textColor = .white
    }
    var fahButton = UILabel().then {
        $0.text = "℉"
        $0.textColor = .gray
    }
    let spacerLabel = UILabel().then {
        $0.text = "/"
        $0.textColor = .gray
    }
    
    var isCelsius = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([celsiusButton, fahButton, spacerLabel])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        celsiusButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        spacerLabel.snp.makeConstraints {
            $0.centerY.equalTo(celsiusButton.snp.centerY)
            $0.leading.equalTo(celsiusButton.snp.trailing).offset(3)
        }
        
        fahButton.snp.makeConstraints {
            $0.top.equalTo(celsiusButton.snp.top)
            $0.leading.equalTo(spacerLabel.snp.trailing).offset(3)
        }
        
        self.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }
    }
}
