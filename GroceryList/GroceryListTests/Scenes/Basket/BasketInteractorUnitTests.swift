//
//  BasketInteractorUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import GroceryList

class BasketInteractorUnitTests: XCTestCase {
    
    // MARK: - Properties
    var sut: BasketInteractor!
    
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
        sut = BasketInteractor()
    }
    
    // MARK: - Mocks
    class BasketPresenterMock: BasketInteractorOut {
        var presentTotalCalled = false
        var presentTotalResponse: BasketModel.Checkout.Response?
        
        func presentTotal(response: BasketModel.Checkout.Response) {
            presentTotalCalled = true
            presentTotalResponse = response
        }
    }
    
    // MARK: - Tests
    func testCallingCheckout_CallsPresentTotalInPresenter_WithCorrectData() {
        // Given
        let presenterMock = BasketPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let request = BasketModel.Checkout.Request(bagsOfPeasInBasket: 1, dozensOfEggsInBasket: 2, bottlesOfMilkInBasket: 3, cansOfBeansInBasket: 4)
        sut.checkout(request: request)
        
        // Then
        XCTAssertTrue(presenterMock.presentTotalCalled)
        XCTAssertEqual(presenterMock.presentTotalResponse?.total, 11.97)
    }
}
