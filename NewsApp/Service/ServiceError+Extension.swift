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
    func filterSuccess<T:Codable>(returnType: T.Type) -> Single<T> {
        return flatMap { (response) -> Single<T> in
            if 200 ... 299 ~= response.statusCode {
                let decoder = JSONDecoder()
                do {
                    let objectParsed = try decoder.decode(returnType, from: response.data)
                    return .just(objectParsed)
                } catch let e {
                    return .error(e)
                }
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
