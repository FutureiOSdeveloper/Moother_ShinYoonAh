//
//  WeatherVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/28.
//

import UIKit

import Then

class WeatherVC: UIViewController {
    // MARK: - Properties
    var tableView = UITableView()
    var headerView = CustomHeaderView(frame: CGRect.zero)
    var weatherTimeView = WeatherHeaderView()
    var headerHeightConstraint: NSLayoutConstraint!
    
    let headerHeight: CGFloat = 340
    let compactHeight: CGFloat = 120

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
    }
    
    // MARK: - Custom Methods
    private func setupLayout() {
        view.addSubviews([tableView, headerView, weatherTimeView])
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        
        weatherTimeView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(126)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(weatherTimeView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: WeatherWeekTVC.identifier, bundle: nil), forCellReuseIdentifier: WeatherWeekTVC.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .white.withAlphaComponent(0.3)
    }
}

// MARK: - UIScrollViewDelegate
extension WeatherVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && self.headerHeightConstraint.constant < headerHeight {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            self.headerView.labelHeightConstraint.constant += abs(scrollView.contentOffset.y)
            
            if headerView.labelHeightConstraint.constant >= 70 {
                headerView.labelHeightConstraint.constant = 70
            }
            
            if self.headerHeightConstraint.constant >= 270 {
                headerView.temperatureLabel.alpha += abs(scrollView.contentOffset.y/100)
                headerView.degreeLabel.alpha += abs(scrollView.contentOffset.y/100)
                headerView.limitTemperatureLabel.alpha += abs(scrollView.contentOffset.y/100)
            } else if self.headerHeightConstraint.constant >= 330 {
                headerView.temperatureLabel.alpha = 1
                headerView.degreeLabel.alpha = 1
                headerView.limitTemperatureLabel.alpha = 1
            }
        } else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= compactHeight {
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y/15
            headerView.labelHeightConstraint.constant -= scrollView.contentOffset.y/30
            headerView.temperatureLabel.alpha -= scrollView.contentOffset.y/900
            headerView.degreeLabel.alpha -= scrollView.contentOffset.y/900
            headerView.limitTemperatureLabel.alpha -= scrollView.contentOffset.y/900

            if self.headerHeightConstraint.constant <= compactHeight {
                self.headerHeightConstraint.constant = compactHeight
            }
            
            if headerView.labelHeightConstraint.constant <= 10 {
                headerView.labelHeightConstraint.constant = 10
                
                headerView.temperatureLabel.alpha = 0
                headerView.degreeLabel.alpha = 0
                headerView.limitTemperatureLabel.alpha = 0
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherWeekTVC.identifier) as? WeatherWeekTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherWeekTVC.identifier) as? WeatherWeekTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension WeatherVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 315
    }
}
