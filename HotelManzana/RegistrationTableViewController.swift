//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/8/23.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    var registrations = [Registration]()
 
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {

        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
        let registration = addRegistrationTableViewController.registration else { return }

        registrations.append(registration)
        tableView.reloadData()
    }
    
    
    @IBSegueAction func showRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        let addRegistrationTableViewController = AddRegistrationTableViewController(coder: coder)
        
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            return addRegistrationTableViewController
        }
        
        let registration = registrations[indexPath.row]
        addRegistrationTableViewController?.existingRegistration = registration
        
        return addRegistrationTableViewController
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName + " " + registration.lastName
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted)
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
