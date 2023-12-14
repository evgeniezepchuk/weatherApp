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

class Timer {
    
    static let shared = Timer()
    
    private init() {}
    
    func unixTimeConvertion(unixTime: Double, dayOrHour: DayOrHour) -> String {
        switch dayOrHour {
            
        case .day:
            
            let time = NSDate(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale
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
    
}
