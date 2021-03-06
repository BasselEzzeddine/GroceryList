//
//  BasketPresenterUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import GroceryList

class BasketPresenterUnitTests: XCTestCase {
    
    // MARK: - Properties
    var sut: BasketPresenter!
    
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
        sut = BasketPresenter()
    }
    
    // MARK: - Spies
    class BasketViewControllerSpy: BasketPresenterOut {
        var displayTotalCalled = false
        var displayTotalViewModel: BasketModel.Checkout.ViewModel?
        
        var enableCurrencySegmentedControlCalled = false
        
        var updateInfoMessageCalled = false
        var updateInfoMessageViewModel: BasketModel.FetchCurrencyRates.ViewModel?
        
        func displayTotal(viewModel: BasketModel.Checkout.ViewModel) {
            displayTotalCalled = true
            displayTotalViewModel = viewModel
        }
        
        func enableCurrencySegmentedControl() {
            enableCurrencySegmentedControlCalled = true
        }
        
        func updateInfoMessage(viewModel: BasketModel.FetchCurrencyRates.ViewModel) {
            updateInfoMessageCalled = true
            updateInfoMessageViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    func testCallingPresentTotal_CallsDisplayTotalInViewController_WithCorrectData() {
        // Given
        let viewControllerSpy = BasketViewControllerSpy()
        sut.viewController = viewControllerSpy
        
        // When
        let response = BasketModel.Checkout.Response(total: 50.55)
        sut.presentTotal(response: response)
        
        // Then
        XCTAssertTrue(viewControllerSpy.displayTotalCalled)
        XCTAssertEqual(viewControllerSpy.displayTotalViewModel?.total, "50,55")
    }
    
    func testCallingEnableCurrencies_CallsEnableCurrencySegmentedControlInViewController() {
        // Given
        let viewControllerSpy = BasketViewControllerSpy()
        sut.viewController = viewControllerSpy
        
        // When
        sut.enableCurrencies()
        
        // Then
        XCTAssertTrue(viewControllerSpy.enableCurrencySegmentedControlCalled)
    }
    
    func testCallingPresentCurrenciesUpdateMessage_CallsUpdateInfoMessageInViewController_WithCorrectData() {
        // Given
        let viewControllerSpy = BasketViewControllerSpy()
        sut.viewController = viewControllerSpy
        
        // When
        sut.presentCurrenciesUpdateMessage()
        
        // Then
        XCTAssertTrue(viewControllerSpy.updateInfoMessageCalled)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'on' dd/MM/yyyy 'at' HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let viewModel = viewControllerSpy.updateInfoMessageViewModel
        XCTAssertEqual(viewModel?.message, "Currency rates last updated \(dateString)")
    }
    
    func testCallingPresentCurrenciesErrorMessage_CallsUpdateInfoMessageInViewController_WithCorrectData() {
        // Given
        let viewControllerSpy = BasketViewControllerSpy()
        sut.viewController = viewControllerSpy
        
        // When
        sut.presentCurrenciesErrorMessage()
        
        // Then
        XCTAssertTrue(viewControllerSpy.updateInfoMessageCalled)
        
        let viewModel = viewControllerSpy.updateInfoMessageViewModel
        XCTAssertEqual(viewModel?.message, "Currency rates are unavailable for the moment")
    }
}
