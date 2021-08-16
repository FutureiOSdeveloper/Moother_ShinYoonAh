//
//  WeatherAreaTVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit
import MapKit

class WeatherAreaTVC: UITableViewCell {
    static let identifier = "WeatherAreaTVC"
    
    let infoLabel = UILabel()
    let mapButton = UIButton()

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
        infoLabel.textColor = .white
        
        mapButton.setTitle("지도에서 열기", for: .normal)
        mapButton.setTitleColor(.white, for: .normal)
        mapButton.drawUnderline()
        mapButton.titleLabel?.font = .systemFont(ofSize: 17)
        mapButton.addTarget(self, action: #selector(touchUpMap), for: .touchUpInside)
    }
    
    private func setupLayout() {
        self.addSubviews([infoLabel, mapButton])
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
        }
        
        mapButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(infoLabel.snp.trailing).offset(5)
        }
    }
    
    @objc
    func touchUpMap() {
        let latitude: CLLocationDegrees = 37.4564
        let longitude: CLLocationDegrees = 127.1286
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "성남시"
        mapItem.openInMaps(launchOptions: options)
    }
}
