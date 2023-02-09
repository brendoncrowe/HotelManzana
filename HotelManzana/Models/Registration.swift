//
//  Registration.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/8/23.
//

import Foundation

struct Registration: Codable {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
}
