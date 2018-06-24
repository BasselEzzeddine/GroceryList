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
        
        func displayTotal(viewModel: BasketModel.Checkout.ViewModel) {
            displayTotalCalled = true
            displayTotalViewModel = viewModel
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
}
