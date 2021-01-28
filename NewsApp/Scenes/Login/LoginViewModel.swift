//
//  LoginViewModel.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct LoginInputs: Inputs {
    var username: Observable<String>
    var password: Observable<String>
    var tapExecuteLogin: Observable<Void>
}

struct LoginViewModelOutputs: Outputs {
    var isLoginValid: Driver<Bool>
    var alphaButton: Driver<CGFloat>
    var animateButtonEvent: Driver<Bool>
}

struct LoginActions: Actions {
    var loginExecution: Observable<Any?>
    var loginFailFillField: Driver<Void>
    var loading: Driver<Bool>
}

class LoginViewModel: ViewModel {
    public var output: LoginViewModelOutputs!
    public var actions: LoginActions!
    
    var disposeBag: DisposeBag
    let apiCallResult = PublishSubject<Any?>()
    let isLoading = BehaviorSubject<Bool>(value: false)
    let service: NewsService
    
    init(_ service: NewsService, disposeBag: DisposeBag) {
        self.service = service
        self.disposeBag = disposeBag
    }
    
    func setUp(with input: LoginInputs) {
        let usernameValid = input.username
            .map { (username) in
                return username.count > 0
            }
            .startWith(false)
            .share()
        
        let passwordValid = input.password
            .map { (username) in
                return username.count > 0
            }
            .startWith(false)
            .share()
    
        let isLoginValid = Observable
            .combineLatest(usernameValid, passwordValid, isLoading)
            .map { (usernameValid, passwordValid, isLoading) in
                return usernameValid && passwordValid && !isLoading
            }.startWith(false)
            .share()
                    
        let alphaButton = isLoginValid
            .map({ $0 ? CGFloat(1) : CGFloat(0.1)})
            .startWith(CGFloat(0.1))
            .asDriver(onErrorJustReturn: 0.1)
                        
        let animateButtonEvent = isLoginValid
            .distinctUntilChanged()
            .filter({ $0 })
            .asDriver(onErrorJustReturn: true)
        
        let loginExecution = input.tapExecuteLogin
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(isLoginValid)
            .share()
        
        let loginFailFillField = loginExecution
            .filter { !$0 }
            .map({ _ in Void() })
            .asDriver(onErrorJustReturn: Void())
        
        
        _ = loginExecution
            .withLatestFrom(isLoginValid)
            .filter { $0 }
            .withLatestFrom(input.username)
            .withLatestFrom(input.password, resultSelector: { (username, password) -> UserLogin in
                UserLogin(username: username, password: password)
            })
            .subscribe(onNext: { (user) in
                self.isLoading.onNext(true)
                self.service.postNewsLogin(user: user).filterSuccess().subscribe { [weak self] (response) in
                    self?.isLoading.onNext(false)
                    let object = try? JSONDecoder.decode(data: response.data, to: TokenJwt.self)
                    self?.apiCallResult.onNext(object)
                } onError: { [weak self] (erro) in
                    self?.isLoading.onNext(false)
                    self?.apiCallResult.onNext(erro)
                }.disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        actions = LoginActions(loginExecution: apiCallResult,
                               loginFailFillField: loginFailFillField,
                               loading: isLoading.asDriver(onErrorJustReturn: false))
        
        output = LoginViewModelOutputs(
            isLoginValid: isLoginValid.asDriver(onErrorJustReturn: false),
            alphaButton: alphaButton,
            animateButtonEvent: animateButtonEvent)
    }
    
    
}
