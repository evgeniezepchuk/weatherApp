//
//  Model.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 7.12.23.
//

import Foundation


struct WeatherModel: Codable {
    let hourly: [Hourly]?
    let daily: [Daily]?
    let lat: Double
    let lon: Double
    let timezone: String
}

struct Hourly: Codable {
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

struct Daily: Codable {
    let dt: Int?
    let temp: Temp?
    let weather: [Weather]?
}

struct Temp: Codable {
    let day: Double?
    let min: Double?
    
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}


struct CitiesList: Codable {
    let cities: [Cities]
}

struct Cities: Codable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let local_names: LocalNames?
    let country: String?
}

struct LocalNames: Codable {
    let ru: String?
}
