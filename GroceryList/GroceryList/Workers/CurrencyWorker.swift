//
//  CurrencyWorker.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyWorker {
    
    // MARK: - Properties
    var currencyEndpoint = Configuration.init().currencyEndpoint()
    let currencyEndpointKey = Configuration.init().currencyEndpointKey()
    
    enum Currency: String {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
    }
    
    // MARK: - Methods
    func fetchRawCurrencyRates(fromCurrency: Currency, toCurrencies: [Currency]) -> Observable<WorkerHelper.Result<RawCurrencyRates>> {
        guard var urlComponents = URLComponents(string: "\(currencyEndpoint)/api/live") else {
            return Observable.just(WorkerHelper.Result.failure(.invalidUrl))
        }
        
        let source = fromCurrency.rawValue
        let currencies = toCurrencies.map { $0.rawValue }.joined(separator: ",")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: currencyEndpointKey),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "currencies", value: currencies),
            URLQueryItem(name: "format", value: String(1))
        ]
        
        guard let url = urlComponents.url, UIApplication.shared.canOpenURL(url) else {
            return Observable.just(WorkerHelper.Result.failure(.invalidUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession.shared
        return session.rx.response(request: urlRequest).map { response, data in
            do {
                let decoder = JSONDecoder()
                let rawCurrencyRates = try decoder.decode(RawCurrencyRates.self, from: data)
                return WorkerHelper.Result.success(rawCurrencyRates)
            }
            catch {
                return WorkerHelper.Result.failure(.invalidResponse)
            }
        }
    }
}
