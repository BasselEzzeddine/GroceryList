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
            let message: String
        }
    }
    
    enum Checkout {
        struct Request {
            let bagsOfPeasInBasket: Int
            let dozensOfEggsInBasket: Int
            let bottlesOfMilkInBasket: Int
            let cansOfBeansInBasket: Int
            let selectedCurrency: Currency
            
            enum Currency: String {
                case usd
                case eur
                case gbp
            }
        }
        
        struct Response {
            let total: Double
        }
        
        struct ViewModel {
            let total: String
        }
    }
}
