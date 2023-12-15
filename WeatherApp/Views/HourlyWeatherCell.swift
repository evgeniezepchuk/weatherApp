//
//  HourlyWeatherCell.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 8.12.23.
//

import UIKit


class HourlyWeatherCell: UITableViewCell {
    
    static let identifire = "HourlyWeatherCell"
    let builder: Builder?
    var model: WeatherModel?
  
    
    let collectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 6, height: 100)
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HourlyWeatherCell")
        cv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cv.layer.cornerRadius = 20
        cv.backgroundColor = .cellColor
        
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.builder = Builder()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configureCell(model: WeatherModel) {
        self.model = model
    }

}

extension HourlyWeatherCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath)
        guard let builder = builder, let model = model else { return UICollectionViewCell() }
        let temperature = Int(self.model?.hourly?[indexPath.row].temp ?? 0)
        let hour = Double(self.model?.hourly?[indexPath.row + 1].dt ?? 0)
        let imageID = (model.hourly?[indexPath.row].weather?[0].icon) ?? ""
        DispatchQueue.main.async {
            cell.backgroundView = builder.ViewBuilder(frame: cell.bounds, imageID: imageID, dayOrHour: Timer.shared.unixTimeConvertion(unixTime: hour, dayOrHour: .hour), temperature: temperature.description, stackAxis: .vertical)
        }
        return cell
    }
}
