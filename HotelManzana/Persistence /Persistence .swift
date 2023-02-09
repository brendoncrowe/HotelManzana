//
//  Persistence .swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/9/23.
//

import Foundation

enum DataPersistenceError: Error {
case savingError(Error)
case fileDoesNotExist(String)
case noData
case encodingError(Error)
case decodingError(Error)
case deletingError(Error)
}

class PersistenceHelper {
    
    private static var registrations = [Registration]()
    private static var filename = "registrations.plist"
    
    private static func save() throws { // helper function used in the CRUD functions
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        do {
            let data = try PropertyListEncoder().encode(registrations)
            try data.write(to: url)
        } catch {
            throw DataPersistenceError.encodingError(error)
        }
    }
    
    static func create(registration: Registration) throws {
        registrations.append(registration)
        do {
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    static func delete(registrationAt index: Int) throws {
        registrations.remove(at: index)
        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
    
    static func loadRegistrations() throws -> [Registration] {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        if FileManager.default.fileExists(atPath: url.path()) {
            if let data = FileManager.default.contents(atPath: url.path()) {
                do {
                    registrations = try PropertyListDecoder().decode([Registration].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        } else {
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        return registrations
    }
}
