//
//  ResultViewController.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 14.12.23.
//

import UIKit

class ResultViewController: UIViewController {

    var model: WeatherModel?
    var coord: (Double, Double) = (0,0)
    var headerView: HeaderView?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HourlyWeatherCell.self, forCellReuseIdentifier: "HourlyWeatherCell")
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: "DailyWeatherCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        tableView.delegate = self
        tableView.dataSource = self
        connectionLocating()
        configureTableView()
        configureNavBar()
        configureHeaderView()
        view.backgroundColor = .bckrgndColor
    }
    
    private func searchCitiesWeather() {
        APIManager.shared.getCityWeather(cityName: "Минск") { result in
            switch result {
            case .success(let cities):
                cities.forEach { value in
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getWeather() {
        self.coord = LocationManager.shared.coordinate
        DispatchQueue.main.async {
            print("------> coord", self.coord)
            self.loadAPI()
        }
    }
    
    
    private func loadAPI() {
        APIManager.shared.getWeather(latitide: coord.0, longitutde: coord.1) { [weak self] result in
            switch result {
            case .success(let weather):
//                print(weather)
                self?.model = weather
                DispatchQueue.main.async {
                    self?.headerView?.configureHeaderView(imageID: self?.model?.hourly?[0].weather?[0].icon! ?? "icon", city: self?.model?.timezone ?? "", temperature: String(Int(self?.model?.hourly?[0].temp ?? 0)))
//                    print(self?.model?.daily![0].dt)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureTableView() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureHeaderView() {
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: view.bounds.height / 3.5))
        self.tableView.tableHeaderView = headerView
    }
    
    private func configureNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchController))
    }
    
    private func connectionLocating() {
        if ConnectionManager.shared.isConnected {
//            tableView.backgroundColor = .green
        } else {
            do {
                let data = UserDefaults.standard.object(forKey: "data") as! Data
//                let weather = try JSONSerialization.jsonObject(with: data)
//                print(weather)
                let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.model = model
                DispatchQueue.main.async {
                    self.headerView?.configureHeaderView(imageID: self.model?.hourly?[0].weather?[0].icon! ?? "icon", city: self.model?.timezone ?? "", temperature: String(Int(self.model?.hourly?[0].temp ?? 0)))
                }
                
            
            } catch {
                print(error)
            }
        }
    }
    
    @objc func openSearchController() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    func configureResultVS(model: WeatherModel) {
        self.model = model
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell", for: indexPath) as? HourlyWeatherCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            if self.model != nil {
                cell.configureCell(model: model!)
            } else {
                tableView.reloadData()
            }
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath) as? DailyWeatherCell else { return UITableViewCell() }
            
            if self.model != nil {
                cell.configureCell(model: model!)
                cell.backgroundColor = .clear
            } else {
                tableView.reloadData()
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 110
        case 1:
            return 263
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        label.layer.cornerRadius = 20
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .natural
        label.textColor = .darkGray
        label.layer.backgroundColor = UIColor.cellColor.cgColor
        
        switch section {
        case 0:
            label.text = "   ⏳ ПОЧАСОВОЙ ПРОГНОЗ"
        case 1:
            label.text = "   📆 ПРОГНОЗ НА 6 ДНЕЙ"
        default:
            label.text = "Нет связи"
        }
        return label
    }

}
