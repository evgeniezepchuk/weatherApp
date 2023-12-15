//
//  ViewController.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 7.12.23.
//

import UIKit

class ViewController: UIViewController {
    
    var model: WeatherModel?
    var coord: (Double, Double) = (0,0)
    var headerView: HeaderView?
    var city: String?
    var isOn = true
    let value: String = "C".localized()
    
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
        if isOn {
            connectionLocating()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        configureTableView()
        configureNavBar()
        configureHeaderView()
        view.backgroundColor = .bckrgndColor
    }
    
    private func configureHeaderView() {
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: view.bounds.height / 3.5))
        self.tableView.tableHeaderView = headerView
    }
    
    private func configureNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearchController))
        navigationController?.navigationBar.barTintColor = .bckrgndColor
//        navigationController?.navigationBar.isTranslucent = true
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

    public func reconfigureView(city: String, model: WeatherModel, isOn: Bool) {
            self.isOn = isOn
            self.city = city
            self.model = model
           
        DispatchQueue.main.async {
            self.headerView?.configureHeaderView(imageID: model.hourly?[0].weather?[0].icon! ?? "icon", city: city , temperature: String(Int(model.hourly?[0].temp ?? 0)) + "°" + self.value)
            self.tableView.reloadData()
        }
    }
    
    private func loadModel() {
        LocationManager.shared.getCurrentLocation { location in
            APIManager.shared.getNameOfCity(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                switch result {
                case .success(let city):
                    DispatchQueue.main.async {
                        self.city = city[0].local_names?.ru ?? ""  
                    }
                case .failure(let error):
                    print(error)
                }
            }
            APIManager.shared.getWeather(latitide: location.coordinate.latitude, longitutde: location.coordinate.longitude) { result in
                switch result {
                case .success(let model):
                    print(model.timezone)
                    self.model = model
                    DispatchQueue.main.async {
                        self.headerView?.configureHeaderView(imageID: self.model?.hourly?[0].weather?[0].icon! ?? "icon", city: self.city ?? "", temperature: String(Int(self.model?.hourly?[0].temp ?? 0)) + "°" + self.value)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func connectionLocating() {
        if ConnectionManager.shared.isConnected {
            loadModel()
        } else {
            do {
                let data = UserDefaults.standard.object(forKey: "data") as! Data
                let cityData = UserDefaults.standard.object(forKey: "city") as! Data
                let model = try JSONDecoder().decode(WeatherModel.self, from: data)
                self.model = model
                let city = try JSONDecoder().decode([Cities].self, from: cityData)
                self.city = city[0].local_names?.ru ?? ""
                DispatchQueue.main.async {
                    self.headerView?.configureHeaderView(imageID: self.model?.hourly?[0].weather?[0].icon! ?? "icon", city: self.city ?? "", temperature: String(Int(self.model?.hourly?[0].temp ?? 0)))
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc func openSearchController() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            label.text = "   ⏳ Почасовой прогноз"
        case 1:
            label.text = "   📆 Прогноз на 6 дней"
        default:
            label.text = "Нет связи"
        }
        return label
    }
    
}
