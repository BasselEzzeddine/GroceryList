//
//  BasketViewController.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 23/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BasketViewControllerIn {
    func displayTotal(viewModel: BasketModel.Checkout.ViewModel)
    func enableCurrencySegmentedControl()
    func updateInfoMessage(viewModel: BasketModel.FetchCurrencyRates.ViewModel)
}

protocol BasketViewControllerOut {
    func fetchCurrencyRates()
    func checkout(request: BasketModel.Checkout.Request)
}

class BasketViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var stepper_peas: UIStepper!
    @IBOutlet weak var stepper_eggs: UIStepper!
    @IBOutlet weak var stepper_milk: UIStepper!
    @IBOutlet weak var stepper_beans: UIStepper!
    
    @IBOutlet weak var label_peas: UILabel!
    @IBOutlet weak var label_eggs: UILabel!
    @IBOutlet weak var label_milk: UILabel!
    @IBOutlet weak var label_beans: UILabel!
    
    @IBOutlet weak var button_checkout: UIButton!
    @IBOutlet weak var segmentedControl_currency: UISegmentedControl!
    @IBOutlet weak var label_total: UILabel!
    @IBOutlet weak var label_info: UILabel!
    
    // MARK: - Properties
    var interactor: BasketViewControllerOut?
    private let disposeBag = DisposeBag()
    
    var bagsOfPeasInBasket: Int = 0
    var dozensOfEggsInBasket: Int = 0
    var bottlesOfMilkInBasket: Int = 0
    var cansOfBeansInBasket: Int = 0
    
    // MARK: - UIViewController
    override func awakeFromNib() {
        super.awakeFromNib()
        BasketConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControlsDrivers()
        disableCurrencySegmentedControl()
        emptyTheInfoLabel()
        interactor?.fetchCurrencyRates()
    }
    
    // MARK: - Actions
    @IBAction func button_checkout_touchUpInside(_ sender: Any) {
        var selectedCurrency: BasketModel.Checkout.Request.Currency = .usd
        
        switch segmentedControl_currency.selectedSegmentIndex {
        case 1:
            selectedCurrency = .eur
        case 2:
            selectedCurrency = .gbp
        default:
            selectedCurrency = .usd
        }
        
        let request = BasketModel.Checkout.Request(bagsOfPeasInBasket: bagsOfPeasInBasket, dozensOfEggsInBasket: dozensOfEggsInBasket, bottlesOfMilkInBasket: bottlesOfMilkInBasket, cansOfBeansInBasket: cansOfBeansInBasket, selectedCurrency: selectedCurrency)
        interactor?.checkout(request: request)
    }
    
    // MARK: - Methods
    func setupControlsDrivers() {
        // Peas stepper driver
        let peasDriver = stepper_peas.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_peas.value) }
            .asDriver(onErrorJustReturn: 0)
        
        peasDriver.drive(onNext: { value in
            self.bagsOfPeasInBasket = value
        }).disposed(by: disposeBag)
        
        peasDriver.map { "\($0) bags" }
            .drive(label_peas.rx.text)
            .disposed(by: disposeBag)
        
        // Eggs stepper driver
        let eggsDriver = stepper_eggs.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_eggs.value) }
            .asDriver(onErrorJustReturn: 0)
        
        eggsDriver.drive(onNext: { value in
            self.dozensOfEggsInBasket = value
        }).disposed(by: disposeBag)
        
        eggsDriver.map { "\($0) dozens" }
            .drive(label_eggs.rx.text)
            .disposed(by: disposeBag)
        
        // Milk stepper driver
        let milkDriver = stepper_milk.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_milk.value) }
            .asDriver(onErrorJustReturn: 0)
        
        milkDriver.drive(onNext: { value in
            self.bottlesOfMilkInBasket = value
        }).disposed(by: disposeBag)
        
        milkDriver.map { "\($0) bottles" }
            .drive(label_milk.rx.text)
            .disposed(by: disposeBag)
        
        // Beans stepper driver
        let beansDriver = stepper_beans.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_beans.value) }
            .asDriver(onErrorJustReturn: 0)
        
        beansDriver.drive(onNext: { value in
            self.cansOfBeansInBasket = value
        }).disposed(by: disposeBag)
        
        beansDriver.map { "\($0) cans" }
            .drive(label_beans.rx.text)
            .disposed(by: disposeBag)
    }
    
    func disableCurrencySegmentedControl() {
        segmentedControl_currency.isEnabled = false
    }
    
    func emptyTheInfoLabel() {
        label_info.text = ""
    }
}

// MARK: - BasketViewControllerIn
extension BasketViewController: BasketViewControllerIn {
    func displayTotal(viewModel: BasketModel.Checkout.ViewModel) {
        label_total.text = String(viewModel.total).replacingOccurrences(of: ".", with: ",")
    }
    
    func enableCurrencySegmentedControl() {
        segmentedControl_currency.isEnabled = true
    }
    
    func updateInfoMessage(viewModel: BasketModel.FetchCurrencyRates.ViewModel) {
        label_info.text = viewModel.message
    }
}
