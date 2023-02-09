//
//  FileManagerExtension.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/9/23.
//

import Foundation


extension FileManager {
    
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: filename)
    }
}
