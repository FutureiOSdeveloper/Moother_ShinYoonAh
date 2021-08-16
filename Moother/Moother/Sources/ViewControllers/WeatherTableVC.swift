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
    var sendSelectedIndex: ((Int) -> ())?
    
    lazy var weatherTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: -UIApplication.statusBarHeight, left: 0, bottom: 0, right: 0)
        $0.delegate = self
        $0.dataSource = self
        let nib = UINib(nibName: AreaTVC.identifier, bundle: nil)
        $0.register(nib, forCellReuseIdentifier: AreaTVC.identifier)
    }
    lazy var footer = WeatherTableFooter(root: self)
    
    var areas: [String] = []
    var tempers: [WeatherResponse] = []
    var isFar = false
    var isClicked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
        setupNotification()
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
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationDegree(_:)), name: NSNotification.Name("degree"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationTitle(_:)), name: NSNotification.Name("title"), object: nil)
    }
    
    @objc
    func getLocationTitle(_ notification: Notification) {
        let data = notification.object as! String
        
        areas.append(data)
        weatherTableView.reloadData()
    }
    
    @objc
    func getLocationDegree(_ notification: Notification) {
        let data = notification.object as! WeatherResponse
        
        tempers.append(data)
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
            if areas.count != 0 {
                return areas.count - 1
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTVC.identifier) as? AreaTVC else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.timeLabel.text = "성남시"
            cell.setupLabel(area: "나의 위치")
        } else {
            cell.setupLabel(area: areas[indexPath.row+1], temper: "\(tempers[indexPath.row+1].current.temp)")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            sendSelectedIndex?(0)
        default:
            sendSelectedIndex?(indexPath.row+1)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                
                areas.remove(at: indexPath.row+1)
                tempers.remove(at: indexPath.row+1)
                NotificationCenter.default.post(name: NSNotification.Name("remove"), object: indexPath.row+1)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
