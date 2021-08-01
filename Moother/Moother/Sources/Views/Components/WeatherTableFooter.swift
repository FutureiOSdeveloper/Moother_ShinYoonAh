//
//  WeatherTableFooter.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/01.
//

import UIKit

import Then
import SnapKit

class WeatherTableFooter: UIView {
    // MARK: - Properties
    let toolBar = UIToolbar().then {
        $0.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }
    let degreeButton = DegreeButton().then {
        $0.addTarget(self, action: #selector(tappedDegreeButton), for: .touchUpInside)
    }
    let weatherChannelButton = UIButton().then {
        $0.setImage(UIImage(named: "weatherChannel"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.alpha = 0.5
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(30)
        }
    }
    let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
    }
    var items: [UIBarButtonItem] = []
    
    // MARK: - Life Cycle
    override init(frame:CGRect) {
        super.init(frame: frame)
        configUI()
        setupLayout()
        setupToolbarItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        self.backgroundColor = UIColor.clear
        
        degreeButton.isSelected = true
    }
    
    fileprivate func setupLayout() {
        addSubview(toolBar)
        
        toolBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        degreeButton.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(20)
        }
    }
    
    private func setupToolbarItem() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let leftButton = UIBarButtonItem(customView: degreeButton)
        let middleButton = UIBarButtonItem(customView: weatherChannelButton)
        let rightButton = UIBarButtonItem(customView: searchButton)
        
        items.append(leftButton)
        items.append(flexibleSpace)
        items.append(middleButton)
        items.append(flexibleSpace)
        items.append(rightButton)
        
        toolBar.setItems(items, animated: true)
    }
    
    @objc
    func tappedSearchButton() {
        print("Search")
    }
    
    @objc
    func tappedDegreeButton() {
        degreeButton.isSelected.toggle()
    }
}
