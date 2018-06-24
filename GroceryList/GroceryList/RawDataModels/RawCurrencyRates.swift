//
//  RawCurrencyRates.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

struct RawCurrencyRates: Decodable {
    var success: Bool
    var terms: String
    var privacy: String
    var timestamp: Int
    var source: String
    var quotes: Quotes?
    
    struct Quotes: Decodable, Equatable {
        var eur: Double
        var gbp: Double
        
        enum CodingKeys: String, CodingKey {
            case eur = "USDEUR"
            case gbp = "USDGBP"
        }
    }
}