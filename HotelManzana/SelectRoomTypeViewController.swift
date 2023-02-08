//
//  SelectRoomTypeViewController.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/8/23.
//

import UIKit

protocol SelectRoomTypeViewControllerDelegate: AnyObject {
    func selectRoomTypeViewController(_ controller: SelectRoomTypeViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SelectRoomTypeViewControllerDelegate?
    
    var roomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}

extension SelectRoomTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomTypeCell", for: indexPath)
        
        let roomType = RoomType.all[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "$ \(roomType.price)"
        cell.contentConfiguration = content
        
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension SelectRoomTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomType = RoomType.all[indexPath.row]
        self.roomType = roomType
        delegate?.selectRoomTypeViewController(self, didSelect: roomType)
        tableView.reloadData()
    }
    
}
