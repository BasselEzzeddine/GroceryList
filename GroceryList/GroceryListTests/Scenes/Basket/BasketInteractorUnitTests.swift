//
//  BasketInteractorUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
import RxSwift
@testable import GroceryList

class BasketInteractorUnitTests: XCTestCase {
    
    // MARK: - Properties
    var sut: BasketInteractor!
    let mockData = MockData()
    
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
        sut = BasketInteractor()
    }
    
    // MARK: - Spies
    class BasketPresenterSpy: BasketInteractorOut {
        var presentTotalCalled = false
        var presentTotalResponse: BasketModel.Checkout.Response?
        
        var enableCurrenciesCalled = false
        var presentCurrenciesUpdateMessageCalled = false
        
        var presentCurrenciesErrorMessageCalled = false
        
        func presentTotal(response: BasketModel.Checkout.Response) {
            presentTotalCalled = true
            presentTotalResponse = response
        }
        
        func enableCurrencies() {
            enableCurrenciesCalled = true
        }
        
        func presentCurrenciesUpdateMessage() {
            presentCurrenciesUpdateMessageCalled = true
        }
        
        func presentCurrenciesErrorMessage() {
            presentCurrenciesErrorMessageCalled = true
        }
    }
    
    class CurrencyWorkerSpy: CurrencyWorker {
        var fetchRawCurrencyRatesCalled = false
        var fromCurrencyPassed: CurrencyWorker.Currency?
        var toCurrenciesPassed: [CurrencyWorker.Currency]?
        var resultToBeReturned: WorkerHelper.Result<RawCurrencyRates>?
        
        override func fetchRawCurrencyRates(fromCurrency: CurrencyWorker.Currency, toCurrencies: [CurrencyWorker.Currency]) -> Observable<WorkerHelper.Result<RawCurrencyRates>> {
            fetchRawCurrencyRatesCalled = true
            fromCurrencyPassed = fromCurrency
            toCurrenciesPassed = toCurrencies
            return Observable.just(resultToBeReturned!)
        }
    }
    
    // MARK: - Tests
    func testCallingCheckout_CallsPresentTotalInPresenter_WithCorrectData_WhenSelectedCurrencyIsUsd() {
        // Given
        sut.calculator = Calculator()
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        let request = BasketModel.Checkout.Request(bagsOfPeasInBasket: 1, dozensOfEggsInBasket: 2, bottlesOfMilkInBasket: 3, cansOfBeansInBasket: 4, selectedCurrency: .usd)
        sut.checkout(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentTotalCalled)
        XCTAssertEqual(presenterSpy.presentTotalResponse?.total, 11.97)
    }
    
    func testCallingCheckout_CallsPresentTotalInPresenter_WithCorrectData_WhenSelectedCurrencyIsEur() {
        // Given
        sut.calculator = Calculator()
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        sut.usdToEur = 2.0
        
        // When
        let request = BasketModel.Checkout.Request(bagsOfPeasInBasket: 1, dozensOfEggsInBasket: 2, bottlesOfMilkInBasket: 3, cansOfBeansInBasket: 4, selectedCurrency: .eur)
        sut.checkout(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentTotalCalled)
        XCTAssertEqual(presenterSpy.presentTotalResponse?.total, (11.97 * 2.0))
    }
    
    func testCallingCheckout_CallsPresentTotalInPresenter_WithCorrectData_WhenSelectedCurrencyIsGbp() {
        // Given
        sut.calculator = Calculator()
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        sut.usdToGbp = 3.0
        
        // When
        let request = BasketModel.Checkout.Request(bagsOfPeasInBasket: 1, dozensOfEggsInBasket: 2, bottlesOfMilkInBasket: 3, cansOfBeansInBasket: 4, selectedCurrency: .gbp)
        sut.checkout(request: request)
        
        // Then
        XCTAssertTrue(presenterSpy.presentTotalCalled)
        XCTAssertEqual(presenterSpy.presentTotalResponse?.total, (11.97 * 3.0))
    }
    
    func testFetchCurrencyRates_CallsFetchRawCurrencyRatesInWorker_WithCorrectData() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        // When
        workerSpy.resultToBeReturned = WorkerHelper.Result.failure(.invalidResponse)
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(workerSpy.fetchRawCurrencyRatesCalled)
        XCTAssertEqual(workerSpy.fromCurrencyPassed, .usd)
        XCTAssertEqual(workerSpy.toCurrenciesPassed, [.eur, .gbp])
    }
    
    func testWhenReceivingSuccessFromWorker_CallsEnableCurrenciesInPresenter() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        workerSpy.resultToBeReturned = WorkerHelper.Result.success(rawCurrencyRatesMock)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterSpy.enableCurrenciesCalled)
    }
    
    func testWhenReceivingSuccessFromWorker_CallsPresentCurrenciesUpdateMessageInPresenter() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        workerSpy.resultToBeReturned = WorkerHelper.Result.success(rawCurrencyRatesMock)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterSpy.presentCurrenciesUpdateMessageCalled)
    }
    
    func testWhenReceivingInvalidUrlFailureFromWorker_CallsPresentCurrenciesErrorMessageInPresenter() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        workerSpy.resultToBeReturned = WorkerHelper.Result.failure(.invalidUrl)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterSpy.presentCurrenciesErrorMessageCalled)
    }
    
    func testWhenReceivingInvalidResponseFailureFromWorker_CallsPresentCurrenciesErrorMessageInPresenter() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        let presenterSpy = BasketPresenterSpy()
        sut.presenter = presenterSpy
        
        // When
        workerSpy.resultToBeReturned = WorkerHelper.Result.failure(.invalidResponse)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterSpy.presentCurrenciesErrorMessageCalled)
    }
    
    func testWhenReceivingSuccessFromWorker_SetsCorrectRates() {
        // Given
        let workerSpy = CurrencyWorkerSpy()
        sut.worker = workerSpy
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        workerSpy.resultToBeReturned = WorkerHelper.Result.success(rawCurrencyRatesMock)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertEqual(sut.usdToEur, 1.5)
        XCTAssertEqual(sut.usdToGbp, 2.0)
    }
}
