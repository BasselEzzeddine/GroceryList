//
//  Calculator.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Methods
    func calculateTotalPriceOfBasket(bagsOfPeas: Int, dozensOfEggs: Int, bottlesOfMilk: Int, cansOfBeans: Int, priceOfBagOfPeas: Double, priceOfDozenOfEggs: Double, priceOfBottleOfMilk: Double, priceOfCanOfBeans: Double) -> Double {
        var result: Double = 0
        result += Double(bagsOfPeas) * priceOfBagOfPeas
        result += Double(dozensOfEggs) * priceOfDozenOfEggs
        result += Double(bottlesOfMilk) * priceOfBottleOfMilk
        result += Double(cansOfBeans) * priceOfCanOfBeans
        return result
    }
}
