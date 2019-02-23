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
    var navigationController: UINavigationController?
    
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
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        default:
            //assertionFailure()
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantsNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationService.getLocation()
            (nav?.topViewController as? RestaurantTableViewController)?.delegate = self

        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func loadDetails(for viewController: UIViewController, id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? DetailsFoodViewController)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Failed to get the details: \(error)")
            }
        }
    }
    
    private func loadBusiness(with coordinates: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinates.latitude, long: coordinates.longitude)) { [weak self] (result) in
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
                else if let nav = strongSelf.storyboard.instantiateViewController(withIdentifier: "RestaurantsNavigationController") as? UINavigationController {
                strongSelf.navigationController = nav
                    strongSelf.window.rootViewController?.present(nav, animated: true) {
                        (nav.topViewController as? RestaurantTableViewController)?.delegate = self
                        (nav.topViewController as? RestaurantTableViewController)?.viewModels = viewModels ?? []
                    }
                
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
    
}

extension AppDelegate: LocationActions, ListActions {
    func didTapAllow() {
         locationService.requestLocationAuthorization()
    }
    
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        loadDetails(for: viewController, id: viewModel.id)
    }
}
