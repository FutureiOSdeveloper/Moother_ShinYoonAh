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
        view.addSubviews([tableView, headerView])
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint.isActive = true
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(WeatherWeekTVC.self, forCellReuseIdentifier: WeatherWeekTVC.identifier)
        tableView.dataSource = self
        tableView.delegate = self
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
                
                if self.headerHeightConstraint.constant >= 330 {
                    headerView.temperatureLabel.alpha = 1
                    headerView.degreeLabel.alpha = 1
                    headerView.limitTemperatureLabel.alpha = 1
                } else {
                    headerView.temperatureLabel.alpha += abs(scrollView.contentOffset.y/200)
                    headerView.degreeLabel.alpha += abs(scrollView.contentOffset.y/200)
                    headerView.limitTemperatureLabel.alpha += abs(scrollView.contentOffset.y/200)
                }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherWeekTVC.identifier) as? WeatherWeekTVC else { return UITableViewCell() }
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherVC: UITableViewDelegate { }
