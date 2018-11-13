//
//  RawCurrencyRates.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

struct RawCurrencyRates: Decodable, Equatable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Int
    let source: String
    let quotes: Quotes?
    
    struct Quotes: Decodable, Equatable {
        let usdToEur: Double
        let usdToGbp: Double
        
        enum CodingKeys: String, CodingKey {
            case usdToEur = "USDEUR"
            case usdToGbp = "USDGBP"
        }
    }
}
