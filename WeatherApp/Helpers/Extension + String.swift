//
//  Extension + String.swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 15.12.23.
//

import Foundation


extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
