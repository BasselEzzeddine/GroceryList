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
}

protocol BasketPresenterOut: class {
    func displayTotal(viewModel: BasketModel.Checkout.ViewModel)
}

class BasketPresenter {
    
    // MARK: - Properties
    weak var viewController: BasketPresenterOut?
}

// MARK: - BasketPresenterIn
extension BasketPresenter: BasketPresenterIn {
    func presentTotal(response: BasketModel.Checkout.Response) {
        let viewModel = BasketModel.Checkout.ViewModel(total: response.total)
        viewController?.displayTotal(viewModel: viewModel)
    }
    
    func enableCurrencies() {
    }
}
