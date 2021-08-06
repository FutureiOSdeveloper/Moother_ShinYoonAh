//
//  LocationVC.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/08/05.
//

import UIKit
import MapKit

import Then
import SnapKit

class LocationVC: UIViewController {
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    private let searchTableCellIdentifier = "SearchTVC"
    
    lazy var searchResultTable = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(UINib(nibName: searchTableCellIdentifier, bundle: nil), forCellReuseIdentifier: searchTableCellIdentifier)
    }
    var backgroundView = UIView()
    var headerView = UIView().then {
        $0.backgroundColor = .init(red: 54/255, green: 57/255, blue: 59/255, alpha: 1.0)
    }
    var infoLabel = UILabel().then {
        $0.text = "도시, 우편번호 또는 공항 위치 입력"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configUI()
        setupNotification()
    }
    
    private func setupLayout() {
        view.addSubviews([backgroundView, searchResultTable, headerView])
        headerView.addSubviews([infoLabel, searchBar])
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResultTable.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configUI() {
        view.backgroundColor = .black.withAlphaComponent(0)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        backgroundView.addSubview(visualEffectView)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.systemGray4
        
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray4])
        searchBar.searchTextField.backgroundColor = UIColor.init(red: 116/255, green: 120/255, blue: 123/255, alpha: 1.0)
        searchBar.searchTextField.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        searchBar.barTintColor = .init(red: 54/255, green: 57/255, blue: 59/255, alpha: 1.0)
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissVC), name: NSNotification.Name("degree"), object: nil)
    }
    
    @objc
    func dismissVC() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension LocationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultTable.dequeueReusableCell(withIdentifier: searchTableCellIdentifier, for: indexPath)
        let searchResult = searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        if let text = searchBar.searchTextField.text {
            cell.textLabel?.textColor = UIColor.systemGray
            cell.textLabel?.addCharacterColor(word: text)
        }
        return cell
    }
}

extension LocationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
//            let coordinate = Coordinate(coordinate: placeMark.coordinate)
//            self.delegate?.userAdd(newLocation: Location(coordinate: coordinate, name: "\(placeMark.locality ?? selectedResult.title)"))
            print(placeMark)
            guard let vc = self.storyboard?.instantiateViewController(identifier: "WeatherVC") as? WeatherVC else { return }
            if let area = placeMark.locality {
                vc.headerView.areaLabel.text = area
                vc.selectBackgroundByTimeFormat()
            }
            vc.isLocation = true
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension LocationVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
        
        /// 사용자가 search bar 에 입력한 text를 자동완성 대상에 넣는다
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LocationVC: MKLocalSearchCompleterDelegate {
    /// 자동완성 완료시 결과를 받는 method
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension LocationVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
