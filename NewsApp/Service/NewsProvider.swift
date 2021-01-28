//
//  NewsProvider.swift
//  NewsApp
//
//  Created by Renê Xavier on 25/01/21.
//

import Foundation
import Moya

enum NewsProvider {
    case getNewsToken(user: UserLogin)
    case getNews
    case getNewsDetail(newsId: String)
}

extension NewsProvider: TargetType {
    var baseURL: URL {
        if let baseUrl = URL(string: "https://teste-dev-mobile-api.herokuapp.com/") {
            return baseUrl
        }
        return URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .getNewsToken:
            return "login"
        case .getNews:
            return "news"
        case .getNewsDetail(newsId: let newsId):
            return "news/\(newsId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNewsToken:
            return .post
        case .getNews:
            return .get
        case .getNewsDetail:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getNews:
            return Bundle.loadJSONFromBundle(resourceName: "TokenJwt")
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getNewsToken(user: let user):
            return .requestJSONEncodable(user)
        case .getNews:
            return .requestPlain
        case .getNewsDetail(newsId: let newsId):
//            let parameters = ["": newsId]
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            return .requestPlain
        }
    }
    
    static var tokenJwt: String = ""
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer \(Self.tokenJwt)"]
    }
    
    
}
