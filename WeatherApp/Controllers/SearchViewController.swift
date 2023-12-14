//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 11.12.23.
//

import UIKit

class SearchViewController: UIViewController {
    
    var cities: [String] = ["a","v","f", "a","f"]

    private let searchBar = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a cities weather"
        controller.searchBar.tintColor = .white
        controller.searchBar.searchBarStyle = .minimal

        return controller
    }()
    
    private let tableView = {
        let tb = UITableView()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .bckrgndColor
        navigationItem.searchController = searchBar
        
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search"
//        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        guard self.cities != nil else { return UITableViewCell() }
        if !self.cities.isEmpty {
            //        DispatchQueue.main.async {
            cell.textLabel?.text = self.cities[indexPath.row] ?? ""
//            print(self.cities[indexPath.row].name)
        }
//        } else {
//            tableView.reloadData()
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.searchTextField.text
//        searchBar.delegate = self
//        print(text)
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty,
              text.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        print(text)
        APIManager.shared.getCityWeather(cityName: text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
//                    self.cities = cities
                    self.tableView.reloadData()
                    //                print(cities)
                case .failure(let error):
                    print(error)
                }
            }
        }
//        let resultController = searchController.searchResultsController
//        resultController.delegate = self
//        APIManager.shared.getCityWeather(cityName: text) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let weather):
//                    resultController.movies = movie
//                    print(resultController.movies.count)
//                    resultController.searchResultsCollectionView.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
    
}
