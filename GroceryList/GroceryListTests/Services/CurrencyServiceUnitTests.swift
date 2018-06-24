//
//  CurrencyServiceUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
import RxBlocking
@testable import GroceryList

class CurrencyServiceTests: XCTestCase {
    
    // MARK: - Properties
    var sut: CurrencyService!
    let mockServer = MockServer()
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        setupSUT()
    }
    
    override func tearDown() {
        sut = nil
        mockServer.stop()
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = CurrencyService()
    }
    
    // MARK: - Tests
    func testCallingFetchRawCurrencyRatesFromServer_ReturnsCorrectData_WhenThereIsNoError() {
        // Given
        mockServer.respondToGetCurrencyRatesWithSuccess()
        mockServer.start()
        
        // When
        let result = try! sut.fetchRawCurrencyRatesFromServer(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .Success(let rawCurrencyRates):
            XCTAssertEqual(rawCurrencyRates.success, true)
            XCTAssertEqual(rawCurrencyRates.terms, "https://currencylayer.com/terms")
            XCTAssertEqual(rawCurrencyRates.privacy, "https://currencylayer.com/privacy")
            XCTAssertEqual(rawCurrencyRates.timestamp, 1529835786)
            XCTAssertEqual(rawCurrencyRates.source, "USD")
            XCTAssertEqual(rawCurrencyRates.quotes?.eur, 1.5)
            XCTAssertEqual(rawCurrencyRates.quotes?.gbp, 2.0)
        case .Failure(_):
            XCTFail()
        }
    }
    
    func testCallingFetchRawCurrencyRatesFromServer_ReturnsCorrectData_WhenThereIsAnErrorInUrl() {
        // Given
        mockServer.respondToGetCurrencyRatesWithSuccess()
        mockServer.start()
        
        // When
        sut.currencyEndpoint = ""
        let result = try! sut.fetchRawCurrencyRatesFromServer(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .Success(_):
            XCTFail()
        case .Failure(let serviceErrorType):
            XCTAssertEqual(serviceErrorType, .invalidUrl)
        }
    }
    
    func testCallingFetchRawCurrencyRatesFromServer_ReturnsCorrectData_WhenThereIsAnErrorInServerResponse() {
        // Given
        mockServer.respondToGetCurrencyRatesWithError()
        mockServer.start()
        
        // When
        let result = try! sut.fetchRawCurrencyRatesFromServer(fromCurrency: .usd, toCurrencies: [.eur, .gbp]).toBlocking(timeout: 1).first()
        
        // Then
        switch result! {
        case .Success(_):
            XCTFail()
        case .Failure(let serviceErrorType):
            XCTAssertEqual(serviceErrorType, .invalidResponse)
        }
    }
}
