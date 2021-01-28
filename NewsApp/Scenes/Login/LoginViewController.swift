//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, ViewModelBased {
    weak var viewModel: LoginViewModel!
    
    weak var disposeBag: DisposeBag!
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func getInputsViewModel() -> LoginInputs {
        return LoginInputs(username: usernameLabel.rx.text.orEmpty.asObservable(),
                           password: passwordLabel.rx.text.orEmpty.asObservable(),
                           tapExecuteLogin: loginButton.rx.tap.asObservable())
    }
    
    func bindUI() {
        
        viewModel.output.isLoginValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.output.alphaButton
            .asDriver()
            .drive(loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.output.animateButtonEvent
            .drive(onNext: { [weak self] (_) in
                self?.loginButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                UIView.animate(withDuration: 0.2) {
                    self?.loginButton.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }

}
