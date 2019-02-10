//
//  AppDelegate.swift
//  RestaurantsApp
//
//  Created by Noura Aziz on 2/4/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        switch locationService.status {
        case .notDetermined, .restricted, .denied:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.locationService = locationService
            window.rootViewController = locationViewController
        default:
            assertionFailure()
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    
}
