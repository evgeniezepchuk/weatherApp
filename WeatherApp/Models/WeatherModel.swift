//
//  Model.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 7.12.23.
//

import Foundation

struct WeatherModel: Decodable {
    let hourly: [Hourly]?
    let daily: [Daily]?
    let lat: Double
    let lon: Double
    let timezone: String
}

struct Hourly: Decodable {
    let dt: Int?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let wind_speed: Double?
    let wind_deg: Int?
    let wind_gust: Double?
    let weather: [Weather]?
}

struct Daily: Decodable {
    let dt: Int?
    let temp: Temp?
    let weather: [Weather]?
}

struct Temp: Decodable {
    let day: Double?
    let min: Double?
    
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}


struct CitiesList: Decodable {
    let cities: [Cities]
}

struct Cities: Decodable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let local_names: LocalNames?
    let country: String?
    let state: String?
}

struct LocalNames: Decodable {
    let ru: String?
    let en: String?
}

struct Time: Codable {
    let seconds: String
    let minutes: String
    let hours: String
}
