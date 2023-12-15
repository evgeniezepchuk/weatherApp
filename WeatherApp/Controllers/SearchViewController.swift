//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 11.12.23.
//

import UIKit

class SearchViewController: UIViewController {
    
    var cities: [Cities]?
    
    private let searchBar = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search"
        controller.searchBar.tintColor = .systemBlue
        return controller
    }()
    
    private let tableView = {
        let tb = UITableView()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.backgroundColor = .clear
        
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
        definesPresentationContext = true
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .bckrgndColor
        cell.tintColor = .black
        if self.cities != nil {
            DispatchQueue.main.async {
                cell.textLabel?.text = (self.cities![indexPath.row].name ?? "") + ", " + (self.cities![indexPath.row].country ?? "")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let lat = cities?[indexPath.row].lat, let lon = cities?[indexPath.row].lon else { return }
        APIManager.shared.getWeather(latitide: lat, longitutde: lon) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    let vc = ViewController()
                    vc.reconfigureView(city: self.cities![indexPath.row].name ?? "", model: weather, isOn: false)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.searchTextField.text
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty,
              text.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        
        APIManager.shared.getCityWeather(cityName: text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

