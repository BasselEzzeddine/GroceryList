//
//  CurrencyWorker.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import RxSwift

class CurrencyWorker {
    
    // MARK: - Properties
    var service = CurrencyService()
    
    // MARK: - Methods
    func fetchRawCurrencyRates(fromCurrency: CurrencyService.Currency, toCurrencies: [CurrencyService.Currency]) -> Observable<ServiceResult<RawCurrencyRates>> {
        return service.fetchRawCurrencyRatesFromServer(fromCurrency: fromCurrency, toCurrencies: toCurrencies)
    }
}
