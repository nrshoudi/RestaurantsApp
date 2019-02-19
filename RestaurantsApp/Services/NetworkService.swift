//
//  NetworkService.swift
//  RestaurantsApp
//
//  Created by Noura Aziz on 2/19/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import Foundation
import Moya

private let apiKey = "Xzo0w-wHDJpgnEEgQCj-b5NBjrJFJ9IPOJ4PYCM0K-xhPzVum_cQk2V3NtvzM5TrKuIhI_PGriRx77ib7pa7juLHM3xJnEVZA7feUJ3SQer1iEvtppsOaSJfIqVrXHYx"
enum YelpService {
    enum BusinessesProvider: TargetType {
        case search(lat: Double, long: Double)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(parameters: ["latitude" : lat, "longitude": long, "limit": 1], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
        
        
        
    
    }
}
