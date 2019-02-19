//
//  ResturantTableViewController.swift
//  ResturantReservation
//
//  Created by Noura Aziz on 2/9/19.
//  Copyright © 2019 Noura Aziz. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var viewModels = [RestaurantListViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
    
        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)
     
     // Configure the cell...
     
     return cell
     }
     
    
}
