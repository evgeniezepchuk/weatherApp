//
//  Locator .swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 12.12.23.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    
    var coordinate: (Double,Double) = (0,0)
    
    static let shared = LocationManager()
    
    private override init() {}
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global(qos: .userInitiated).async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.startUpdatingLocation()
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.coordinate.0 = lastLocation.coordinate.latitude
            self.coordinate.1 = lastLocation.coordinate.longitude
//            print(coordinate)
            
        }
    }
    
}
    
    

