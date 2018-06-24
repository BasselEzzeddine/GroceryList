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
}

class BasketInteractor {
    
    // MARK: - Properties
    var presenter: BasketInteractorOut?
    var worker = CurrencyWorker()
    private let calculator = Calculator()
    private let bag = DisposeBag()
    
    // MARK: - Methods
    func handleFetchSuccess(_ rawCurrencyRates: RawCurrencyRates) {
        presenter?.enableCurrencies()
        presenter?.presentCurrenciesUpdateMessage()
    }
    
    func handleFetchFailure(_ serviceErrorType: ServiceErrorType) {
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
        let total = calculator.calculateTotalAmountOfBasket(bagsOfPeas: request.bagsOfPeasInBasket, dozensOfEggs: request.dozensOfEggsInBasket, bottlesOfMilk: request.bottlesOfMilkInBasket, cansOfBeans: request.cansOfBeansInBasket)
        let response = BasketModel.Checkout.Response(total: total)
        presenter?.presentTotal(response: response)
    }
}
