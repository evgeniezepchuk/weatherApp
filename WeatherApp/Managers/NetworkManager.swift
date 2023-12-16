//
//  APIManager.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 7.12.23.
//

import UIKit

final class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    public func getWeather(latitide: Double, longitutde: Double, complition: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let url = "\(Constants.baseURL)/data/3.0/onecall?lat=\(latitide.description)&lon=\(longitutde.description)&units=\(Constants.units)&lang=\(Constants.language)&exclude=current,minutely,alerts&appid=\(Constants.API_Key)"
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
    
    public func getCityWeather(cityName: String, complition: @escaping (Result<[Cities], Error>) -> Void) {
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
    
    public func getNameOfCity(latitude: Double, longitude: Double, complition: @escaping (Result<[Cities], Error>) -> Void) {
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
            }
        } .resume()
    }
}
