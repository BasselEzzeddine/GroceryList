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
    let priceOfBagOfPeas: Double = 0.95
    let priceOfDozenOfEggs: Double = 2.10
    let priceOfBottleOfMilk: Double = 1.30
    let priceOfCanOfBeans: Double = 0.73
    
    // MARK: - Methods
    func calculateTotalPriceOfBasket(bagsOfPeas: Int, dozensOfEggs: Int, bottlesOfMilk: Int, cansOfBeans: Int) -> Double {
        var result: Double = 0
        result += Double(bagsOfPeas) * priceOfBagOfPeas
        result += Double(dozensOfEggs) * priceOfDozenOfEggs
        result += Double(bottlesOfMilk) * priceOfBottleOfMilk
        result += Double(cansOfBeans) * priceOfCanOfBeans
        return result
    }
}
