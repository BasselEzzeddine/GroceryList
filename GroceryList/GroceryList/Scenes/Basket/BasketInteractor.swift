//
//  BasketInteractor.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation
import RxSwift

protocol BasketInteractorIn {
    func fetchCurrencyRates()
    func checkout(request: BasketModel.Checkout.Request)
}

protocol BasketInteractorOut {
    func presentTotal(response: BasketModel.Checkout.Response)
    func enableCurrencies()
    func presentCurrenciesUpdateMessage()
    func presentCurrenciesErrorMessage()
}

class BasketInteractor {
    
    // MARK: - Properties
    var presenter: BasketInteractorOut?
    var worker = CurrencyWorker()
    private let calculator = Calculator()
    private let bag = DisposeBag()
    
    let priceOfBagOfPeasInUsd: Double = 0.95
    let priceOfDozenOfEggsInUsd: Double = 2.10
    let priceOfBottleOfMilkInUsd: Double = 1.30
    let priceOfCanOfBeansInUsd: Double = 0.73
    
    var usdToEur: Double = 0.0
    var usdToGbp: Double = 0.0
    
    // MARK: - Methods
    func handleFetchSuccess(_ rawCurrencyRates: RawCurrencyRates) {
        presenter?.enableCurrencies()
        presenter?.presentCurrenciesUpdateMessage()
        
        guard let quotes = rawCurrencyRates.quotes else {
            return
        }
        usdToEur = quotes.usdToEur
        usdToGbp = quotes.usdToGbp
    }
    
    func handleFetchFailure(_ serviceErrorType: ServiceErrorType) {
        presenter?.presentCurrenciesErrorMessage()
    }
}

// MARK: - BasketInteractorIn
extension BasketInteractor: BasketInteractorIn {
    func fetchCurrencyRates() {
        worker.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp])
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    switch result {
                    case .Success(let rawCurrencyRates):
                        self.handleFetchSuccess(rawCurrencyRates)
                    case .Failure(let serviceErrorType):
                        self.handleFetchFailure(serviceErrorType)
                    }
            },
                onError: { error in
                    self.handleFetchFailure(.invalidResponse)
            }).disposed(by:bag)
    }
    
    func checkout(request: BasketModel.Checkout.Request) {
        let total = calculator.calculateTotalPriceOfBasket(bagsOfPeas: request.bagsOfPeasInBasket, dozensOfEggs: request.dozensOfEggsInBasket, bottlesOfMilk: request.bottlesOfMilkInBasket, cansOfBeans: request.cansOfBeansInBasket, priceOfBagOfPeasInUsd: priceOfBagOfPeasInUsd, priceOfDozenOfEggsInUsd: priceOfDozenOfEggsInUsd, priceOfBottleOfMilkInUsd: priceOfBottleOfMilkInUsd, priceOfCanOfBeansInUsd: priceOfCanOfBeansInUsd, conversionRateFromUsd: 1)
        let response = BasketModel.Checkout.Response(total: total)
        presenter?.presentTotal(response: response)
    }
}
