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
    
    class CurrencyWorkerMock: CurrencyWorker {
        var fetchRawCurrencyRatesCalled = false
        var fromCurrencyPassed: CurrencyService.Currency?
        var toCurrenciesPassed: [CurrencyService.Currency]?
        var resultToBeReturned: ServiceResult<RawCurrencyRates>?
        
        override func fetchRawCurrencyRates(fromCurrency: CurrencyService.Currency, toCurrencies: [CurrencyService.Currency]) -> Observable<ServiceResult<RawCurrencyRates>> {
            fetchRawCurrencyRatesCalled = true
            fromCurrencyPassed = fromCurrency
            toCurrenciesPassed = toCurrencies
            return Observable.just(resultToBeReturned!)
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
    
    func testFetchCurrencyRates_CallsFetchRawCurrencyRatesInWorker_WithCorrectData() {
        // Given
        let workerMock = CurrencyWorkerMock()
        sut.worker = workerMock
        
        // When
        workerMock.resultToBeReturned = ServiceResult.Failure(.invalidResponse)
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(workerMock.fetchRawCurrencyRatesCalled)
        XCTAssertEqual(workerMock.fromCurrencyPassed, .usd)
        XCTAssertEqual(workerMock.toCurrenciesPassed, [.eur, .gbp])
    }
    
    func testWhenReceivingSuccessFromWorker_CallsEnableCurrenciesInPresenter() {
        // Given
        let workerMock = CurrencyWorkerMock()
        sut.worker = workerMock
        
        let presenterMock = BasketPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        workerMock.resultToBeReturned = ServiceResult.Success(rawCurrencyRatesMock)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterMock.enableCurrenciesCalled)
    }
    
    func testWhenReceivingSuccessFromWorker_CallsPresentCurrenciesUpdateMessageInPresenter() {
        // Given
        let workerMock = CurrencyWorkerMock()
        sut.worker = workerMock
        
        let presenterMock = BasketPresenterMock()
        sut.presenter = presenterMock
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        workerMock.resultToBeReturned = ServiceResult.Success(rawCurrencyRatesMock)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterMock.presentCurrenciesUpdateMessageCalled)
    }
    
    func testWhenReceivingInvalidUrlFailureFromWorker_CallsPresentCurrenciesErrorMessageInPresenter() {
        // Given
        let workerMock = CurrencyWorkerMock()
        sut.worker = workerMock
        
        let presenterMock = BasketPresenterMock()
        sut.presenter = presenterMock
        
        // When
        workerMock.resultToBeReturned = ServiceResult.Failure(.invalidUrl)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterMock.presentCurrenciesErrorMessageCalled)
    }
    
    func testWhenReceivingInvalidResponseFailureFromWorker_CallsPresentCurrenciesErrorMessageInPresenter() {
        // Given
        let workerMock = CurrencyWorkerMock()
        sut.worker = workerMock
        
        let presenterMock = BasketPresenterMock()
        sut.presenter = presenterMock
        
        // When
        workerMock.resultToBeReturned = ServiceResult.Failure(.invalidResponse)
        
        sut.fetchCurrencyRates()
        
        // Then
        XCTAssertTrue(presenterMock.presentCurrenciesErrorMessageCalled)
    }
}
