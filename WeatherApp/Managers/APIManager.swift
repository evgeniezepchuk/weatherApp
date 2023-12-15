//
//  APIManager.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 7.12.23.
//

import UIKit

struct Constants {
    static let baseURL = "https://api.openweathermap.org"
    static let API_Key = "9ff34c75f6de30dd2230d1f5c2f98650"
    static let geoCoderBaseURL = "http://api.openweathermap.org"
    static let units = "metric".localized()
}

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func getWeather(latitide: Double, longitutde: Double, complition: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let url = "\(Constants.baseURL)/data/3.0/onecall?lat=\(latitide.description)&lon=\(longitutde.description)&units=\(Constants.units)&lang=ru&exclude=current,minutely,alerts&appid=\(Constants.API_Key)"
        
        guard let URL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                UserDefaults.standard.setValue(data, forKey: "data")
                let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                complition(.success(weather))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getCityWeather(cityName: String, complition: @escaping (Result<[Cities], Error>) -> Void) {
        guard let cityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = "\(Constants.geoCoderBaseURL)/geo/1.0/direct?q=\(cityName)&limit=5&appid=\(Constants.API_Key)"

        guard let URL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let weather = try JSONDecoder().decode([Cities].self, from: data)
                complition(.success(weather))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getNameOfCity(latitude: Double, longitude: Double, complition: @escaping (Result<[Cities], Error>) -> Void) {
        let url = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude.description)&lon=\(longitude.description)&limit=5&appid=\(Constants.API_Key)"
        guard let URL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                UserDefaults.standard.setValue(data, forKey: "city")
                let city = try JSONDecoder().decode([Cities].self, from: data)
                complition(.success(city))
            } catch {
                complition(.failure(error))
                print(error)
            }
        } .resume()
    }
}
