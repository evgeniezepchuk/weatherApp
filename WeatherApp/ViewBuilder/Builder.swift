//
//  ModelView.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 9.12.23.
//

import UIKit

final class Builder {
    
    func viewBuilder(frame: CGRect, imageID: String, dayOrHour: String, temperature: String, stackAxis: NSLayoutConstraint.Axis) -> UIView {
        
        let stack = UIStackView(frame: frame)
        stack.axis = stackAxis
        stack.backgroundColor = .clear
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true

        let temp = UILabel()
        temp.text = temperature
        temp.textAlignment = .center
        temp.textColor = .black
        temp.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        let weatherImage = UIImageView()
        weatherImage.image = UIImage(named: imageID)
        weatherImage.contentMode = .scaleAspectFit
  
        let days = UILabel()
        days.textAlignment = .left
        days.text = dayOrHour
        days.textColor = .black
        days.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
  
        [days, weatherImage, temp].forEach { view in
            stack.addArrangedSubview(view)
        }

        return stack
    }
}
