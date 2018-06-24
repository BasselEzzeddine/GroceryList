//
//  CalculatorTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import GroceryList

class CalculatorTests: XCTestCase {
    
    // MARK: - Properties
    var sut: Calculator!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = Calculator()
    }
    
    // MARK: - Tests
    func testCallingCalculateTotalAmountOfBasket_ReturnsCorrectData() {
        // When
        var result = sut.calculateTotalAmountOfBasket(bagsOfPeas: 0, dozensOfEggs: 0, bottlesOfMilk: 0, cansOfBeans: 0)
        
        // Then
        XCTAssertEqual(result, 0)
        
        // When
        result = sut.calculateTotalAmountOfBasket(bagsOfPeas: 0, dozensOfEggs: 0, bottlesOfMilk: 0, cansOfBeans: 1)
        
        // Then
        XCTAssertEqual(result, 0.73)
        
        // When
        result = sut.calculateTotalAmountOfBasket(bagsOfPeas: 1, dozensOfEggs: 1, bottlesOfMilk: 1, cansOfBeans: 1)
        
        // Then
        XCTAssertEqual(result, 5.08)
        
        // When
        result = sut.calculateTotalAmountOfBasket(bagsOfPeas: 2, dozensOfEggs: 2, bottlesOfMilk: 2, cansOfBeans: 2)
        
        // Then
        XCTAssertEqual(result, 10.16)
    }
}
