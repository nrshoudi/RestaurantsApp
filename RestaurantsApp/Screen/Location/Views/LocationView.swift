//
//  LocationView.swift
//  ResturantReservation
//
//  Created by Noura Aziz on 2/9/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

@IBDesignable class LocationView: BaseView {
    
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    var didTapAllow: (() -> Void)?
    
    @IBAction func allowAction(_ sender: UIButton) {
        didTapAllow?()
    }
    
    @IBAction func denyAction(_ sender: UIButton) {
        
    }
    
}
