//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 8.12.23.
//

import UIKit


class HeaderView: UIView {
    
    var imageID: String = "icon"
    var city: String = "Минск"
    var temperature: String = "-7"
    
    private lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var builder = Builder()
    
    private lazy var weatherValue: UILabel = {
        let label = UILabel()
        label.text = "-7"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 60)
        return label
    }()
    
    private lazy var cityName: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true 
        label.text = "Минск"
        label.textColor = .black
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "icon")
        image.image?.withRenderingMode(.automatic)
        return image
    }()
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .equalSpacing
        verticalStack.alignment = .center
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        return verticalStack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        configureStackView()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    private func configureStackView() {
        let stackElements = [cityName, weatherImage, weatherValue]
        stackElements.forEach { element in
            verticalStack.addArrangedSubview(element)
        }
    }
    
    private func addConstraint() {
//        let views = builder.ViewBuilder(frame: .zero, imageID: imageID, dayOrHour: city, temperature: temperature, stackAxis: .vertical)
//        views.frame = view.bounds
//        views.backgroundColor = .red
//        views.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.widthAnchor.constraint(equalToConstant: 100),
            verticalStack.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configureHeaderView(imageID: String, city: String, temperature: String) {
//        DispatchQueue.main.async {
            self.weatherImage.image = UIImage(named: imageID)
            self.cityName.text = city
            self.weatherValue.text = temperature
//        }
    }
    
}
