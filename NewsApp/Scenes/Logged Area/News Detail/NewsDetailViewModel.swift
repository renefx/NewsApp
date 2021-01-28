//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct NewsDetailInputs: Inputs {
    var tapShareNews: Observable<Void>
    var loadServerData: Observable<Void>
    var reloadServerData: Observable<Void>
}

struct NewsDetailViewModelOutputs: Outputs {
    var loading: Driver<Bool>
    var apiCallResult: Driver<Documento?>
}

struct NewsDetailActions: Actions {
    var shareNews: Observable<Documento?>
}

class NewsDetailViewModel: ViewModel {
    public var output: NewsDetailViewModelOutputs!
    public var actions: NewsDetailActions!
    
    private let disposeBag = DisposeBag()
    private let apiCallResult = PublishSubject<Documento?>()
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let service: NewsService
    private let idNews: String
    
    init(_ service: NewsService, _ idNews: String) {
        self.service = service
        self.idNews = idNews
    }
    
    func setUp(with input: NewsDetailInputs) {
        
        let shareNews = input.tapShareNews
            .withLatestFrom(apiCallResult)
        
        input.loadServerData
            .bind (onNext: { [weak self] (_) in
                self?.fetchNewsDetail()
            }).disposed(by: disposeBag)
        
        input.reloadServerData
            .subscribe(onNext: { [weak self] _ in
                self?.fetchNewsDetail()
            })
            .disposed(by: disposeBag)
            
        actions = NewsDetailActions(shareNews: shareNews)
        
        output = NewsDetailViewModelOutputs(loading: isLoading.asDriver(onErrorJustReturn: false),
                                            apiCallResult: apiCallResult.asDriver(onErrorJustReturn: nil))
    }
    
    func fetchNewsDetail() {
        self.isLoading.onNext(true)
        self.service.fetchNewsDetail(newsId: self.idNews)
            .subscribe(onSuccess: { [weak self] (response) in
                self?.isLoading.onNext(false)
                self?.apiCallResult.onNext(response)
            }, onError: { [weak self] (erro) in
                self?.isLoading.onNext(false)
                self?.apiCallResult.onError(erro)
            }).disposed(by: self.disposeBag)
    }
    
}
