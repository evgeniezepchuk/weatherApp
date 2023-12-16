//
//  Timer.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 11.12.23.
//

import UIKit

enum DayOrHour {
    case day
    case hour
}

final class Timer {
    
    static let shared = Timer()
    
    private init() {}
    
    public func unixTimeConvertion(unixTime: Double, dayOrHour: DayOrHour) -> String {
        switch dayOrHour {
        case .day:
            
            let time = NSDate(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Constants.dateFormat)
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.dateFormat = "EEEE"
            let dateAsString = dateFormatter.string(from: time as Date)
            dateFormatter.dateFormat = "EEEE"
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "EEEE"
            let date24 = dateFormatter.string(from: date!)
            return date24
            
        case .hour:
            
            let time = NSDate(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale
            dateFormatter.dateFormat = "hh:mm a"
            let dateAsString = dateFormatter.string(from: time as Date)
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "HH"
            let date24 = dateFormatter.string(from: date!)
            return date24
        }
    }
    
    public func saveDate() {
        let dateNow = Date.now
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        let hours = dateFormater.string(from: dateNow)
        dateFormater.dateFormat = "mm"
        let minutes = dateFormater.string(from: dateNow)
        dateFormater.dateFormat = "ss"
        let seconds = dateFormater.string(from: dateNow)
        
        let time = Time(seconds: seconds, minutes: minutes, hours: hours)
        
        do {
            let data = try JSONEncoder().encode(time)
            UserDefaults.standard.setValue(data, forKey: "date")
        } catch {
            print("error with encodable and save date")
        }
    }
    
    public func timeInterval() -> String {
        
        let dateNow = Date.now
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH"
        let hoursNow = Int(dateFormater.string(from: dateNow)) ?? 0
        dateFormater.dateFormat = "mm"
        let minutesNow = Int(dateFormater.string(from: dateNow)) ?? 0
        dateFormater.dateFormat = "ss"
        let secondsNow = Int(dateFormater.string(from: dateNow)) ?? 0
        
        var time: Time?
        
        var label = ""
        if let savedData = UserDefaults.standard.object(forKey: "date") as? Data {
            let decoder = JSONDecoder()
            if let savedTime = try? decoder.decode(Time.self, from: savedData) {
                time = savedTime
            }
        }
        
        guard let time = time else { return "" }
        
        let hours = Int(time.hours) ?? 0
        let minutes = Int(time.minutes) ?? 0
        let seconds = Int(time.seconds) ?? 0
        
        let resultHours = hoursNow - hours
        let resultMinutes = minutesNow - minutes
        let resultSeconds = secondsNow - seconds
        
        if resultHours == 0 && resultMinutes == 0 {
            if resultSeconds < 0 {
                let newResult = 60 - seconds + secondsNow
                label = "последнее обновление было \(newResult) секунд назад"
            } else {
                label = "последнее обновление было \(resultSeconds) секунд назад"
            }
        }  else if resultHours == 0 {
            if resultMinutes < 0 {
                let newResult = 60 - minutes + minutesNow
                label = "последнее обновление было \(newResult) минут назад"
            } else {
                label = "последнее обновление было \(resultMinutes) минут назад"
            }
        } else {
            label = "последнее обновление было \(resultHours) часов назад"
        }
        
        return label
        
    }
}
