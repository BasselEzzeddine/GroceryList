//
//  CurrencyService.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyService {
    
    // MARK: - Properties
    var currencyEndpoint = Configuration.init().currencyEndpoint()
    let currencyEndpointKey = Configuration.init().currencyEndpointKey()
    
    // MARK: - Methods
    func fetchRawCurrencyRatesFromServer() -> Observable<ServiceResult<RawCurrencyRates>> {
        guard var urlComponents = URLComponents(string: "\(currencyEndpoint)/api/live") else {
            return Observable.just(ServiceResult.Failure(.invalidUrl))
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: currencyEndpointKey),
            URLQueryItem(name: "currencies", value: "EUR,GBP"),
            URLQueryItem(name: "format", value: String(1))
        ]
        
        guard let url = urlComponents.url, UIApplication.shared.canOpenURL(url) else {
            return Observable.just(ServiceResult.Failure(.invalidUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession.shared
        return session.rx.response(request: urlRequest).map { response, data in
            do {
                let decoder = JSONDecoder()
                let rawCurrencyRates = try decoder.decode(RawCurrencyRates.self, from: data)
                return ServiceResult.Success(rawCurrencyRates)
            }
            catch {
                return ServiceResult.Failure(.invalidResponse)
            }
        }
    }
}
