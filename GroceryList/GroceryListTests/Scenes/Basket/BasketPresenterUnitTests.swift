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
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = BasketPresenter()
    }
    
    // MARK: - Mocks
    class BasketViewControllerMock: BasketPresenterOut {
        var displayTotalCalled = false
        var displayTotalViewModel: BasketModel.Checkout.ViewModel?
        
        var enableCurrencySegmentedControlCalled = false
        
        var displayCurrenciesUpdateMessageCalled = false
        var displayCurrenciesUpdateMessageViewModel: BasketModel.FetchCurrencyRates.ViewModel?
        
        func displayTotal(viewModel: BasketModel.Checkout.ViewModel) {
            displayTotalCalled = true
            displayTotalViewModel = viewModel
        }
        
        func enableCurrencySegmentedControl() {
            enableCurrencySegmentedControlCalled = true
        }
        
        func displayCurrenciesUpdateMessage(viewModel: BasketModel.FetchCurrencyRates.ViewModel) {
            displayCurrenciesUpdateMessageCalled = true
            displayCurrenciesUpdateMessageViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    func testCallingPresentTotal_CallsDisplayTotalInViewController_WithCorrectData() {
        // Given
        let viewControllerMock = BasketViewControllerMock()
        sut.viewController = viewControllerMock
        
        // When
        let response = BasketModel.Checkout.Response(total: 50.55)
        sut.presentTotal(response: response)
        
        // Then
        XCTAssertTrue(viewControllerMock.displayTotalCalled)
        XCTAssertEqual(viewControllerMock.displayTotalViewModel?.total, 50.55)
    }
    
    func testCallingEnableCurrencies_CallsEnableCurrencySegmentedControlInViewController() {
        // Given
        let viewControllerMock = BasketViewControllerMock()
        sut.viewController = viewControllerMock
        
        // When
        sut.enableCurrencies()
        
        // Then
        XCTAssertTrue(viewControllerMock.enableCurrencySegmentedControlCalled)
    }
    
    func testCallingPresentCurrenciesUpdateMessage_CallsDisplayCurrenciesUpdateMessageInViewController_WithCorrectData() {
        // Given
        let viewControllerMock = BasketViewControllerMock()
        sut.viewController = viewControllerMock
        
        // When
        sut.presentCurrenciesUpdateMessage()
        
        // Then
        XCTAssertTrue(viewControllerMock.displayCurrenciesUpdateMessageCalled)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm on dd-MM-yyyy"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let viewModel = viewControllerMock.displayCurrenciesUpdateMessageViewModel
        XCTAssertEqual(viewModel?.message, "Currency rates last updated at \(dateString)")
    }
}
