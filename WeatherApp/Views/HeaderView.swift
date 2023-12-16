//
//  HeaderView.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 8.12.23.
//

import UIKit


final class HeaderView: UIView {
    
    private lazy var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var builder = Builder()
    
    private lazy var weatherValue: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        return label
    }()
    
    private lazy var cityName: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let image = UIImageView()
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
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.widthAnchor.constraint(equalToConstant: 150),
            verticalStack.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    public func configureHeaderView(imageID: String, city: String, temperature: String) {
        self.weatherImage.image = UIImage(named: imageID)
        self.cityName.text = city
        self.weatherValue.text = temperature
    }
}
