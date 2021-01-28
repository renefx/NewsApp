//
//  LoggedCoordinator.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation
import RxSwift
import Kingfisher

final class LoggedCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController?
    
    let disposeBagViewModel = DisposeBag()
    let newsService = NewsService()
    let logoutCoordinatorAction = PublishSubject<Void>()
    
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func start () {
        var newsListViewController = NewsListTableViewController.instantiate()
        var viewModel = NewsListViewModel(newsService)
        newsListViewController.disposeBag = disposeBagViewModel
        newsListViewController.bind(to: &viewModel)
        self.setListNewsActions(viewModel)
        
        navigation?.setViewControllers([newsListViewController], animated: true)
    }
    
    func setListNewsActions(_ viewModel: NewsListViewModel) {
        viewModel.actions.logout
            .bind { [weak self] (_) in
                self?.logoutCoordinatorAction.onNext(())
            }.disposed(by: disposeBagViewModel)
        
        viewModel.actions.navigateScreenDetail
            .subscribe { [weak self] (idNews) in
                self?.navigateDetail(idNews)
            }.disposed(by: disposeBagViewModel)
    }
    
    func navigateDetail(_ idNews: String?) {
        guard let idNews = idNews, let navigationController = navigation else {
            navigation?.viewControllers.first?.presentDefaultError(Constants.unknownError)
            return
        }
        var newsDetailViewController = NewsDetailTableViewController.instantiate()
        var viewModel = NewsDetailViewModel(newsService, idNews)
        newsDetailViewController.disposeBag = disposeBagViewModel
        newsDetailViewController.bind(to: &viewModel)
        self.setDetailNewsActions(viewModel)
        
        navigationController.pushViewController(newsDetailViewController, animated: true)
    }
    
    func setDetailNewsActions(_ viewModel: NewsDetailViewModel) {
        viewModel.actions.shareNews
            .subscribe(onNext: { [weak self] (elementNews) in
                guard let elementNews = elementNews else {
                    self?.navigation?.presentDefaultAlert(message: Constants.notFound)
                    return
                }
                let resource = ImageResource(downloadURL: elementNews.urlFormatted!)
                KingfisherManager.shared
                    .retrieveImage(with: resource, completionHandler: { (result) in
                        let image = try? result.get().image
                        self?.shareNewsAction(elementNews, image)
                    })
            }).disposed(by: disposeBagViewModel)
    }
    
    func shareNewsAction(_ document: Documento?, _ image: UIImage?) {
        let firstActivityItem = "Veja essa notícia: \n\(document?.titulo ?? "")"
        let secondActivityItem : NSURL = NSURL(string: document?.url ?? "")!
            
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.navigation?.present(activityViewController, animated: true, completion: nil)
    }
}
