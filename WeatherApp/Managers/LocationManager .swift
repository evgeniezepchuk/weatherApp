//
//  Locator .swift
//  WeatherApp
//
//  Created by Евгений Езепчук on 12.12.23.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    //
    
    private let manager = CLLocationManager()
    
    private var locationFetchCompletion: ((CLLocation) -> Void)?
    
    private var location: CLLocation? {
        didSet {
            guard let location else {
                return
            }
            locationFetchCompletion?(location)
        }
    }
    
    public func getCurrentLocation(completion: @escaping ((CLLocation)) -> Void) {
//        guard self.coordinate != (0,0) else { return }
        self.locationFetchCompletion = completion
//        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    
    
    
    //
    
    let locationManager = CLLocationManager()
//    
//    var coordinate: (Double,Double) = (0,0)
//
    static let shared = LocationManager()
//    
    private override init() {}
//    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global(qos: .background).async {
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
        guard let lastLocation = locations.last else { return }
        self.location = lastLocation
    }
}
    

    
    

