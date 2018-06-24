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
    
    // MARK: - Mocks
    class BasketInteractorMock: BasketViewControllerOut {
        var checkoutCalled = false
        var checkoutRequest: BasketModel.Checkout.Request?
        
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
        let interactorMock = BasketInteractorMock()
        sut.interactor = interactorMock
        
        sut.bagsOfPeasInBasket = 1
        sut.dozensOfEggsInBasket = 2
        sut.bottlesOfMilkInBasket = 3
        sut.cansOfBeansInBasket = 4
        
        // When
        sut.button_checkout_touchUpInside(sut.button_checkout)
        
        // Then
        XCTAssertTrue(interactorMock.checkoutCalled)
        
        XCTAssertEqual(interactorMock.checkoutRequest?.bagsOfPeasInBasket, 1)
        XCTAssertEqual(interactorMock.checkoutRequest?.dozensOfEggsInBasket, 2)
        XCTAssertEqual(interactorMock.checkoutRequest?.bottlesOfMilkInBasket, 3)
        XCTAssertEqual(interactorMock.checkoutRequest?.cansOfBeansInBasket, 4)
    }
}