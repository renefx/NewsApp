//
//  ViewModel.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import Foundation
import UIKit

protocol Inputs {}

struct EmptyInputs: Inputs {}

protocol Outputs {}

struct EmptyOutputs: Outputs {}

protocol Actions {}

protocol ViewModel {
    associatedtype InputType: Inputs
    mutating func setUp(with input: InputType)
    
    associatedtype OutputType: Outputs
    var output: OutputType! { get set }
}

extension ViewModel {
    func setUp(with input: EmptyInputs) {}
}

protocol ViewModelBased {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
    
    associatedtype InputData: Inputs
    func getInputsViewModel() -> InputData
    
    func bindUI()
}

extension ViewModelBased where Self: UIViewController, InputData == ViewModelType.InputType {
    
    mutating func bind( to viewmodel: inout ViewModelType) {
        self.viewModel = viewmodel
        loadViewIfNeeded()
        let inputs = getInputsViewModel()
        viewmodel.setUp(with: inputs)
        self.bindUI()
    }
    
}
