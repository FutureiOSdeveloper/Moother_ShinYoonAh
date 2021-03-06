//
//  MainVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/28.
//

import UIKit

import Then
import SnapKit
import Lottie

class MainVC: UIViewController {
    // MARK: - Properties
    lazy var lottieView = AnimationView(name: selectLottieByTimeFormat())
    let toolBar = UIToolbar().then {
        $0.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }
    let weatherChannelButton = UIButton().then {
        $0.setImage(UIImage(named: "weatherChannel"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.alpha = 0.5
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(30)
        }
    }
    let weatherListButton = UIButton().then {
        $0.setImage(UIImage(systemName: "list.dash"), for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tappedWeatherList), for: .touchUpInside)
    }
    let containerView = UIView()
    let pageControl = UIPageControl()
    
    var items: [UIBarButtonItem] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configUI()
        setupButtonAction()
        setupToolbarItem()
        setupContainerView()
        setupPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            self.lottieView.isHidden = false
            self.lottieView.fadeIn()
        })
        
        lottieView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(printForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - Custom Method
    fileprivate func setupLayout() {
        view.addSubviews([lottieView, toolBar, containerView, pageControl])
        
        toolBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        lottieView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(300)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(toolBar.snp.centerY)
        }
    }
    
    fileprivate func configUI() {
        lottieView.backgroundColor = .clear
        lottieView.center = view.center
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFill
        lottieView.layer.masksToBounds = true
        lottieView.isHidden = true
        lottieView.alpha = 0.2
    }
    
    private func setupButtonAction() {
        let weatherAction = UIAction { _ in
            if let url = URL(string: "https://weather.com/ko-KR/weather/today/l/KSXX0037:1:KS?Goto=Redirected") {
                        UIApplication.shared.open(url, options: [:])
            }
        }
        weatherChannelButton.addAction(weatherAction, for: .touchUpInside)
    }
    
    private func setupToolbarItem() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let leftButton = UIBarButtonItem(customView: weatherChannelButton)
        let rightButton = UIBarButtonItem(customView: weatherListButton)
        
        items.append(leftButton)
        items.append(flexibleSpace)
        items.append(rightButton)
        
        toolBar.setItems(items, animated: true)
    }
    
    private func setupContainerView() {
        guard let vc = UIStoryboard(name: "Weather", bundle: nil).instantiateViewController(identifier: "MainPageVC") as? MainPageVC else { return }
        addChild(vc)
        
        vc.rootVC = self
        containerView.addSubview(vc.view)
        
        vc.view.snp.makeConstraints {
            $0.edges.equalTo(containerView.snp.edges)
        }
    }
    
    private func setupPageControl() {
         pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
    @objc
    func tappedWeatherList() {
        let vc = WeatherTableVC()
        
        vc.sendSelectedIndex = { index in
            print(index)
            self.pageControl.currentPage = index
            if let pageVC = self.children[0] as? MainPageVC {
                pageVC.setViewControllersFromIndex(index: index)
            }
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        if let pageVC = self.children[0] as? MainPageVC {
            vc.areas = pageVC.areas
            vc.tempers = pageVC.weathers
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func printForeground() {
        lottieView.play()
    }
}
