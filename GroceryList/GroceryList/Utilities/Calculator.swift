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
    func calculateTotalPriceOfBasket(bagsOfPeas: Int, dozensOfEggs: Int, bottlesOfMilk: Int, cansOfBeans: Int, priceOfBagOfPeasInUsd: Double, priceOfDozenOfEggsInUsd: Double, priceOfBottleOfMilkInUsd: Double, priceOfCanOfBeansInUsd: Double, conversionRateFromUsd: Double) -> Double {
        var result: Double = 0
        result += Double(bagsOfPeas) * priceOfBagOfPeasInUsd
        result += Double(dozensOfEggs) * priceOfDozenOfEggsInUsd
        result += Double(bottlesOfMilk) * priceOfBottleOfMilkInUsd
        result += Double(cansOfBeans) * priceOfCanOfBeansInUsd
        return (result * conversionRateFromUsd)
    }
}
