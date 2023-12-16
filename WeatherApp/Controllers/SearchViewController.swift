//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 11.12.23.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var cities: [Cities]?
    
    var delegat: ConfigureViewControllerDelegate?
    
    private lazy var searchBar = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search"
        controller.searchBar.tintColor = .systemBlue
        return controller
    }()
    
    private lazy var tableView = {
        let tb = UITableView()
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.backgroundColor = .clear
        tb.isScrollEnabled = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavBar()
        configureSearchBar()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    private func configureSearchBar() {
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureView() {
        view.addSubview(tableView)
        view.backgroundColor = .backgroundBlueColor
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = .none
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchBar
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .backgroundBlueColor
        cell.selectionStyle = .none
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
                    self.delegat = MainViewController()
                    guard let cities = self.cities, let delegat = self.delegat else { return }
                    delegat.reconfigureView(city: cities[indexPath.row].name ?? "", model: weather, isOn: false)
                    self.navigationController?.pushViewController(delegat as! UIViewController, animated: true)
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

