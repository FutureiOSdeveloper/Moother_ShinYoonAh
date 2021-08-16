//
//  WeatherDetailTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

import Then
import SnapKit

class WeatherDetailTVC: UITableViewCell {
    static let identifier = "WeatherDetailTVC"
    
    let tableView = UITableView()
    
    var current: Current?
    var timezone: Int?
    var details: [[String]] = [["일출", "일몰"], ["비 올 확률", "습도"], ["바람", "체감"], ["강수량", "기압"], ["가시거리", "자외선 지수"]]
    var detailInfos = Array(repeating: ["", ""], count: 5)

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
        tableView.separatorColor = .white.withAlphaComponent(0.7)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DetailTVC.identifier, bundle: nil), forCellReuseIdentifier: DetailTVC.identifier)
    }
    
    private func setupLayout() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension WeatherDetailTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
        cell.leftTitleLabel.text = details[indexPath.row][0]
        cell.rightTitleLabel.text = details[indexPath.row][1]
        
        switch indexPath.row {
        case 0:
            let dateConvert = DateConverter()
            if let sunrise = current?.sunrise,
               let sunset = current?.sunset,
               let timezone = timezone {
                cell.leftInfoLabel.text = dateConvert.convertingUTCtime("\(sunrise)").toStringSunUTC(timezone)
                cell.rightInfoLabel.text = dateConvert.convertingUTCtime("\(sunset)").toStringSunUTC(timezone)
            }
        case 1:
            if let humidity = current?.humidity,
               let dew = current?.dewPoint {
                cell.leftInfoLabel.text = "\(Int(round(dew)))%"
                cell.rightInfoLabel.text = "\(humidity)%"
            }
        case 2:
            if let windSpeed = current?.windSpeed,
               let feel = current?.feelsLike {
                cell.leftInfoLabel.text = "\(windSpeed)m/s"
                cell.rightInfoLabel.text = "\(feel)º"
            }
        case 3:
            if let rain = current?.rain?.the1H,
               let pressure = current?.pressure {
                cell.leftInfoLabel.text = "\(rain)cm"
                cell.rightInfoLabel.text = "\(pressure)hPa"
            }
        default:
            if let visible = current?.visibility{
                cell.leftInfoLabel.text  = "\(Double(visible) / 1000)km"
                cell.rightInfoLabel.text = "0"
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
}

extension WeatherDetailTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
