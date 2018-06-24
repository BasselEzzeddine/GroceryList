//
//  MockData.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
@testable import GroceryList

class MockData {
    
    // MARK: - Methods
    func getRawCurrencyRatesMock() -> RawCurrencyRates {
        let quotes = RawCurrencyRates.Quotes(eur: 1.5, gbp: 2.0)
        let rawCurrencyRates = RawCurrencyRates(success: true, terms: "terms", privacy: "privacy", timestamp: 123, source: "USD", quotes: quotes)
        return rawCurrencyRates
    }
}
