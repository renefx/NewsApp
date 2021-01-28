//
//  NewsService.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import Foundation
import RxSwift
import Moya
import RxCocoa

class NewsService {
    var newsProvider = MoyaProvider<NewsProvider>()

    init(stub: Bool = false ) {
        newsProvider = stub ? MoyaProvider<NewsProvider>(stubClosure: MoyaProvider.immediatelyStub) : MoyaProvider<NewsProvider>()
    }
    
    func postNewsLogin(user: UserLogin) -> Single<TokenJwt> {
        return newsProvider.rx
            .request(.getNewsToken(user: user))
            .filterSuccess(returnType: TokenJwt.self)
    }

    func fetchNews() -> Single<[NewsListElement]> {
        return newsProvider.rx
            .request(.getNews)
            .filterSuccess(returnType: [NewsListElement].self)
    }

    func fetchNewsDetail(newsId: String) -> Single<Documento?> {
        return newsProvider.rx
            .request(.getNewsDetail(newsId: newsId))
            .filterSuccess(returnType: [NewsDetailWrapperElement].self)
            .map { (arrayWrapper) -> Documento? in
                arrayWrapper.first?.documento
            }
    }
}

