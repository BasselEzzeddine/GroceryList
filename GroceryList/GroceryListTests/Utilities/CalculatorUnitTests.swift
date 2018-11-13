//
//  CalculatorUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import GroceryList

class CalculatorUnitTests: XCTestCase {
    
    // MARK: - Properties
    var sut: Calculator!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSut()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSut() {
        sut = Calculator()
    }
    
    // MARK: - Tests
    func testCallingCalculateTotalAmountOfBasket_ReturnsCorrectData() {
        // Given
        let priceOfBagOfPeas: Double = 0.95
        let priceOfDozenOfEggs: Double = 2.10
        let priceOfBottleOfMilk: Double = 1.30
        let priceOfCanOfBeans: Double = 0.73
        
        // When
        var result = sut.calculateTotalPriceOfBasket(bagsOfPeas: 0, dozensOfEggs: 0, bottlesOfMilk: 0, cansOfBeans: 0, priceOfBagOfPeasInUsd: priceOfBagOfPeas, priceOfDozenOfEggsInUsd: priceOfDozenOfEggs, priceOfBottleOfMilkInUsd: priceOfBottleOfMilk, priceOfCanOfBeansInUsd: priceOfCanOfBeans, conversionRateFromUsd: 1)
        
        // Then
        XCTAssertEqual(result, 0)
        
        // When
        result = sut.calculateTotalPriceOfBasket(bagsOfPeas: 0, dozensOfEggs: 0, bottlesOfMilk: 0, cansOfBeans: 1, priceOfBagOfPeasInUsd: priceOfBagOfPeas, priceOfDozenOfEggsInUsd: priceOfDozenOfEggs, priceOfBottleOfMilkInUsd: priceOfBottleOfMilk, priceOfCanOfBeansInUsd: priceOfCanOfBeans, conversionRateFromUsd: 1)
        
        // Then
        XCTAssertEqual(result, 0.73)
        
        // When
        result = sut.calculateTotalPriceOfBasket(bagsOfPeas: 1, dozensOfEggs: 1, bottlesOfMilk: 1, cansOfBeans: 1, priceOfBagOfPeasInUsd: priceOfBagOfPeas, priceOfDozenOfEggsInUsd: priceOfDozenOfEggs, priceOfBottleOfMilkInUsd: priceOfBottleOfMilk, priceOfCanOfBeansInUsd: priceOfCanOfBeans, conversionRateFromUsd: 1)
        
        // Then
        XCTAssertEqual(result, 5.08)
        
        // When
        result = sut.calculateTotalPriceOfBasket(bagsOfPeas: 2, dozensOfEggs: 2, bottlesOfMilk: 2, cansOfBeans: 2, priceOfBagOfPeasInUsd: priceOfBagOfPeas, priceOfDozenOfEggsInUsd: priceOfDozenOfEggs, priceOfBottleOfMilkInUsd: priceOfBottleOfMilk, priceOfCanOfBeansInUsd: priceOfCanOfBeans, conversionRateFromUsd: 1)
        
        // Then
        XCTAssertEqual(result, 10.16)
        
        // When
        result = sut.calculateTotalPriceOfBasket(bagsOfPeas: 2, dozensOfEggs: 2, bottlesOfMilk: 2, cansOfBeans: 2, priceOfBagOfPeasInUsd: priceOfBagOfPeas, priceOfDozenOfEggsInUsd: priceOfDozenOfEggs, priceOfBottleOfMilkInUsd: priceOfBottleOfMilk, priceOfCanOfBeansInUsd: priceOfCanOfBeans, conversionRateFromUsd: 0.85)
        
        // Then
        XCTAssertEqual(result, 8.636)
    }
}
