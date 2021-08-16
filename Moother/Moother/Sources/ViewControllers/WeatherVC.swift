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
    
    // MARK: - LocationVC Properties
    let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.textColor = .white
    }
    var isLocation = false
    
    let headerHeight: CGFloat = 340
    let compactHeight: CGFloat = 120
    
    var weatherData: WeatherResponse?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupWeatherData()
        
        if isLocation {
            setupLocationLayout()
            setupLocationAction()
        }
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
    
    private func setupLocationLayout() {
        view.addSubviews([cancelButton, addButton])
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(25)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.trailing.equalToSuperview().inset(25)
        }
    }
    
    private func setupLocationAction() {
        let cancelAction = UIAction { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let addAction = UIAction { _ in
            if let title = self.headerView.areaLabel.text,
               let degree = self.headerView.temperatureLabel.text {
                NotificationCenter.default.post(name: NSNotification.Name("title"), object: title)
                NotificationCenter.default.post(name: NSNotification.Name("degree"), object: degree)
            }
        }
        addButton.addAction(addAction, for: .touchUpInside)
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
    
    func setupWeatherData() {
        if let temp = weatherData?.current.temp,
           let tempMax = weatherData?.daily[0].temp.max,
           let tempMin = weatherData?.daily[0].temp.min,
           let currentDescripation = weatherData?.current.weather[0].weatherDescription,
           let hours = weatherData?.hourly,
           let timeZone = weatherData?.timezone,
           let sunset = weatherData?.current.sunset,
           let sunrise = weatherData?.current.sunrise {
            headerView.temperatureLabel.text = "\(Int(round(temp)))"
            headerView.limitTemperatureLabel.text = "최고:\(Int(round(tempMax)))º 최저:\(Int(round(tempMin)))º"
            headerView.wordWeatherLabel.text = currentDescripation
            weatherTimeView.times = hours
            weatherTimeView.timeZone = Int(timeZone)
            weatherTimeView.sunTimes.append(contentsOf: [sunset, sunrise])
            weatherTimeView.times.append(contentsOf: [
                Current(dt: sunset, sunrise: 0, sunset: sunset, temp: 0, feelsLike: 0, pressure: 0, humidity: 0, dewPoint: 0, uvi: 0, clouds: 0, visibility: 0, windSpeed: 0, windDeg: 0, windGust: 0, weather: [], pop: 0, rain: Rain(the1H: 0)),
                Current(dt: sunrise, sunrise: sunrise, sunset: 0, temp: 0, feelsLike: 0, pressure: 0, humidity: 0, dewPoint: 0, uvi: 0, clouds: 0, visibility: 0, windSpeed: 0, windDeg: 0, windGust: 0, weather: [], pop: 0, rain: Rain(the1H: 0))
            ])
            weatherTimeView.times = weatherTimeView.times.sorted(by: { $0.dt < $1.dt })
            
            var isValidTime = false
            let dateConveter = DateConverter()
            let sunriseTime = dateConveter.convertingUTCtime("\(sunrise)").toStringCompareUTC(Int(timeZone) ?? 32400)
            for (index, current) in weatherTimeView.times.enumerated() {
                if index == 0 { continue }
                let time = dateConveter.convertingUTCtime("\(current.dt)").toStringCompareUTC(Int(timeZone) ?? 32400)
                for i in time {
                    if i == "0" {
                        if time == sunriseTime {
                            let answer = weatherTimeView.times[0]
                            weatherTimeView.times.insert(answer, at: index+1)
                            weatherTimeView.times.removeFirst()
                            
                            if weatherTimeView.times[0].sunrise == 0 {
                                weatherTimeView.times.removeFirst()
                            }
                            isValidTime = true
                            break
                        }
                    } else {
                        break
                    }
                }
                
                if isValidTime {
                    break
                }
            }
        }
  
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
            if let tempMax = weatherData?.daily[0].temp.max,
               let tempMin = weatherData?.daily[0].temp.min {
                cell.infoLabel.text = "오늘: 현재 날씨 한때 흐름, 최고 기온은 \(Int(round(tempMax)))º입니다.\n오늘 밤 날씨 대체로 흐름, 최저 기온은 \(Int(round(tempMin)))º입니다."
            }
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
