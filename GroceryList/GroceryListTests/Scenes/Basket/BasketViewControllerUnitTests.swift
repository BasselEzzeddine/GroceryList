//
//  BasketViewControllerUnitTests.swift
//  GroceryListTests
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import XCTest
@testable import GroceryList

class BasketViewControllerUnitTests: XCTestCase {
    
    // MARK: - Properties
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var window: UIWindow!
    var sut: BasketViewController!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupSUT()
        loadView()
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }
    
    // MARK: - Setup
    func setupSUT() {
        sut = storyboard.instantiateViewController(withIdentifier: "BasketViewController") as! BasketViewController
    }
    
    // MARK: - Spies
    class BasketInteractorSpy: BasketViewControllerOut {
        var fetchCurrencyRatesCalled = false
        
        var checkoutCalled = false
        var checkoutRequest: BasketModel.Checkout.Request?
        
        func fetchCurrencyRates() {
            fetchCurrencyRatesCalled = true
        }
        
        func checkout(request: BasketModel.Checkout.Request) {
            checkoutCalled = true
            checkoutRequest = request
        }
    }
    
    // MARK: - Methods
    func loadView() {
        window.addSubview(sut.view)
    }
    
    // MARK: - Tests
    func testChangingPeasStepperValue_SetsCorrectBagsOfPeasInBasket_AndDisplaysCorrectText() {
        // Given
        sut.label_peas.text = "0 bags"
        
        // When
        sut.stepper_peas.value = 1
        sut.stepper_peas.sendActions(for: .valueChanged)
        
        // Then
        XCTAssertEqual(sut.bagsOfPeasInBasket, 1)
        XCTAssertEqual(sut.label_peas.text, "1 bags")
    }
    
    func testChangingEggsStepperValue_SetsCorrectDozensOfEggsInBasket_AndDisplaysCorrectText() {
        // Given
        sut.label_eggs.text = "0 dozens"
        
        // When
        sut.stepper_eggs.value = 2
        sut.stepper_eggs.sendActions(for: .valueChanged)
        
        // Then
        XCTAssertEqual(sut.dozensOfEggsInBasket, 2)
        XCTAssertEqual(sut.label_eggs.text, "2 dozens")
    }
    
    func testChangingMilkStepperValue_SetsCorrectBottlesOfMilkInBasket_AndDisplaysCorrectText() {
        // Given
        sut.label_milk.text = "0 bottles"
        
        // When
        sut.stepper_milk.value = 3
        sut.stepper_milk.sendActions(for: .valueChanged)
        
        // Then
        XCTAssertEqual(sut.bottlesOfMilkInBasket, 3)
        XCTAssertEqual(sut.label_milk.text, "3 bottles")
    }
    
    func testChangingBeansStepperValue_SetsCorrectCansOfBeansInBasket_AndDisplaysCorrectText() {
        // Given
        sut.label_beans.text = "0 cans"
        
        // When
        sut.stepper_beans.value = 4
        sut.stepper_beans.sendActions(for: .valueChanged)
        
        // Then
        XCTAssertEqual(sut.cansOfBeansInBasket, 4)
        XCTAssertEqual(sut.label_beans.text, "4 cans")
    }
    
    func testClickingOnCheckoutButton_CallsCheckoutInInteractor_WithCorrectData() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        sut.bagsOfPeasInBasket = 1
        sut.dozensOfEggsInBasket = 2
        sut.bottlesOfMilkInBasket = 3
        sut.cansOfBeansInBasket = 4
        
        // When
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertTrue(interactorSpy.checkoutCalled)
        
        XCTAssertEqual(interactorSpy.checkoutRequest?.bagsOfPeasInBasket, 1)
        XCTAssertEqual(interactorSpy.checkoutRequest?.dozensOfEggsInBasket, 2)
        XCTAssertEqual(interactorSpy.checkoutRequest?.bottlesOfMilkInBasket, 3)
        XCTAssertEqual(interactorSpy.checkoutRequest?.cansOfBeansInBasket, 4)
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .usd)
    }
    
    func testClickingOnCheckoutButton_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsUsd() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 0
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .usd)
    }
    
    func testClickingOnCheckoutButton_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsEur() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 1
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .eur)
    }
    
    func testClickingOnCheckoutButton_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsGbp() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 2
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .gbp)
    }
    
    func testchangingValueOfCurrencySegmentedControl_CallsCheckoutInInteractor_WithCorrectData() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        sut.bagsOfPeasInBasket = 1
        sut.dozensOfEggsInBasket = 2
        sut.bottlesOfMilkInBasket = 3
        sut.cansOfBeansInBasket = 4
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 0
        sut.segmentedControl_currency_valueChanged(sut.segmentedControl_currency)
        
        // Then
        XCTAssertTrue(interactorSpy.checkoutCalled)
        
        XCTAssertEqual(interactorSpy.checkoutRequest?.bagsOfPeasInBasket, 1)
        XCTAssertEqual(interactorSpy.checkoutRequest?.dozensOfEggsInBasket, 2)
        XCTAssertEqual(interactorSpy.checkoutRequest?.bottlesOfMilkInBasket, 3)
        XCTAssertEqual(interactorSpy.checkoutRequest?.cansOfBeansInBasket, 4)
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .usd)
    }
    
    func testchangingValueOfCurrencySegmentedControl_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsUsd() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 0
        sut.segmentedControl_currency_valueChanged(sut.segmentedControl_currency)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .usd)
    }
    
    func testchangingValueOfCurrencySegmentedControl_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsEur() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 1
        sut.segmentedControl_currency_valueChanged(sut.segmentedControl_currency)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .eur)
    }
    
    func testchangingValueOfCurrencySegmentedControl_PassesCorrectCurrencyToInteractor_WhenSelectedCurrencyIsGbp() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.segmentedControl_currency.selectedSegmentIndex = 2
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertEqual(interactorSpy.checkoutRequest?.selectedCurrency, .gbp)
    }
    
    func testCallingDisplayTotal_DisplaysCorrectText() {
        // Given
        sut.label_total.text = ""
        
        // When
        let viewModel = BasketModel.Checkout.ViewModel(total: "50,55")
        sut.displayTotal(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.label_total.text, "50,55")
    }
    
    func testWhenViewLoads_DisablesCurrencySegmentedControl() {
        // Given
        sut.segmentedControl_currency.isEnabled = true
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertFalse(sut.segmentedControl_currency.isEnabled)
    }
    
    func testWhenViewLoads_EmptyTheInfoLabel() {
        // Given
        sut.label_info.text = "Info"
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.label_info.text, "")
    }
    
    func testWhenViewLoads_CallsFetchCurrencyRatesInInteractor() {
        // Given
        let interactorSpy = BasketInteractorSpy()
        sut.interactor = interactorSpy
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(interactorSpy.fetchCurrencyRatesCalled)
    }
    
    func testCallingEnableCurrencySegmentedControl_EnablesCurrencySegmentedControl() {
        // Given
        sut.segmentedControl_currency.isEnabled = false
        
        // When
        sut.enableCurrencySegmentedControl()
        
        // Then
        XCTAssertTrue(sut.segmentedControl_currency.isEnabled)
    }
    
    func testCallingUpdateInfoMessage_DisplaysCorrectText() {
        // Given
        sut.label_info.text = ""
        
        // When
        let viewModel = BasketModel.FetchCurrencyRates.ViewModel(message: "Message")
        sut.updateInfoMessage(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.label_info.text, "Message")
    }
}
