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
    
    lazy var searchResultTable = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }
    var infoLabel = UILabel()
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configUI()
    }
    
    private func setupLayout() {
        view.addSubviews([searchResultTable, searchBar])
    }
    
    private func configUI() {
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
}

extension LocationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension LocationVC: UITableViewDelegate { }

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
