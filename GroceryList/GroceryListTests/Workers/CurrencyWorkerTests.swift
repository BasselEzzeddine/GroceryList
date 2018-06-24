//
//  CurrencyWorkerTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import GroceryList

class CurrencyWorkerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: CurrencyWorker!
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
        sut = CurrencyWorker()
    }
    
    // MARK: - Spies
    class CurrencyServiceSpy: CurrencyService {
        var fetchRawCurrencyRatesFromServerCalled = false
        var resultToBeReturned: ServiceResult<RawCurrencyRates>?
        
        override func fetchRawCurrencyRatesFromServer(fromCurrency: CurrencyService.Currency, toCurrencies: [CurrencyService.Currency]) -> Observable<ServiceResult<RawCurrencyRates>> {
            fetchRawCurrencyRatesFromServerCalled = true
            return Observable.just(resultToBeReturned!)
        }
    }
    
    // MARK: - Tests
    func testCallingFetchRawCurrencyRates_CallsFetchRawCurrencyRatesFromServer_AndReturnsCorrectData_WhenHavingSuccess() {
        // Given
        let serviceSpy = CurrencyServiceSpy()
        sut.service = serviceSpy
        
        // When
        let rawCurrencyRatesMock = mockData.getRawCurrencyRatesMock()
        serviceSpy.resultToBeReturned = ServiceResult.Success(rawCurrencyRatesMock)
        
        let result = try! sut.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        XCTAssertTrue(serviceSpy.fetchRawCurrencyRatesFromServerCalled)
        
        switch result! {
        case .Success(let rawCurrencyRates):
            XCTAssertEqual(rawCurrencyRates, rawCurrencyRatesMock)
        case .Failure(_):
            XCTFail()
        }
    }
    
    func testCallingFetchRawCurrencyRates_CallsFetchRawCurrencyRatesFromServer_AndReturnsCorrectData_WhenHavingFailure() {
        // Given
        let serviceSpy = CurrencyServiceSpy()
        sut.service = serviceSpy
        
        // When
        serviceSpy.resultToBeReturned = ServiceResult.Failure(.invalidResponse)
        
        let result = try! sut.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        XCTAssertTrue(serviceSpy.fetchRawCurrencyRatesFromServerCalled)
        
        switch result! {
        case .Success(_):
            XCTFail()
        case .Failure(let serviceErrorType):
            XCTAssertEqual(serviceErrorType, .invalidResponse)
        }
    }
}
