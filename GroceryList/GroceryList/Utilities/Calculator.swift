//
//  Calculator.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Properties
    let priceOfBagOfPeas: Float = 0.95
    let priceOfDozenOfEggs: Float = 2.10
    let priceOfBottleOfMilk: Float = 1.30
    let priceOfCanOfBeans: Float = 0.73
    
    // MARK: - Methods
    func calculateTotalAmountOfBasket(bagsOfPeas: Int, dozensOfEggs: Int, bottlesOfMilk: Int, cansOfBeans: Int) -> Float {
        var result: Float = 0.0
        result += Float(bagsOfPeas) * priceOfBagOfPeas
        result += Float(dozensOfEggs) * priceOfDozenOfEggs
        result += Float(bottlesOfMilk) * priceOfBottleOfMilk
        result += Float(cansOfBeans) * priceOfCanOfBeans
        return result
    }
}
