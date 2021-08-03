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
    lazy var weatherTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        $0.contentInset = UIEdgeInsets(top: -85, left: 0, bottom: 0, right: 0)
        $0.delegate = self
        $0.dataSource = self
        let nib = UINib(nibName: AreaTVC.identifier, bundle: nil)
        $0.register(nib, forCellReuseIdentifier: AreaTVC.identifier)
    }
    let footer = WeatherTableFooter()
    
    var areas = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    private func configUI() {
        view.backgroundColor = .black
    }
    
    private func setupLayout() {
        view.addSubview(weatherTableView)
        weatherTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension WeatherTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTVC.identifier) as? AreaTVC else { return UITableViewCell() }
        cell.backgroundColor = .clear
        return cell
    }
}

extension WeatherTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
