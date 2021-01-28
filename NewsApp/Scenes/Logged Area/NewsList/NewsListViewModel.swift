//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct NewsListInputs: Inputs {
    var tapLogout: Observable<Void>
    var tapNavigateScreenDetail: Observable<NewsListElement>
    var loadServerData: Observable<Void>
    var reloadServerData: Observable<Void>
}

struct NewsListViewModelOutputs: Outputs {
    var loading: Driver<Bool>
    var reloadTableViewWith: Driver<[NewsListElement]>
}

struct NewsListActions: Actions {
    var logout: Observable<Void>
    var navigateScreenDetail: Observable<String?>
}

class NewsListViewModel: ViewModel {
    public var output: NewsListViewModelOutputs!
    public var actions: NewsListActions!
    
    private let disposeBag = DisposeBag()
    private let apiCallResult = BehaviorSubject<[NewsListElement]>(value: [])
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let service: NewsService
    
    init(_ service: NewsService) {
        self.service = service
    }
    
    func setUp(with input: NewsListInputs) {
        
        let idScreendDetail = input.tapNavigateScreenDetail
            .map { (element) -> String? in
                element.idDocumento
            }
        
        let mockLoadingResult = Observable.from(optional: isLoading)
            .filter({ (isLoading) -> Bool in
                (try? isLoading.value()) ?? false
            })
            .flatMapFirst({ (value) -> Observable<[NewsListElement]> in
                var arrayOfMocks = [NewsListElement]()
                arrayOfMocks.append(NewsListElement(mock: true))
                arrayOfMocks.append(NewsListElement(mock: true))
                arrayOfMocks.append(NewsListElement(mock: true))
                return Observable.of(arrayOfMocks)
            })
            .share()
        
        input.reloadServerData
            .subscribe(onNext: { [weak self] _ in
                self?.fetchNews()
            })
            .disposed(by: disposeBag)
            
        let reloadTableViewWith = Observable.combineLatest(apiCallResult, mockLoadingResult, isLoading)
            .flatMapLatest { (api, mock, isLoading) -> Observable<[NewsListElement]> in
                if isLoading {
                    return Observable.of(mock)
                } else {
                    return Observable.of(api)
                }
            }
        actions = NewsListActions(logout: input.tapLogout, navigateScreenDetail: idScreendDetail)
        
        output = NewsListViewModelOutputs(loading: isLoading.asDriver(onErrorJustReturn: false),
                                          reloadTableViewWith: reloadTableViewWith.asDriver(onErrorJustReturn: []))
    }
    
    func fetchNews() {
        self.isLoading.onNext(true)
        self.service.fetchNews().subscribe { [weak self] (response) in
            self?.isLoading.onNext(false)
            self?.apiCallResult.onNext(response)
        } onError: { [weak self] (erro) in
            self?.isLoading.onNext(false)
            self?.apiCallResult.onError(erro)
        }.disposed(by: self.disposeBag)
    }
    
}
