//
//  WeatherWeekTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/29.
//

import UIKit

import Then
import SnapKit

class WeatherWeekTVC: UITableViewCell {
    static let identifier = "WeatherWeekTVC"
    
    let tableView = UITableView()

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
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeekTVC.identifier, bundle: nil), forCellReuseIdentifier: WeekTVC.identifier)
    }
    
    private func setupLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension WeatherWeekTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekTVC.identifier) as? WeekTVC else { return UITableViewCell() }
        cell.backgroundColor = .clear
        return cell
    }
}

extension WeatherWeekTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
