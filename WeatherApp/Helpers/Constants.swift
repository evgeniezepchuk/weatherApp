//
//  Constants.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 16.12.23.
//

import UIKit

struct Constants {
    static let baseURL = "https://api.openweathermap.org"
    static let API_Key = "9ff34c75f6de30dd2230d1f5c2f98650"
    static let geoCoderBaseURL = "http://api.openweathermap.org"
    static let units = "metric".localized()
    static let language = "ru".localized()
    static let hourlyForecast = "Почасовой прогноз".localized()
    static let dailyForecast = "Прогноз на неделю".localized()
    static let dateFormat = "ru_RU".localized()
    static let degrees = "C".localized()
}
