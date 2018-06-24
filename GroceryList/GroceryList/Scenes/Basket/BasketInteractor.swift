//
//  BasketInteractor.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

protocol BasketInteractorIn {
    func checkout(request: BasketModel.Checkout.Request)
}

protocol BasketInteractorOut {
    func presentTotal(response: BasketModel.Checkout.Response)
}

class BasketInteractor {
    
    // MARK: - Properties
    var presenter: BasketInteractorOut?
}

// MARK: - BasketInteractorIn
extension BasketInteractor: BasketInteractorIn {
    func checkout(request: BasketModel.Checkout.Request) {
        
    }
}
