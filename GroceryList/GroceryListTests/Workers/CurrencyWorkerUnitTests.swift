//
//  CurrencyWorkerUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
import RxBlocking
@testable import GroceryList

class CurrencyWorkerTests: XCTestCase {
    
    // MARK: - Properties
    var sut: CurrencyWorker!
    let mockServer = MockServer()
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSut()
    }
    
    override func tearDown() {
        sut = nil
        mockServer.stop()
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSut() {
        sut = CurrencyWorker()
    }
    
    // MARK: - Tests
    func testCallingFetchRawCurrencyRates_ReturnsCorrectData_WhenThereIsNoError() {
        // Given
        mockServer.respondToGetCurrencyRatesWithSuccess()
        mockServer.start()
        
        // When
        let result = try! sut.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .success(let rawCurrencyRates):
            XCTAssertEqual(rawCurrencyRates.success, true)
            XCTAssertEqual(rawCurrencyRates.terms, "https://currencylayer.com/terms")
            XCTAssertEqual(rawCurrencyRates.privacy, "https://currencylayer.com/privacy")
            XCTAssertEqual(rawCurrencyRates.timestamp, 1529835786)
            XCTAssertEqual(rawCurrencyRates.source, "USD")
            XCTAssertEqual(rawCurrencyRates.quotes?.usdToEur, 1.5)
            XCTAssertEqual(rawCurrencyRates.quotes?.usdToGbp, 2.0)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testCallingFetchRawCurrencyRates_ReturnsCorrectData_WhenThereIsAnErrorInUrl() {
        // Given
        mockServer.respondToGetCurrencyRatesWithSuccess()
        mockServer.start()
        
        // When
        sut.currencyEndpoint = ""
        let result = try! sut.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .success(_):
            XCTFail()
        case .failure(let workerErrorType):
            XCTAssertEqual(workerErrorType, .invalidUrl)
        }
    }
    
    func testCallingFetchRawCurrencyRates_ReturnsCorrectData_WhenThereIsAnErrorInServerResponse() {
        // Given
        mockServer.respondToGetCurrencyRatesWithError()
        mockServer.start()
        
        // When
        let result = try! sut.fetchRawCurrencyRates(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .success(_):
            XCTFail()
        case .failure(let workerErrorType):
            XCTAssertEqual(workerErrorType, .invalidResponse)
        }
    }
}
