//
//  WeatherTableVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/01.
//

import UIKit

import Then
import SnapKit

class WeatherTableVC: UIViewController {
    lazy var weatherTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: -UIApplication.statusBarHeight, left: 0, bottom: 0, right: 0)
        $0.delegate = self
        $0.dataSource = self
        let nib = UINib(nibName: AreaTVC.identifier, bundle: nil)
        $0.register(nib, forCellReuseIdentifier: AreaTVC.identifier)
    }
    lazy var footer = WeatherTableFooter(root: self)
    
    var areas = 0
    var isFar = false
    var isClicked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    private func configUI() {
        view.backgroundColor = .black
        
        footer.degreeButton.addTarget(self, action: #selector(pressedDegree), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(weatherTableView)
        weatherTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func pressedDegree() {
        isFar.toggle()
        weatherTableView.reloadData()
        isClicked = true
    }
}

extension WeatherTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if areas != 0 {
                return areas - 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTVC.identifier) as? AreaTVC else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.timeLabel.text = "성남시"
            cell.areaLabel.text = "나의 위치"
        }
        
        if isClicked {
            cell.changeTemper(isFar: isFar)
        }
        
        cell.backgroundColor = .clear
        return cell
    }
}

extension WeatherTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView(frame: CGRect.zero)
        default:
            return footer
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        default:
            return 90
        }
    }
}
