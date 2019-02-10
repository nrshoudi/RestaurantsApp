//
//  BaseView.swift
//  ResturantReservation
//
//  Created by Noura Aziz on 2/5/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

@IBDesignable class BaseView: UIView {
    
    
    // MARK: Initilizer when initilize with a frame.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    // MARK: Initilizer when initilize with a storyboard.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        
    }
}
