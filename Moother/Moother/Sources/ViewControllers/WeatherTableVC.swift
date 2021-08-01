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
    lazy var weatherTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: -UIApplication.statusBarHeight, left: 0, bottom: 0, right: 0)
        $0.delegate = self
        $0.dataSource = self
    }
    
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
        return cell
    }
}

extension WeatherTableVC: UITableViewDelegate { }
