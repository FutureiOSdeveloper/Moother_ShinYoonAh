//
//  WeatherHeaderView.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

import Then
import SnapKit

class WeatherHeaderView: UIView {
    // MARK: - Properties
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
    let flowlayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    let topLineView = UIView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        $0.backgroundColor = .white.withAlphaComponent(0.3)
    }
    let bottomLineView = UIView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        $0.backgroundColor = .white.withAlphaComponent(0.3)
    }
    var times: [Current] = []
    
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
        self.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(TimeCVC.self, forCellWithReuseIdentifier: TimeCVC.identifier)
    }
    
    private func setupLayout() {
        self.addSubviews([collectionView,
                          topLineView,
                          bottomLineView])
        
        topLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension WeatherHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCVC.identifier, for: indexPath) as? TimeCVC else { return UICollectionViewCell() }
        cell.humidityLabel.text = "\(times[indexPath.item].humidity)"
        cell.temperatureLabel.text = "\(Int(round(times[indexPath.item].temp)))"
        cell.imageView.image = UIImage(systemName: times[indexPath.item].weather[0].icon.convertIcon())
        return cell
    }
}

extension WeatherHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 55
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 15, bottom: 8, right: 15)
    }
}
