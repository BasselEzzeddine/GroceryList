//
//  BasketPresenter.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol BasketPresenterIn {
    func presentTotal(response: BasketModel.Checkout.Response)
    func enableCurrencies()
    func presentCurrenciesUpdateMessage()
    func presentCurrenciesErrorMessage()
}

protocol BasketPresenterOut: class {
    func displayTotal(viewModel: BasketModel.Checkout.ViewModel)
    func enableCurrencySegmentedControl()
    func updateInfoMessage(viewModel: BasketModel.FetchCurrencyRates.ViewModel)
}

class BasketPresenter {
    
    // MARK: - Properties
    weak var viewController: BasketPresenterOut?
    let timestamp = Timestamp()
}

// MARK: - BasketPresenterIn
extension BasketPresenter: BasketPresenterIn {
    func presentTotal(response: BasketModel.Checkout.Response) {
        let viewModel = BasketModel.Checkout.ViewModel(total: response.total)
        viewController?.displayTotal(viewModel: viewModel)
    }
    
    func enableCurrencies() {
        viewController?.enableCurrencySegmentedControl()
    }
    
    func presentCurrenciesUpdateMessage() {
        let message = "Currency rates last updated \(timestamp.now())"
        let viewModel = BasketModel.FetchCurrencyRates.ViewModel(message: message)
        viewController?.updateInfoMessage(viewModel: viewModel)
    }
    
    func presentCurrenciesErrorMessage() {
        let message = "Currency rates are unavailable for the moment"
        let viewModel = BasketModel.FetchCurrencyRates.ViewModel(message: message)
        viewController?.updateInfoMessage(viewModel: viewModel)
    }
}
