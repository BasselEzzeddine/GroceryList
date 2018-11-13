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
    var worker: CurrencyWorker?
    var calculator: Calculator?
    private let disposeBag = DisposeBag()
    
    private let priceOfBagOfPeasInUsd: Double = 0.95
    private let priceOfDozenOfEggsInUsd: Double = 2.10
    private let priceOfBottleOfMilkInUsd: Double = 1.30
    private let priceOfCanOfBeansInUsd: Double = 0.73
    
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
    
    func handleFetchFailure(_ errorType: WorkerHelper.ErrorType) {
        presenter?.presentCurrenciesErrorMessage()
    }
}

// MARK: - BasketInteractorIn
extension BasketInteractor: BasketInteractorIn {
    func fetchCurrencyRates() {
        worker?.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp])
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { result in
                    switch result {
                    case .success(let rawCurrencyRates):
                        self.handleFetchSuccess(rawCurrencyRates)
                    case .failure(let errorType):
                        self.handleFetchFailure(errorType)
                    }
            },
                onError: { error in
                    self.handleFetchFailure(.invalidResponse)
            }).disposed(by: disposeBag)
    }
    
    func checkout(request: BasketModel.Checkout.Request) {
        var conversionRateFromUsd: Double = 0.0
        
        switch request.selectedCurrency {
        case .usd:
            conversionRateFromUsd = 1.0
        case .eur:
            conversionRateFromUsd = usdToEur
        case .gbp:
            conversionRateFromUsd = usdToGbp
        }
        
        guard let total = calculator?.calculateTotalPriceOfBasket(bagsOfPeas: request.bagsOfPeasInBasket, dozensOfEggs: request.dozensOfEggsInBasket, bottlesOfMilk: request.bottlesOfMilkInBasket, cansOfBeans: request.cansOfBeansInBasket, priceOfBagOfPeasInUsd: priceOfBagOfPeasInUsd, priceOfDozenOfEggsInUsd: priceOfDozenOfEggsInUsd, priceOfBottleOfMilkInUsd: priceOfBottleOfMilkInUsd, priceOfCanOfBeansInUsd: priceOfCanOfBeansInUsd, conversionRateFromUsd: conversionRateFromUsd) else { return }
        let response = BasketModel.Checkout.Response(total: total)
        presenter?.presentTotal(response: response)
    }
}
