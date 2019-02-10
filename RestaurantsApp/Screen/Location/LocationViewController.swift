//
//  LocationViewController.swift
//  ResturantReservation
//
//  Created by Noura Aziz on 2/9/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [weak self] solution is used to avoid capturing an object strongly
        locationView.didTapAllow = { [weak self] in
            self?.locationService?.requestLocationAuthorization()
        }
        
        locationService?.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService?.getLocation()
            }
        }
        
        locationService?.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                print(location)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
    }
    
    
    
}
