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
    // https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
    // https://openweathermap.org/data/3.0/onecall?lat=53.921428&lon=27.436436&lang=ru&exclude=current,minutely,daily,alerts&appid=9ff34c75f6de30dd2230d1f5c2f98650
//    https://api.openweathermap.org/data/3.0/onecall?lat=53.921428&lon=27.436436&appid=9ff34c75f6de30dd2230d1f5c2f98650
//    https://api.openweathermap.org/data/3.0/onecall?lat=53.921428&lon=27.436436&units=metric&lang=ru&exclude=current,minutely,daily,alerts&appid=9ff34c75f6de30dd2230d1f5c2f98650
}

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func getWeather(latitide: Double, longitutde: Double, complition: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let url = "\(Constants.baseURL)/data/3.0/onecall?lat=\(latitide.description)&lon=\(longitutde.description)&units=metric&lang=ru&exclude=current,minutely,alerts&appid=\(Constants.API_Key)"
        
        guard let URL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                UserDefaults.standard.setValue(data, forKey: "data")
//                                let weather = try JSONSerialization.jsonObject(with: data)
//                                print(weather)
                let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                print("------------>", weather.hourly![0].weather, weather.timezone)
                complition(.success(weather))
            } catch {
                complition(.failure(error))
//                print(error)
            }
        }
        .resume()
    }
    
    func getCityWeather(cityName: String, complition: @escaping (Result<[Cities], Error>) -> Void) {
        guard let cityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = "\(Constants.geoCoderBaseURL)/geo/1.0/direct?q=\(cityName)&limit=5&appid=\(Constants.API_Key)"
        
        //        \(Constants.geoCoderBaseURL)/geo/1.0/direct?q=\(cityName)&limit=5&appid=\(Constants.API_Key)
        guard let URL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                //                                let weather = try JSONSerialization.jsonObject(with: data)
                //                                print(weather)
                let weather = try JSONDecoder().decode([Cities].self, from: data)
                print("weath", weather)
                //                print("------------>", weather.hourly![0].weather, weather.timezone)
                complition(.success(weather))
            } catch {
                complition(.failure(error))
                print(error)
            }
        }
        .resume()
    }
    
}
