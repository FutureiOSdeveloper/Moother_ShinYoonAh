//
//  MainPageVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/28.
//

import UIKit

import SnapKit

class MainPageVC: UIPageViewController {
    var completeHandler: ((Int) -> ())?
    
    // MARK: - Properties
    var viewsList: [UIViewController] = []
    var areas: [String] = ["성남시", "파리"]
    var degrees: [String] = ["16", "15"]
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }
    
    var rootVC: MainVC?
    var currentPage = 0

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pageInit()
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setViewControllersFromIndex(index: currentPage)
    }
    
    // MARK: - Custom Methods
    private func pageInit() {
        self.dataSource = self
        self.delegate = self
        
        view.backgroundColor = .clear
        
        guard let weatherVC = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(identifier: "WeatherVC") as? WeatherVC else {
            return }
        weatherVC.headerView.areaLabel.text = areas[0]
        weatherVC.headerView.temperatureLabel.text = degrees[0]
        guard let weather2VC = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(identifier: "WeatherVC") as? WeatherVC else {
            return }
        weather2VC.headerView.areaLabel.text = areas[1]
        weather2VC.headerView.temperatureLabel.text = degrees[1]
        viewsList = [weatherVC, weather2VC]
        
        rootVC?.pageControl.numberOfPages = viewsList.count
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
        
        weatherVC.headerView.areaLabel.text = area
        viewsList.insert(weatherVC, at: viewsList.count)
        rootVC?.pageControl.numberOfPages = viewsList.count
    }
    
    func removeViewController(index: Int) {
        viewsList.remove(at: index)
        areas.remove(at: index)
        degrees.remove(at: index)
        rootVC?.pageControl.numberOfPages = viewsList.count
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationTitle(_:)), name: NSNotification.Name("title"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationDegree(_:)), name: NSNotification.Name("degree"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeLocation(_:)), name: NSNotification.Name("remove"), object: nil)
    }
    
    @objc
    func getLocationTitle(_ notification: Notification) {
        let data = notification.object as! String
        
        makeNewViewController(area: data)
    }

    @objc
    func getLocationDegree(_ notification: Notification) {
        let data = notification.object as! String
        
        degrees.append(data)
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
