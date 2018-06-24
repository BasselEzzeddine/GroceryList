//
//  Timestamp.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class Timestamp {
    
    // MARK: - Methods
    func now() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm on dd-MM-yyyy"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
