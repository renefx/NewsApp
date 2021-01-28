//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Renê Xavier on 24/01/21.
//

import RxSwift
import ProgressHUD

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    var navigation: UINavigationController?
    
    let disposeBagViewModel = DisposeBag()
    var loadingView: UIView?
    var currentViewController = UIViewController()
    
    private let controlLoading = PublishSubject<Bool>()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start () {
        currentViewController = prepareLoginViewController()
        navigation = UINavigationController(rootViewController: currentViewController)
        
        navigation?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigation?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "WhiteWhite")]
        UIBarButtonItem.appearance().tintColor = UIColor(named: "WhiteWhite")
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        setLoadingAnimation()
    }
    
    func prepareLoginViewController() -> LoginViewController {
        var rootViewController = LoginViewController.instantiate()
        let newsService = NewsService()
        var viewModel = LoginViewModel(newsService, disposeBag: disposeBagViewModel)
        rootViewController.disposeBag = disposeBagViewModel
        rootViewController.bind(to: &viewModel)
        self.setLoginActions(viewModel)
        
        return rootViewController
    }
    
    func setLoadingAnimation() {
        let frame = currentViewController.view.frame
        loadingView = UIView(frame: frame)
        loadingView?.backgroundColor = Constants.loadingBackgroundColor
        
        ProgressHUD.animationType = .singleCirclePulse
        ProgressHUD.colorBackground = Constants.loadingBackgroundColor
        ProgressHUD.colorAnimation = Constants.loadingColor
    }
    
    func setLoginActions(_ viewModel: LoginViewModel) {
        viewModel.actions.loginExecution
            .subscribe(onNext: { [weak self] (object) in
                guard let selfNotOptional = self,
                      let objectNotNil = object,
                      let token = (objectNotNil as? TokenJwt)?.token else {
                    self?.currentViewController.presentDefaultAlert(object as? DefaultServerError)
                    return
                }
                selfNotOptional.navigateLoggedArea(token)
            }).disposed(by: disposeBagViewModel)
        
        viewModel.actions.loginFailFillField
            .drive(onNext: { [weak self] (_) in
                self?.window.rootViewController?.presentedViewController?.presentDefaultAlert(message: "Preencha os campos de login")
            }).disposed(by: disposeBagViewModel)
        
        viewModel.actions.loading
            .drive(onNext: { [weak self] (value) in
                if let loadingView = self?.loadingView {
                    if value {
                        ProgressHUD.show()
                        self?.currentViewController.view.addSubview(loadingView)
                    } else {
                        ProgressHUD.dismiss()
                        loadingView.removeFromSuperview()
                    }
                }
            }).disposed(by: disposeBagViewModel)
    }
    
    func navigateLoggedArea(_ token: String) {
        NewsProvider.tokenJwt = token
        let loggedCoordinator = LoggedCoordinator(navigation: self.navigation)
        self.childCoordinators.append(loggedCoordinator)
        loggedCoordinator.logoutCoordinatorAction
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else {
                    return
                }
                self.currentViewController = self.prepareLoginViewController()
                self.navigation?.setViewControllers([self.currentViewController], animated: true)
            }).disposed(by: disposeBagViewModel)
        loggedCoordinator.start()
    }
}
