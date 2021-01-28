//
//  ServiceError+Extension.swift
//  NewsApp
//
//  Created by Renê Xavier on 26/01/21.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func filterSuccess() -> Single<Element> {
        return flatMap { (response) -> Single<Element> in
            if 200 ... 299 ~= response.statusCode {
                return .just(response)
            }
            
            switch response.statusCode {
            case 501:
                let commonError = DefaultServerError(message: Constants.serviceUnavailableError, statusCode: nil)
                return .error(commonError)
            case -1009:
                let commonError = DefaultServerError(message: Constants.notConnectedToInternet, statusCode: nil)
                return .error(commonError)
            default: break
            }

            let decoder = JSONDecoder()
            do {
                var serverError = try decoder.decode(DefaultServerError.self, from: response.data)
                serverError.statusCode = response.statusCode
                return .error(serverError)
            } catch {
                let genericError = DefaultServerError(message: Constants.unknownError, statusCode: response.statusCode)
                return .error(genericError)
            }
        }
    }
}
