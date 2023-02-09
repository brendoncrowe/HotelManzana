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
}
