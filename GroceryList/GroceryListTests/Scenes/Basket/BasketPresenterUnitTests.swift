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
    
    func testCallingPresentCurrenciesUpdateMessage_CallsUpdateInfoMessageInViewController_WithCorrectData() {
        // Given
        let viewControllerMock = BasketViewControllerMock()
        sut.viewController = viewControllerMock
        
        // When
        sut.presentCurrenciesUpdateMessage()
        
        // Then
        XCTAssertTrue(viewControllerMock.updateInfoMessageCalled)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm on dd-MM-yyyy"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let viewModel = viewControllerMock.updateInfoMessageViewModel
        XCTAssertEqual(viewModel?.message, "Currency rates last updated at \(dateString)")
    }
}
