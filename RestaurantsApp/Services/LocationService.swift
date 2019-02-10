//
//  LocationService.swift
//  RestaurantsApp
//
//  Created by Noura Aziz on 2/9/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import Foundation
import CoreLocation


/* Object hase two cases, if it successful (success) it take its associated type, and if it fails(failure), it takes another associated type for the error.
 It's a good practice if you have two cases
 */
enum Result<T> {
    case success(T)
    case failure(Error)
}

final class LocationService: NSObject {
    private let manager: CLLocationManager
    
    init(manager: CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    // Clousres
    var newLocation: ((Result<CLLocation>) -> Void)? // responce for holding location coordinates
    var didChangeStatus: ((Bool) -> Void)?
    
    // Returns what is the location status of the user.
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocationAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        newLocation?(.failure(error)) // return the location with the error
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Return the newest location sorted by time
        if let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first {
            newLocation?(.success(location)) // return the location with success case
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            didChangeStatus?(false)
        default:
            didChangeStatus?(true)
        }
    }
    
    
}

