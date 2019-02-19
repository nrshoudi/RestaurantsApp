//
//  AppDelegate.swift
//  RestaurantsApp
//
//  Created by Noura Aziz on 2/4/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessesProvider>()
    let jsonDecoder = JSONDecoder()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
            // Set JSON property
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadBusiness(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
     
        
        switch locationService.status {
        case .notDetermined, .restricted, .denied:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.delegate
            window.rootViewController = locationViewController
        default:
            //assertionFailure()
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantsNavigationController") as? UINavigationController
            window.rootViewController = nav
            locationService.getLocation()
//            loadBusiness()
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func loadBusiness(with coordinates: CLLocationCoordinate2D) {
        service.request(.search(lat: 42.361145, long: -71.057083)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: {$0.distance < $1.distance})
                if let nav = strongSelf.window.rootViewController as? UINavigationController,
                    let restaurantListViewController = nav.topViewController as? RestaurantTableViewController {
                    restaurantListViewController.viewModels = viewModels ?? []
                }
              
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
    
}

extension AppDelegate: LocationActions {
    func didTapAllow() {
         locationService.requestLocationAuthorization()
    }
}
