//
//  BasketModel.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

enum BasketModel {
    
    enum FetchCurrencyRates {
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
    
    enum Checkout {
        struct Request {
            var bagsOfPeasInBasket: Int = 0
            var dozensOfEggsInBasket: Int = 0
            var bottlesOfMilkInBasket: Int = 0
            var cansOfBeansInBasket: Int = 0
        }
        
        struct Response {
            var total: Double = 0.0
        }
        
        struct ViewModel {
            var total: Double = 0.0
        }
    }
}
