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
        tableView.register(UINib(nibName: WeatherWeekTVC.identifier, bundle: nil), forCellReuseIdentifier: WeatherWeekTVC.identifier)
        tableView.register(UINib(nibName: WeatherInfoTVC.identifier, bundle: nil), forCellReuseIdentifier: WeatherInfoTVC.identifier)
        tableView.register(UINib(nibName: WeatherDetailTVC.identifier, bundle: nil), forCellReuseIdentifier: WeatherDetailTVC.identifier)
        tableView.register(UINib(nibName: WeatherAreaTVC.identifier, bundle: nil), forCellReuseIdentifier: WeatherAreaTVC.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .white.withAlphaComponent(0.7)
    }
}

// MARK: - UIScrollViewDelegate
extension WeatherVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0  {
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerHeight {
            animateHeader()
        }
    }
    
    func animateHeader() {
        self.headerHeightConstraint.constant = headerHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoTVC.identifier) as? WeatherInfoTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailTVC.identifier) as? WeatherDetailTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherAreaTVC.identifier) as? WeatherAreaTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension WeatherVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 315
        case 1:
            return 60
        case 2:
            return 300
        default:
            return 40
        }
    }
}
