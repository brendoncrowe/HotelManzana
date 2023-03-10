//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/8/23.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    var registrations = [Registration]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            registrations = try PersistenceHelper.loadRegistrations()
        } catch {
            print("Error loading registrations: \(error)")
        }
    }
 
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {

        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
        let registration = addRegistrationTableViewController.registration else { return }

        // the below code checks if a registration object already exists in the selected row
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            registrations[selectedIndexPath.row] = registration
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else { // if the registration object does not exist, when passed from the AddRegistrationTableViewController, it is inserted into the table view at the row corresponding with the array index
            registrations.insert(registration, at: 0)
            let newIndexPath = IndexPath(row: 0, section: 0) // the "start line" of the table view indexPath
            tableView.insertRows(at: [newIndexPath], with: .none)
            do {
                try PersistenceHelper.create(registration: registration)
                print("registration saved!")
            } catch {
                print("Error saving registration: \(error)")
            }
        }
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
            do {
                try PersistenceHelper.delete(registrationAt: indexPath.row)
                print("registration deleted")
            } catch {
                print("Could not delete registration error: \(error)")
            }
        }
    }
}
