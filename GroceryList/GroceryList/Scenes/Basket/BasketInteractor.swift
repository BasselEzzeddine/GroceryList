//
//  BasketInteractor.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol BasketInteractorIn {
    func fetchCurrencyRates()
    func checkout(request: BasketModel.Checkout.Request)
}

protocol BasketInteractorOut {
    func presentTotal(response: BasketModel.Checkout.Response)
}

class BasketInteractor {
    
    // MARK: - Properties
    var presenter: BasketInteractorOut?
    let calculator = Calculator()
}

// MARK: - BasketInteractorIn
extension BasketInteractor: BasketInteractorIn {
    func fetchCurrencyRates() {
        
    }
    
    func checkout(request: BasketModel.Checkout.Request) {
        let total = calculator.calculateTotalAmountOfBasket(bagsOfPeas: request.bagsOfPeasInBasket, dozensOfEggs: request.dozensOfEggsInBasket, bottlesOfMilk: request.bottlesOfMilkInBasket, cansOfBeans: request.cansOfBeansInBasket)
        let response = BasketModel.Checkout.Response(total: total)
        presenter?.presentTotal(response: response)
    }
}
