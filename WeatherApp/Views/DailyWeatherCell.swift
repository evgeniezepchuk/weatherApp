//
//  DailyWeatherCell.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 8.12.23.
//

import UIKit

final class DailyWeatherCell: UITableViewCell {
    
    static let identifire = "DailyWeatherCell"
    private let builder: Builder?
    private var model: WeatherModel?
    
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DailyWeatherCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .cellColor
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 20 
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.builder = Builder()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCellConstraints()
    }
    
    private func configureCellConstraints() {
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(model: WeatherModel) {
        self.model = model
    }
}

extension DailyWeatherCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherCell", for: indexPath)
        guard let builder = builder, let model = model else { return UITableViewCell() }
        let temperature = Int(self.model?.daily?[indexPath.row].temp?.min ?? 0)
        let dayOfWeek = Double(self.model?.daily?[indexPath.row + 1].dt ?? 0)
        let imageID = (model.hourly?[indexPath.row].weather?[0].icon) ?? ""
        cell.backgroundView = builder.viewBuilder(frame: cell.bounds, imageID: imageID, dayOrHour: Timer.shared.unixTimeConvertion(unixTime: dayOfWeek, dayOrHour: .day), temperature: temperature.description, stackAxis: .horizontal)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    
}
