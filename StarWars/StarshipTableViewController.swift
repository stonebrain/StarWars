//
//  StarshipTableViewController.swift
//  StarWars
//
//  Created by Michael Meyer on 11/12/18.
//  Copyright © 2018 Michael Meyer. All rights reserved.
//

import UIKit

class StarshipTableViewController: UITableViewController {
    
    
    // For doing tasks before the view loads
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Check to see if there is already data in core data for this entity
        if Starship.getAllStarships().count > 0 {
            return
        }
        
        // Invoke our API Service
        let service = APIService()
        service.query = "starships"
        
        
        service.getDataWith(completion: {
            
            (Result) in
            
            //Check to see if we get data; if so, save it to core data
            switch (Result) {
                
            case.Success(let rawJSONAPIdata):
                Starship.saveInCoreDataWith(array: rawJSONAPIdata)
            case.Error(let message):
                print(message)
                // PRINT ALL OF THE API JSON TO THE CONSOLE
                //(result) in print(result)} )
                
            }
            // CANNOT PUT THE getAllStarshipsMETHOD HERE.
            
            // SET OURSELF UP AS AN OBSERVER
            
            let nc = NotificationCenter.default
            nc.addObserver(forName: NSNotification.Name(rawValue: "dataUpdated"), object: nil, queue: nil) {
                notification in
                //THIS IS WHAT WE WANT TO DO WHEN WE RECIEVE THIS NOTIFICATION
                self.tableView.reloadData()
                
            }
            
            // Print the path to the DB
            CoreDataStack.sharedInstance.applicationDocumentsDirectory()
            
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Starship.getAllStarships().count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // CREATE INSTANCE OF UITableViewCell
        
        let StarshipCell = tableView.dequeueReusableCell(withIdentifier: "starshipTableCell", for: indexPath)
        
        
        // Figure out which Starship object should appear
        
        let thisStarship = Starship.getAllStarships()[indexPath.row] as! Starship
        
        // Format the cell with information from the Starship object
        StarshipCell.textLabel?.text = thisStarship.name
        
        // Return the formatted cell
        return StarshipCell
        
        
    }
    
    
}
