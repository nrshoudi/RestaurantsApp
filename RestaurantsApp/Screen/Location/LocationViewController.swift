//
//  LocationViewController.swift
//  ResturantReservation
//
//  Created by Noura Aziz on 2/9/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

protocol LocationActions: class {
    func didTapAllow()
}
class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView!
    weak var delegate: LocationActions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [weak self] solution is used to avoid capturing an object strongly
        locationView.didTapAllow = {
            self.delegate?.didTapAllow()
        }
  
    }
    
    
    
}
