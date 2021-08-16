//
//  MainPageVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/28.
//

import UIKit
import CoreLocation

import SnapKit

class MainPageVC: UIPageViewController {
    var completeHandler: ((Int) -> ())?
    
    // MARK: - Properties
    var viewsList: [UIViewController] = []
    var areas: [String] = []
    var weathers: [WeatherResponse] = []
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }
    var locationManger = CLLocationManager()
    var firstVC: WeatherVC?
    var rootVC: MainVC?
    var currentPage = 0
    
    let serverManager = WeatherManager.shared

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
        pageInit()
        setupNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setViewControllersFromIndex(index: currentPage)
    }
    
    // MARK: - Custom Methods
    private func pageInit() {
        self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = .clear
        
        guard let weatherVC = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(identifier: "WeatherVC") as? WeatherVC else {
            return }
        firstVC = weatherVC
        
        if !areas.isEmpty && !weathers.isEmpty {
            firstVC?.headerView.areaLabel.text = areas[0]
            firstVC?.weatherData = weathers[0]
        }

        viewsList = [firstVC ?? UIViewController()]
        
        rootVC?.pageControl.numberOfPages = viewsList.count
    }
    
    private func initLocation() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
  
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManger.startUpdatingLocation()
            print(locationManger.location?.coordinate)
        } else {
            print("위치 서비스 Off 상태")
        }
    }
    
    func setViewControllersFromIndex(index: Int) {
        if index < 0 && index >= viewsList.count { return }
        self.setViewControllers([viewsList[index]], direction: .forward, animated:true, completion: nil)
        completeHandler?(currentIndex)
    }
    
    func makeNewViewController(area: String) {
        print("생성")
        guard let weatherVC = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(identifier: "WeatherVC") as? WeatherVC else {
            return }
        areas.append(area)
        weatherVC.weatherData = weathers[weathers.count-1]
        weatherVC.headerView.areaLabel.text = area
        viewsList.insert(weatherVC, at: viewsList.count)
        rootVC?.pageControl.numberOfPages = viewsList.count
    }
    
    func removeViewController(index: Int) {
        viewsList.remove(at: index)
        areas.remove(at: index)
        weathers.remove(at: index)
        rootVC?.pageControl.numberOfPages = viewsList.count
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationDegree(_:)), name: NSNotification.Name("degree"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationTitle(_:)), name: NSNotification.Name("title"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeLocation(_:)), name: NSNotification.Name("remove"), object: nil)
    }
    
    @objc
    func getLocationTitle(_ notification: Notification) {
        let data = notification.object as! String
        
        makeNewViewController(area: data)
    }

    @objc
    func getLocationDegree(_ notification: Notification) {
        let data = notification.object as! WeatherResponse
        
        serverManager.fetchWeatherInfo(lat: data.lat, lon: data.lon) {
            [weak self] weather in
            self?.weathers.append(weather)
        }
    }
    
    @objc
    func removeLocation(_ notification: Notification) {
        let index = notification.object as! Int
        
        removeViewController(index: index)
    }
}

// MARK: - UIPageViewControllerDataSource
extension MainPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewsList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }
        return viewsList[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension MainPageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        rootVC?.pageControl.currentPage = currentIndex
        
        if completed {
            completeHandler?(currentIndex)
        }
    }
}

extension MainPageVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(locations[0]) { (placemarks, error) -> Void in
            if error != nil {
                NSLog("\(String(describing: error))")
                return
            }
            
            if let placemark = placemarks?.first,
                  let place = placemark.locality {
                if self.areas.isEmpty {
                    self.areas.append(place)
                } else {
                    self.areas[0] = place
                }
                
                self.firstVC?.headerView.areaLabel.text = place
            }
        }
        
        if let location = locations.first {
            serverManager.fetchWeatherInfo(lat: location.coordinate.latitude, lon: location.coordinate.longitude) {
                [weak self] weather in
                self?.weathers.append(weather)
                
                self?.firstVC?.weatherData = weather
                self?.firstVC?.setupWeatherData()
                self?.firstVC?.weatherTimeView.collectionView.reloadData()
                
                let dateConvert = DateConverter()
                self?.rootVC?.selectBackgroundByTimeFormat(time: dateConvert.convertingUTCtime("\(weather.current.dt)").toStringCompareUTC(weather.timezoneOffset))
            }
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        }
        
        locationManger.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
