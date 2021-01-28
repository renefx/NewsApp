//
//  Codable+Extension.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import Foundation

extension JSONDecoder {
    static func decode<T:Codable>(data: Data, to type: T.Type) throws -> T{
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw DefaultServerError(message: Constants.unknownError, statusCode: Constants.parsingError)
        }
    }
}
