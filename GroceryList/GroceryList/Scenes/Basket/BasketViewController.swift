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
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSteppersDrivers()
    }
    
    // MARK: - Methods
    func setupSteppersDrivers() {
        stepper_peas.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_peas.value) }
            .asDriver(onErrorJustReturn: 0)
            .map { "\($0) bags" }
            .drive(label_peas.rx.text)
            .disposed(by: disposeBag)
        
        stepper_eggs.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_eggs.value) }
            .asDriver(onErrorJustReturn: 0)
            .map { "\($0) dozens" }
            .drive(label_eggs.rx.text)
            .disposed(by: disposeBag)
        
        stepper_milk.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_milk.value) }
            .asDriver(onErrorJustReturn: 0)
            .map { "\($0) bottles" }
            .drive(label_milk.rx.text)
            .disposed(by: disposeBag)
        
        stepper_beans.rx.controlEvent(.valueChanged)
            .map { Int(self.stepper_beans.value) }
            .asDriver(onErrorJustReturn: 0)
            .map { "\($0) cans" }
            .drive(label_beans.rx.text)
            .disposed(by: disposeBag)
    }
}
