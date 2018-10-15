//
//  BasketConfigurator.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

extension BasketViewController: BasketPresenterOut {
}

extension BasketInteractor: BasketViewControllerOut {
}

extension BasketPresenter: BasketInteractorOut {
}

class BasketConfigurator {
    
    // MARK: - Methods
    func configure(viewController: BasketViewController) {
        let presenter = BasketPresenter()
        presenter.viewController = viewController
        
        let interactor = BasketInteractor()
        interactor.presenter = presenter
        
        viewController.interactor = interactor
    }
}
