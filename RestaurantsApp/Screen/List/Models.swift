//
//  Models.swift
//  RestaurantsApp
//
//  Created by Noura Aziz on 2/19/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import Foundation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let name: String
    let imageUrl: URL
    let distance: Double
    let id: String
    
    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }
    
    var formatterDistance: String? {
        return RestaurantListViewModel.numberFormatter.string(from: distance as NSNumber)
    }
}





extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.imageUrl = business.imageUrl
        self.id = business.id
        self.distance = business.distance / 1709.344 // Convert distance from meters to miles
    }
}
